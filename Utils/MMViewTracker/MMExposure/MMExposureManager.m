//
//  MMExposureManager.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/17.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "MMExposureManager.h"
#import "NSDate+MM.h"
#import "MMExposureItemModel.h"

@interface MMExposureManager ()
/// 正在处理曝光的view
@property (nonatomic, strong) NSMutableDictionary *viewDictM;
/// 正在处理曝光的数据集合
@property (nonatomic, strong) NSMutableDictionary *dataDictM;
/// 曝光完毕的数据存储集合
@property (nonatomic, strong) NSMutableDictionary *pageItemDictM;
@end

@implementation MMExposureManager

NS_INLINE NSString *MMExposureKeyForPage(UIViewController *page) {
    return [NSString stringWithFormat:@"%p",page];
}

NS_INLINE NSString *MMExposureKeyForView(UIView *view) {
    return [NSString stringWithFormat:@"%p%p",view,view.exposure];
}

NS_INLINE UIViewController *MMPageKeyForViewCtroller(NSString *pageAddress) {
    uintptr_t hex = strtoull(pageAddress.UTF8String, NULL, 0);
    id gotcha = (__bridge id)(void *)hex;
    UIViewController *pageCtrl = (UIViewController *)gotcha;
    return pageCtrl;
}

#pragma mark - Verify ViewExposure

/// 当前View上是否有需要精准曝光的数据
/// @param view view
NS_INLINE BOOL MMHaveExposureForView(UIView *view) {
    if (view.exposure && view.exposure.allKeys.count > 0) {
        return YES;
    }
    return NO;
}

/// 是否是需要精准曝光的View
/// @param view view
NS_INLINE BOOL MMIsTargetViewForExposure(UIView *view) {
    return view.pageCtrl.needExpo;
}

/// 是否需要忽略UITrackingRunLoopMode模式下的记录
/// @param ignoreTracking ignoreTracking 是否需要忽略
NS_INLINE BOOL MMIsNeedIgnoreTrackExposure(BOOL ignoreTracking) {
    NSRunLoopMode mode = [NSRunLoop currentRunLoop].currentMode;
    if (ignoreTracking && [mode isEqualToString:UITrackingRunLoopMode]) {
        return YES;
    }
    return NO;
}

