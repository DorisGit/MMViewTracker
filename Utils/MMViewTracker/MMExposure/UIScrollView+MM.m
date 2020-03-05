//
//  UIScrollView+MM.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/2/26.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "UIScrollView+MM.h"
#import "NSObject+Swizzle.h"
#import "MMExposureManager.h"

@implementation UIScrollView (MM)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIScrollView swizzleInstanceMethod:@selector(setDelegate:) withSelector:@selector(swizzle_setDelegate:)];
    });
}

- (void)swizzle_setDelegate:(id<UIScrollViewDelegate>)delegate {
    
    [self swizzle_setDelegate:delegate];
    
    SEL beginDragging = @selector(scrollViewWillBeginDragging:);
    
    __weak typeof(self) weakSelf = self;
    [delegate.class swizzleInstanceMethod:beginDragging
                          withReplacement:^id(IMP original, __unsafe_unretained Class swizzledClass, SEL selector) {
        return MethodSwizzlerReplacement(void, id, UIScrollView *scrollView) {
            MethodSwizzlerOriginalImplementation(void(*)(id, SEL, id), scrollView);
            
            if (scrollView.pageCtrl.needExpo) {
                NSLog(@"-----");
                [MMExposureManager fetchViewForVisibleState:scrollView recursive:YES];
            }
        };
    }];
    
    SEL endDragging = @selector(scrollViewDidEndDragging:willDecelerate:);
    [delegate.class swizzleClassMethod:endDragging
                       withReplacement:^id(IMP original, __unsafe_unretained Class swizzledClass, SEL selector) {
        return MethodSwizzlerReplacement(void, id, UIScrollView *scrollView, BOOL decelerate) {
            MethodSwizzlerOriginalImplementation(void(*)(id, SEL, id, BOOL), scrollView, decelerate);
            
            __strong UIView *strongSelf = weakSelf;
            if (scrollView.pageCtrl.needExpo && !decelerate) {
                NSLog(@"-----");
                [MMExposureManager fetchViewForVisibleState:scrollView recursive:YES];
            }
        };
    }];
}

@end
