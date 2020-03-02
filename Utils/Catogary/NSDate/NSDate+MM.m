//
//  NSDate+MM.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/2/25.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "NSDate+MM.h"

@implementation NSDate (MM)

/**
 *  @brief 获取当前时间的秒数
 *  @since 0.0.1
 */
+ (NSString *)currentTime {
    NSDate *date = [NSDate date];
    NSTimeInterval interval = [date timeIntervalSince1970];
    NSString *timeIntervalStr = [NSString stringWithFormat:@"%ld",(long)interval];
    return timeIntervalStr;
}

/**
 获取当前时间的毫秒数

 @return v7.14.0
 */
+ (NSString *)currentMMTime {
    NSDate *date = [NSDate date];
    NSTimeInterval interval = [date timeIntervalSince1970];
    NSString *timeIntervalStr = [NSString stringWithFormat:@"%ld",(long)(interval*1000)];
    return timeIntervalStr;
}

@end
