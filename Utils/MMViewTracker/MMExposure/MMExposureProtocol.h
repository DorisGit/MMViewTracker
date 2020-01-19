//
//  MMExposureProtocol.h
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/17.
//  Copyright © 2020 Mikasa. All rights reserved.
//
#import "NSObject+Swizzle.h"

typedef NS_ENUM(NSInteger, GMViewExpoStatus) {
    GMViewExpoStatusNone    = 0,// 无状态
    GMViewExpoStatusStart   = 1,// 开始曝光
    GMViewExpoStatusIng     = 2,// 正在曝光(暂未使用，暂时先保留)
    GMViewExpoStatusEnd     = 3 // 结束曝光
};

@protocol MMExposureProtocol <NSObject>
@optional
/** 精准曝光数据 */
@property (nonatomic, strong) NSDictionary *exposure;

/// needExpo
@property (nonatomic, assign) BOOL needExpo;

@end

@protocol GMViewExposureProtocol <NSObject>
@optional
/// visible
@property (nonatomic, assign) BOOL visible;
@property (nonatomic, weak) UIViewController *pageCtrl;// 当前viewz所在页面
/** view别名 */
@property (nonatomic, copy) NSString *viewName;
/** view别名 */
@property (nonatomic, copy) NSString *inTime;
/** view别名 */
@property (nonatomic, copy) NSString *outTime;
/** 绝对位置 */
@property (nonatomic, copy) NSString *absolute_position;
/** 相对位置(相对屏幕所在位置)*/
@property (nonatomic, copy) NSString *relative_position;
/** 额外参数*/
@property (nonatomic, strong) NSDictionary *extra_param;
/** 曝光状态 */
@property (nonatomic, assign) GMViewExpoStatus expoStatus;

@end



