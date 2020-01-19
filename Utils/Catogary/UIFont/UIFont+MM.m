//
//  UIFont+MM.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/19.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "UIFont+MM.h"

/*
 Family:'PingFang SC'
 font:'PingFangSC-Medium'
 font:'PingFangSC-Semibold'
 font:'PingFangSC-Light'
 font:'PingFangSC-Ultralight'
 font:'PingFangSC-Regular'
 font:'PingFangSC-Thin'
 */

/// 极细体
static NSString *const MMPingFangSC_Ultralight  = @"PingFangSC-Ultralight";
/// 常规体
static NSString *const MMPingFangSC_Regular     = @"PingFangSC-Regular";
/// 中粗体
static NSString *const MMPingFangSC_Semibold    = @"PingFangSC-Semibold";
/// 纤细体
static NSString *const MMPingFangSC_Thin        = @"PingFangSC-Thin";
/// 细体
static NSString *const MMPingFangSC_Light       = @"PingFangSC-Light";
/// 中黑体
static NSString *const MMPingFangSC_Medium      = @"PingFangSC-Medium";

@implementation UIFont (MM)

+ (UIFont *)mm_regularFont:(NSInteger)size {
    if (@available(iOS 9.0, *)) {
        return [UIFont fontWithName:MMPingFangSC_Regular size:size];
    } else {
        return [UIFont systemFontOfSize:size];
    }
}

+ (UIFont *)mm_mediumFont:(NSInteger)size {
    if (@available(iOS 9.0, *)) {
        return [UIFont fontWithName:MMPingFangSC_Medium size:size];
    } else {
        return [UIFont boldSystemFontOfSize:size];
    }
}

+ (UIFont *)mm_lightFont:(NSInteger)size {
    if (@available(iOS 9.0, *)) {
        return [UIFont fontWithName:MMPingFangSC_Light size:size];
    } else {
        return [UIFont systemFontOfSize:size];
    }
}

@end
