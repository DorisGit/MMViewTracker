//
//  UIView+MM.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/17.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "UIView+Tracker.h"
#import <objc/runtime.h>

@implementation UIView (Tracker)


/**
 获取指定View所在的Controller
 
 @return 当前所在Controller
 */
- (UIViewController *)currentControllerForView {
    
    UIViewController *currentCtrl;
    UIResponder *responder = [self.superview nextResponder];
    while (responder && ![responder isKindOfClass:[UIViewController class]]) {
        responder = [responder nextResponder];
    }
    currentCtrl = (UIViewController *)responder;
    return currentCtrl;
}

#pragma mark - GMViewExposureProtocol
/// 设置曝光数据
/// @param exposure exposure
- (void)setExposure:(NSDictionary *)exposure {
    
    // objc_setAssociatedObject 设置关联对象
    objc_setAssociatedObject(self, @selector(exposure), exposure, OBJC_ASSOCIATION_RETAIN);
}

- (NSDictionary *)exposure {
    return objc_getAssociatedObject(self, @selector(exposure));
}

/// 是否可见
/// @param visible visible
- (void)setVisible:(BOOL)visible {
    objc_setAssociatedObject(self, @selector(visible), @(visible), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)visible {
    return [objc_getAssociatedObject(self, @selector(visible)) boolValue];
}

/// 当前View所在的控制器
/// @param pageCtrl pageCtrl
- (void)setPageCtrl:(UIViewController *)pageCtrl {
    
    /// 模拟weak引用
    MMWeakObject *weakObject = [[MMWeakObject alloc] initWithObj:pageCtrl];
    objc_setAssociatedObject(self, @selector(pageCtrl), weakObject, OBJC_ASSOCIATION_RETAIN);
}

- (UIViewController *)pageCtrl {
    MMWeakObject *weakObject = objc_getAssociatedObject(self, @selector(pageCtrl));
    return weakObject.obj;
}
@end
