//
//  UIScrollView+MM.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/2/26.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "UIScrollView+MM.h"
#import "NSObject+Swizzle.h"

@implementation UIScrollView (MM)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIScrollView swizzleInstanceMethod:@selector(setDelegate:) withSelector:@selector(swizzle_setDelegate:)];
    });
}

- (void)swizzle_setDelegate:(id<UIScrollViewDelegate>)delegate {
    
    [self swizzle_setDelegate:delegate];
    if (self.delegate != delegate) {
        
    }
    SEL beginDragging = @selector(scrollViewWillBeginDragging:);
    
    [UIScrollView swizzleInstanceMethod:beginDragging withReplacement:^id(IMP original, __unsafe_unretained Class swizzledClass, SEL selector) {
        return ;
    }];
}
@end
