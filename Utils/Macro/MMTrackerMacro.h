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
#define MM_SCREEN_WIDTH  ([[UIScreen mainScreen] bounds].size.width)
#define MM_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define MM_SCREEN_BOUNDS ([[UIScreen mainScreen] bounds])
#define MM_SCREEN_MAX_LENGTH (MAX(MM_SCREEN_WIDTH, MM_SCREEN_HEIGHT))
#define MM_SCREEN_MIN_LENGTH (MIN(MM_SCREEN_WIDTH, MM_SCREEN_HEIGHT))

// 是否为空对象
#define MMObjectIsNil(__object)  ((nil == __object) || [__object isKindOfClass:[NSNull class]])

// 字符串为空
#define MMStringIsEmpty(__string) ((__string.length == 0) || MMObjectIsNil(__string))

// 字符串不为空
#define MMStringIsNotEmpty(__string)  (!MMStringIsEmpty(__string))

// 数组为空
#define MMArrayIsEmpty(__array) ((MMObjectIsNil(__array)) || (__array.count==0))

/// 适配iPhone X + iOS 11
#define  MMAdjustsScrollViewInsets_Never(__scrollView)\
do {\
_Pragma("clang diagnostic push")\
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
if ([__scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
NSInteger argument = 2;\
invocation.target = __scrollView;\
invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
[invocation setArgument:&argument atIndex:2];\
[invocation retainArguments];\
[invocation invoke];\
}\
_Pragma("clang diagnostic pop")\
} while (0)


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


// 卡片瀑布流相关
#define kCardItemSpacing 6
#define kCardLineSpacing 6
#define kCardLeftRightSpacing 8
#define kCardTopBottomSpacing 10
#define kCardContenLefRignt 8
#define kCardContenMaxHeight 34

#define kGMCardContentFont [UIFont gmBoldFont:14]
#define kGMCardTagFont [UIFont gmFont:11]

#define kCardCellWidth  ceilf((MM_SCREEN_WIDTH - kCardLeftRightSpacing - kCardItemSpacing - kCardLeftRightSpacing)/2)

#endif /* MMTrackerMacro_h */
