//
//  UINavigationBar+MM.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/20.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "UINavigationBar+MM.h"

@implementation UINavigationBar (MM)

+ (CGFloat)barHeight {
    return [self statusBarHeight] + 44;
}

+ (CGFloat)statusBarHeight {
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height;
    return height;
}


@end
