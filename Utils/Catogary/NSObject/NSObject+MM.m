//
//  NSObject+MM.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/17.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "NSObject+MM.h"


@implementation NSObject (MM)

+ (id)safeValue:(id)object {
    return object ?: [NSNull null];
}

+ (NSString *)safeString:(id)str {
    if ([str isKindOfClass:[NSNumber class]]) {
        return ((NSNumber *)str).stringValue;
    }
    return str ?: @"";
}

+ (NSNumber *)safeNumber:(id)num {
    if ([num isKindOfClass:[NSString class]]) {
        return @(((NSString *)num).integerValue);
    }
    return num ?: @0;
}

+ (nullable NSString *)nullableString:(id)str {
    if ([str isKindOfClass:[NSNumber class]]) {
        return ((NSNumber *)str).stringValue;
    }
    return str ?: nil;
}

+ (nullable NSNumber *)nullableNumber:(id)num {
    if ([num isKindOfClass:[NSString class]]) {
        return @(((NSString *)num).integerValue);
    }
    return num ?: nil;
}

@end
