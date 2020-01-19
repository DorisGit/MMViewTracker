//
//  MMTrackerMacro.h
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/15.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#ifndef MMTrackerMacro_h
#define MMTrackerMacro_h

// 颜色
#define MMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 颜色+透明度
#define MMColorAlpha(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
// 随机色
#define MMRandomColor MMColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
// 根据rgbValue获取对应的颜色
#define MMColorFromRGB(__rgbValue) [UIColor colorWithRed:((float)((__rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((__rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(__rgbValue & 0xFF))/255.0 alpha:1.0]

#define MMColorFromRGBAlpha(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

// 输出日志 (格式: [时间] [哪个方法] [哪行] [输出内容])
#ifdef DEBUG
#define NSLog(format, ...)  printf("\n[%s] %s [第%d行] 💕 %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);
#else

#define NSLog(format, ...)

#endif

// 是否为空对象
#define MMObjectIsNil(__object)  ((nil == __object) || [__object isKindOfClass:[NSNull class]])

// 字符串为空
#define MMStringIsEmpty(__string) ((__string.length == 0) || MMObjectIsNil(__string))

// 字符串不为空
#define MMStringIsNotEmpty(__string)  (!MMStringIsEmpty(__string))

// 数组为空
#define MMArrayIsEmpty(__array) ((MMObjectIsNil(__array)) || (__array.count==0))


// 打印方法
#define MMLogFunc NSLog(@"%s", __func__)
// 打印请求错误信息
#define MMLogError(error) NSLog(@"Error: %@", error)
// 销毁打印
#define MMDealloc NSLog(@"\n =========+++ %@  销毁了 +++======== \n",[self class])

#define MMLogLastError(db) NSLog(@"lastError: %@, lastErrorCode: %d, lastErrorMessage: %@", [db lastError], [db lastErrorCode], [db lastErrorMessage]);

#endif /* MMTrackerMacro_h */
