//
//  MMExposureManager.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/17.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "MMExposureManager.h"

@implementation MMExposureManager

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
    }
    return self;
}

#pragma mark - Verify ViewExposure

/**
 当前View上是否有需要精准曝光的数据
 
 @param view View
 @return yes/no
 */
+ (BOOL)haveExposureForView:(UIView *)view {
    
    if (view.exposure && view.exposure.allKeys.count > 0) {
        return YES;
    }
    return NO;
}

/**
 是否是需要精准曝光的View
 
 @param view view
 @return yes/no
 */
+ (BOOL)isTargetViewForExposure:(UIView *)view {
    
    return view.pageCtrl.needExpo;
}

/**
 是否需要忽略UITrackingRunLoopMode模式下的记录
 
 @param ignoreTracking 是否需要忽略
 @return 模式下的记录
 */
+ (BOOL)isNeedIgnoreTrackExposure:(BOOL)ignoreTracking {
    
    NSRunLoopMode mode = [NSRunLoop currentRunLoop].currentMode;
    if (ignoreTracking && [mode isEqualToString:UITrackingRunLoopMode]) {
        return YES;
    }
    return NO;
}

/**
 设置当前view是否可见状态
 
 @param view view
 @param recursive 是否递归子view
 */
+ (void)fetchViewForVisibleState:(UIView *)view recursive:(BOOL)recursive {
    
    BOOL ignoreTracking = YES;
    if ([MMExposureManager haveExposureForView:view] && [MMExposureManager isTargetViewForExposure:view]) {
        
        view.visible = [self isViewVisible:view];
        if (![MMExposureManager isNeedIgnoreTrackExposure:NO]) {
            
            [[MMExposureManager sharedManager] exposureStatusForView:view inPageCtrl:view.pageCtrl];
        } else {
            
            [[MMExposureManager sharedManager] synchronizeViewItemData:view];
        }
    }
    
    if (recursive) {
        for (UIView *subview in view.subviews) {
            if (!subview.pageCtrl) {
                subview.pageCtrl = view.pageCtrl;
            }
            [MMExposureManager fetchViewForVisibleState:subview recursive:recursive];
        }
    }
    
    if (![MMExposureManager isNeedIgnoreTrackExposure:ignoreTracking] && (!recursive || view.subviews.count == 0)) {
        [[MMExposureManager sharedManager] startStoreExposureData];
    }
    
    // NSLog(@"%@",view);
}

/**
 判断当前view是否可见
 
 @param view view
 @return yes/no
 */
+ (BOOL)isViewVisible:(UIView *)view {
    
    // NSLog(@"%@:%@:%d:%d:%f",view,view.window ,view.hidden,view.layer.hidden,view.alpha);
    
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
    
    /*
    // 当前曝光View 上数据曝光情况
    NSMutableDictionary *dictDataM = [NSMutableDictionary dictionaryWithDictionary:self.exposureDictM];
    for (NSString *key in dictDataM.allKeys) {
        
        UIView *exposureView = self.exposureViewDictM[key];
        // 当前view已经结束曝光 记录曝光数据---等待上传
        if (!exposureView) {
            NSString *page = [[key componentsSeparatedByString:@"/"] firstObject];
            UIViewController *pageCtrl = [GMExposureManager expoPageCtrl:page];
            [self storeExposureData:dictDataM[key] pageCtrl:pageCtrl];
            [self.exposureDictM removeObjectForKey:key];
        }
    }
    
    // 当前曝光数据是否仍在曝光-> 无存储曝光数据
    NSMutableDictionary *dictViewM = [NSMutableDictionary dictionaryWithDictionary:self.exposureViewDictM];
    for (NSString *key in dictViewM.allKeys) {
        NSDictionary *dataDict = self.exposureDictM[key];
        if (!dataDict) {
            UIView *view = dictViewM[key];
            [self storeStartExposureData:view pageCtrl:view.pageCtrl];
        }
    }*/
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
    
    /*
    // 无状态进入页面直接开启曝光
    NSString *viewKey = [MMExposureManager exposureKeyForView:startView];
    UIView *view = [self.exposureViewDictM objectForKey:viewKey];
    if (!view) {
        startView.expoStatus = GMViewExpoStatusStart;
        [self.exposureViewDictM setObject:startView forKey:viewKey];
    }*/
}


/**
 view在当前页面结束可见（曝光结束）
 
 @param endView 目标view
 @param inPageCtrl 指定页面
 */
- (void)view:(UIView *)endView endVisibleInPageCtrl:(UIViewController *)inPageCtrl {
    
    /*
    if ([self.exposureViewDictM.allValues containsObject:endView]) {
        NSArray *keys = [self.exposureViewDictM allKeysForObject:endView];
        for (NSString *key in keys) {
            [self.exposureViewDictM removeObjectForKey:key];
        }
    }*/
}


@end
