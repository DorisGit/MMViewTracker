//
//  NSString+MM.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/16.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "NSString+MM.h"

@implementation NSString (MM)

- (BOOL)isNonEmpty {
    
    NSMutableCharacterSet *emptyStringSet = [[NSMutableCharacterSet alloc] init];
    [emptyStringSet formUnionWithCharacterSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [emptyStringSet formUnionWithCharacterSet: [NSCharacterSet characterSetWithCharactersInString: @"　"]];
    if ([self length] == 0) {
        return NO;
    }
    NSString* str = [self stringByTrimmingCharactersInSet:emptyStringSet];
    return [str length] > 0;
}

@end
