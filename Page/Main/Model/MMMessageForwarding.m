//
//  MMMessageForwarding.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/5/6.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "MMMessageForwarding.h"

@implementation MMMessageForwarding

void dynamicMethodIMP(id self, SEL _cmd) {
    NSLog(@" >> dynamicMethodIMP");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    
    if (sel == @selector(forwarding)) {
        class_addMethod([self class], sel, (IMP)dynamicMethodIMP, "v@:");
        return YES;
    }
    
    return [super resolveInstanceMethod:sel];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"%@",anInvocation);
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"%@",NSStringFromSelector(aSelector));
    return nil;
}

@end
