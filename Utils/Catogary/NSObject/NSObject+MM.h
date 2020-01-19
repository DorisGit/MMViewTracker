//
//  NSObject+MM.h
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/17.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SafeValue(someValue) [GMSafeValue safeValue:someValue]
#define SafeString(str) [GMSafeValue safeString:str]
#define SafeNumber(num) [GMSafeValue safeNumber:num]
#define NullableString(str) [GMSafeValue nullableString:str]
#define NullableNumber(num) [GMSafeValue nullableNumber:num]


NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MM)

+ (nonnull id)safeValue:(id)object;

/*手动从字典中解析string或者number时使用下面4个方法*/

+ (nonnull NSString *)safeString:(id)str;
+ (nonnull NSNumber *)safeNumber:(id)num;
+ (nullable NSString *)nullableString:(id)str;
+ (nullable NSNumber *)nullableNumber:(id)num;
@end

NS_ASSUME_NONNULL_END
