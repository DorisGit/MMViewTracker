//
//  MMTrackerMacro.h
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/15.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#ifndef MMTrackerMacro_h
#define MMTrackerMacro_h

/// 屏幕尺寸相关
#define MH_SCREEN_WIDTH  ([[UIScreen mainScreen] bounds].size.width)
#define MH_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define MH_SCREEN_BOUNDS ([[UIScreen mainScreen] bounds])
#define MH_SCREEN_MAX_LENGTH (MAX(MH_SCREEN_WIDTH, MH_SCREEN_HEIGHT))
#define MH_SCREEN_MIN_LENGTH (MIN(MH_SCREEN_WIDTH, MH_SCREEN_HEIGHT))

// 是否为空对象
#define MMObjectIsNil(__object)  ((nil == __object) || [__object isKindOfClass:[NSNull class]])

// 字符串为空
#define MMStringIsEmpty(__string) ((__string.length == 0) || MMObjectIsNil(__string))

// 字符串不为空
#define MMStringIsNotEmpty(__string)  (!MMStringIsEmpty(__string))

// 数组为空
#define MMArrayIsEmpty(__array) ((MMObjectIsNil(__array)) || (__array.count==0))



// 输出日志 (格式: [时间] [哪个方法] [哪行] [输出内容])
#ifdef DEBUG
#define NSLog(format, ...)  printf("\n[%s] %s [第%d行] 💕 %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);
#else

#define NSLog(format, ...)

#endif

// 打印方法
#define MMLogFunc NSLog(@"%s", __func__)
// 打印请求错误信息
#define MMLogError(error) NSLog(@"Error: %@", error)
// 销毁打印
#define MMDealloc NSLog(@"\n =========+++ %@  销毁了 +++======== \n",[self class])

#define MMLogLastError(db) NSLog(@"lastError: %@, lastErrorCode: %d, lastErrorMessage: %@", [db lastError], [db lastErrorCode], [db lastErrorMessage]);

#endif /* MMTrackerMacro_h */