+ (instancetype)sharedManager {
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        _debugLog = YES;
        _viewDictM = [NSMutableDictionary dictionary];
        _dataDictM = [NSMutableDictionary dictionary];
        _pageItemDictM = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Visible
/**
 设置当前view是否可见状态
 
 @param view view
 @param recursive 是否递归子view
 */
+ (void)fetchViewForVisibleState:(UIView *)view recursive:(BOOL)recursive {
    
    if (MMHaveExposureForView(view) && MMIsTargetViewForExposure(view)) {
        
        view.visible = [self isViewVisible:view];
        [[MMExposureManager sharedManager] exposureStatusForView:view inPageCtrl:view.pageCtrl];
    }
    
    if (recursive) {
        for (UIView *subview in view.subviews) {
            if (!subview.pageCtrl) {
                subview.pageCtrl = [view currentControllerForView];
#if MMExposureDebugLog
                NSLog(@"%@---所在的页面：%@",subview,subview.pageCtrl);
#endif
            }
            [MMExposureManager fetchViewForVisibleState:subview recursive:recursive];
        }
    }
    
    if ((!recursive || !view.subviews.count)) {
        [[MMExposureManager sharedManager] startStoreExposureData];
    }
}

/**
 判断当前view是否可见
 
 @param view view
 @return yes/no
 */
+ (BOOL)isViewVisible:(UIView *)view {
    
    #ifdef MMExposureDebugLog
        NSLog(@"%@:%@:%d:%d:%f",view,view.window ,view.hidden,view.layer.hidden,view.alpha);
    #endif
    
    // 可见
    if (!view.window || view.hidden || view.layer.hidden || !view.alpha) {
        
        return NO;
    }
    
    // App进入后台，当前view均置为不可见
    if ([MMExposureManager sharedManager].inBackground) {
        return NO;
    }
    
    UIView *current = view;
    while ([current isKindOfClass:[UIView class]]) {
        if (current.alpha <= 0 || current.hidden) {
            return NO;
        }
        current = current.superview;
    }
    
    // 判断当前View 与 view所在window是否存在交集
    CGRect viewRectInWindow = [view convertRect:view.bounds toView:view.window];
    BOOL isIntersects = CGRectIntersectsRect(view.window.bounds, viewRectInWindow);
    
    if (isIntersects) {
        // 获取View 与 view所在window的相交区域
        CGRect intersectRect = CGRectIntersection(view.window.bounds, viewRectInWindow);
        if (intersectRect.size.width != 0.f && intersectRect.size.height != 0.f) {
            // size > exposureDimThreshold 视为可见
            CGFloat dimThreshold = [MMExposureManager sharedManager].exposureDimThreshold;
            if (intersectRect.size.width / viewRectInWindow.size.width > dimThreshold &&
                intersectRect.size.height / viewRectInWindow.size.height > dimThreshold) {
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark - Deal Data
// 存储曝光数据
- (void)startStoreExposureData {
    
    
    // 当前曝光View 上数据曝光情况
    NSMutableDictionary *dictDataM = [NSMutableDictionary dictionaryWithDictionary:self.dataDictM];
    for (NSString *key in dictDataM.allKeys) {
        
        UIView *exposureView = self.viewDictM[key];
        // 当前view已经结束曝光 记录曝光数据---等待上传
        if (!exposureView) {
            NSString *page = [[key componentsSeparatedByString:@"/"] firstObject];
            UIViewController *pageCtrl = MMPageKeyForViewCtroller(page);
            [self storeEndExposureData:dictDataM[key] pageCtrl:pageCtrl];
            [self.dataDictM removeObjectForKey:key];
        }
    }
    
    // 当前曝光数据是否仍在曝光-> 无存储曝光数据
    NSMutableDictionary *dictViewM = [NSMutableDictionary dictionaryWithDictionary:self.viewDictM];
    for (NSString *key in dictViewM.allKeys) {
        NSDictionary *dataDict = self.dataDictM[key];
        if (!dataDict) {
            UIView *view = dictViewM[key];
            [self storeStartExposureData:view pageCtrl:view.pageCtrl];
        }
    }
}

// 存储开始曝光数据
- (void)storeStartExposureData:(UIView *)startView pageCtrl:(UIViewController *)pageCtrl {
    
    NSMutableDictionary *exposureDictM = self.dataDictM;
    startView.inTime = [NSDate currentMMTime];
    startView.expoStatus = GMViewExpoStatusStart;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:startView.exposure];
    // 安卓没有这个功能 暂时屏蔽
    [dict setObject:SafeString([NSDate currentMMTime]) forKey:@"inTime"];
    
    // 获取卡片位置
    [dict setObject:SafeString(startView.relative_position) forKey:@"relative_position"];
    [dict setObject:SafeString(startView.absolute_position) forKey:@"absolute_position"];
    
    if (startView.extra_param && startView.extra_param.allKeys.count > 0) {
        [dict addEntriesFromDictionary:startView.extra_param];
    }
    [exposureDictM setObject:dict forKey:MMExposureKeyForView(startView)];
}

/// 按指定页面存储曝光数据
/// @param expoDict 曝光数据
/// @param pageCtrl 指定页面
- (void)storeEndExposureData:(NSDictionary *)expoDict pageCtrl:(UIViewController *)pageCtrl{
    
    // 卡片曝光持续时间超出曝光最少时长才进行记录
    /*
    NSInteger inTime = [expoDict[@"inTime"] integerValue];
    NSInteger duration = [view.outTime integerValue] - [view.inTime integerValue];
    if (!duration) {
        return;
    }*/
    
    // 将曝光数据所需要的某些参数从Page中取出
    NSString *pageKey = MMExposureKeyForPage(pageCtrl);
    MMExposureItemModel *itemModel = [self.pageItemDictM objectForKey:pageKey];
    if (!itemModel) {
        itemModel = [MMExposureItemModel new];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:expoDict];
    /* 安卓没有此功能 暂屏蔽
    if (![dict[@"outTime"] isNonEmpty]) {
        [dict setObject:SafeString([PhobosUtil currentTime]) forKey:@"outTime"];
    }*/
    [itemModel.exposure_cards addObject:dict];
    [self.pageItemDictM setObject:itemModel forKey:pageKey];
}

// 同步Item数据
- (void)synchronizeViewItemData:(UIView *)view {
    
    /*
    NSMutableDictionary *dict = [self.exposureDictM objectForKey:[GMExposureManager exposureKeyForData:view]];
    if (dict) {
        if (view.extra_param && view.extra_param.allKeys.count > 0) {
            [dict addEntriesFromDictionary:view.extra_param];
        }
        [self.exposureDictM setObject:dict forKey:[GMExposureManager exposureKeyForData:view]];
    }*/
}

#pragma mark - View Visible/UnVisibel

/** 设置view的曝光状态
 * view 可见 && 状态none或者end——> 开始曝光
 * view 可见 && 状态start——> 正在曝光,不做处理
 * view 不可见 && 状态start ——> 结束曝光
 * view 不可见 && 状态none或者end ——> 不做处理
 */
- (void)exposureStatusForView:(UIView *)view inPageCtrl:(UIViewController *)inPageCtrl {
    
    // GMViewExpoStatus status = view.expoStatus;
    if (view.visible) {
        // 开始曝光
        [self view:view startVisibleInPageCtrl:inPageCtrl];
    } else {
        // 结束曝光
        [self view:view endVisibleInPageCtrl:inPageCtrl];
    }
}

/**
 view 在当前页面开始可见（开始曝光）
 
 @param startView 目标view
 @param inPageCtrl inPageViewContrl 当前页面
 */
- (void)view:(UIView *)startView startVisibleInPageCtrl:(UIViewController *)inPageCtrl {
    
    
    // 无状态进入页面直接开启曝光
    NSString *viewKey = MMExposureKeyForView(startView);
    UIView *view = [self.viewDictM objectForKey:viewKey];
    if (!view) {
        startView.expoStatus = GMViewExpoStatusStart;
        [self.viewDictM setObject:startView forKey:viewKey];
    }
}


/**
 view在当前页面结束可见（曝光结束）
 
 @param endView 目标view
 @param inPageCtrl 指定页面
 */
- (void)view:(UIView *)endView endVisibleInPageCtrl:(UIViewController *)inPageCtrl {
    
    if ([self.viewDictM.allValues containsObject:endView]) {
        NSArray *keys = [self.viewDictM allKeysForObject:endView];
        for (NSString *key in keys) {
            [self.viewDictM removeObjectForKey:key];
        }
    }
}


@end
