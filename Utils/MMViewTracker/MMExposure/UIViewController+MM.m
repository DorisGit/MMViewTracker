//
//  UIViewController+MM.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/17.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "UIViewController+MM.h"
#import <objc/runtime.h>

@implementation UIViewController (MM)

+ (void)load {
    [self swizzleInstanceMethod:@selector(viewDidAppear:) withSelector:@selector(swizzle_viewDidAppear:)];
    [self swizzleInstanceMethod:@selector(viewDidDisappear:) withSelector:@selector(swizzle_viewDidDisappear:)];
}

- (void)swizzle_viewDidAppear:(BOOL)animated {
    [self swizzle_viewDidAppear:animated];
    
    if (self.needExpo) {
        
        [MMExposureManager fetchViewForVisibleState:self.view recursive:YES];
    }
}

- (void)swizzle_viewDidDisappear:(BOOL)animated {
    [self swizzle_viewDidDisappear:animated];
    
}

/// 是否需要曝光
/// @param needExpo needExpo
- (void)setNeedExpo:(BOOL)needExpo {
    objc_setAssociatedObject(self, @selector(needExpo), @(needExpo), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)needExpo {
   return [objc_getAssociatedObject(self, @selector(needExpo)) boolValue];
}

@end
