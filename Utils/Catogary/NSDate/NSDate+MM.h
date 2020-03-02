//
//  NSDate+MM.h
//  MMViewTracker
//
//  Created by Mikasa on 2020/2/25.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (MM)

/// 获取当前时间的秒数
+ (NSString *)currentTime;

/// 获取当前时间的毫秒数
+ (NSString *)currentMMTime;
@end

NS_ASSUME_NONNULL_END
