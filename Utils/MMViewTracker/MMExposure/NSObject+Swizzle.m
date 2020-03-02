//
//  NSObject+Swizzle.m
//  Mikasa
//
//  Created by Mikasa on 2019/6/19.
//  Copyright © 2019 Mikasa. All rights reserved.
//

#import "NSObject+Swizzle.h"
#import <objc/runtime.h>
#import <libkern/OSAtomic.h>

static OSSpinLock lock = OS_SPINLOCK_INIT;
static NSMutableDictionary *originalClassMethods;
static NSMutableDictionary *originalInstanceMethods;

#pragma mark - Global Method
NS_INLINE void classSwizzleMethod(Class cls, Method method, IMP newImp) {
    if (!class_addMethod(cls, method_getName(method), newImp, method_getTypeEncoding(method))) {
        // class already has implementation, swizzle it instead
        method_setImplementation(method, newImp);
    }
}

NS_INLINE IMP originalClassMethodImplementation(__unsafe_unretained Class class, SEL selector, BOOL fetchOnly) {
    
    if (!originalClassMethods) {
        originalClassMethods = [[NSMutableDictionary alloc] init];
    }
    
    NSString *classKey = NSStringFromClass(class);
    NSString *selectorKey = NSStringFromSelector(selector);
    
    NSMutableDictionary *classSwizzles = originalClassMethods[classKey];
    
    NSValue *pointerValue = classSwizzles[selectorKey];
    
    if (!classSwizzles) {
        classSwizzles = [NSMutableDictionary dictionary];
        
        originalClassMethods[classKey] = classSwizzles;
    }
    
    IMP orig = NULL;
    
    if (pointerValue) {
        orig = [pointerValue pointerValue];
        
        if (fetchOnly) {
            if (classSwizzles.count == 1) {
                [originalClassMethods removeObjectForKey:classKey];
            }
            else {
                [classSwizzles removeObjectForKey:selectorKey];
            }
        }
    }
    else if (!fetchOnly) {
        orig = (IMP)[class methodForSelector:selector];
        
        classSwizzles[selectorKey] = [NSValue valueWithPointer:orig];
    }
    
    if (classSwizzles.count == 0) {
        [originalClassMethods removeObjectForKey:classKey];
    }
    
    if (originalClassMethods.count == 0) {
        originalClassMethods = nil;
    }
    
    return orig;
}

NS_INLINE IMP originalInstanceMethodImplementation(__unsafe_unretained Class class, SEL selector, BOOL fetchOnly) {
    if (!originalInstanceMethods) {
        originalInstanceMethods = [[NSMutableDictionary alloc] init];
    }
    
    NSString *classKey = NSStringFromClass(class);
    NSString *selectorKey = NSStringFromSelector(selector);
    
    NSMutableDictionary *classSwizzles = originalInstanceMethods[classKey];
    
    NSValue *pointerValue = classSwizzles[selectorKey];
    
    if (!classSwizzles) {
        classSwizzles = [NSMutableDictionary dictionary];
        
        originalInstanceMethods[classKey] = classSwizzles;
    }
    
    IMP orig = NULL;
    
    if (pointerValue) {
        orig = [pointerValue pointerValue];
        
        if (fetchOnly) {
            [classSwizzles removeObjectForKey:selectorKey];
            if (classSwizzles.count == 0) {
                [originalInstanceMethods removeObjectForKey:classKey];
            }
        }
    } else if (!fetchOnly) {
        orig = (IMP)[class instanceMethodForSelector:selector];
        
        classSwizzles[selectorKey] = [NSValue valueWithPointer:orig];
    }
    
    if (classSwizzles.count == 0) {
        [originalInstanceMethods removeObjectForKey:classKey];
    }
    
    if (originalInstanceMethods.count == 0) {
        originalInstanceMethods = nil;
    }
    
    return orig;
}

#pragma mark - Deswizzling Global Swizzles
NS_INLINE BOOL deswizzleClassMethod(__unsafe_unretained Class class, SEL selector) {
    OSSpinLockLock(&lock);
    
    IMP originalIMP = originalClassMethodImplementation(class, selector, YES);
    
    if (originalIMP) {
        method_setImplementation(class_getClassMethod(class, selector), (IMP)originalIMP);
        OSSpinLockUnlock(&lock);
        return YES;
    } else {
        OSSpinLockUnlock(&lock);
        return NO;
    }
}

NS_INLINE BOOL deswizzleInstanceMethod(__unsafe_unretained Class class, SEL selector) {
    OSSpinLockLock(&lock);
    
    IMP originalIMP = originalInstanceMethodImplementation(class, selector, YES);
    
    if (originalIMP) {
        method_setImplementation(class_getInstanceMethod(class, selector), (IMP)originalIMP);
        OSSpinLockUnlock(&lock);
        return YES;
    } else {
        OSSpinLockUnlock(&lock);
        return NO;
    }
}

NS_INLINE BOOL deswizzleAllClassMethods(__unsafe_unretained Class class) {
    OSSpinLockLock(&lock);
    BOOL success = NO;
    NSDictionary *d = [originalClassMethods[NSStringFromClass(class)] copy];
    for (NSString *sel in d) {
        OSSpinLockUnlock(&lock);
        if (deswizzleClassMethod(class, NSSelectorFromString(sel))) {
            success = YES;
        }
        OSSpinLockLock(&lock);
    }
    OSSpinLockUnlock(&lock);
    return success;
}

NS_INLINE BOOL deswizzleAllInstanceMethods(__unsafe_unretained Class class) {
    OSSpinLockLock(&lock);
    BOOL success = NO;
    NSDictionary *d = [originalInstanceMethods[NSStringFromClass(class)] copy];
    for (NSString *sel in d) {
        OSSpinLockUnlock(&lock);
        if (deswizzleInstanceMethod(class, NSSelectorFromString(sel))) {
            success = YES;
        }
        OSSpinLockLock(&lock);
    }
    OSSpinLockUnlock(&lock);
    return success;
}

BOOL deswizzleAll(void) {
    
    BOOL success = NO;
    OSSpinLockLock(&lock);
    NSDictionary *d = originalClassMethods.copy;
    for (NSString *classKey in d) {
        OSSpinLockUnlock(&lock);
        BOOL ok = [NSClassFromString(classKey) deswizzleAllMethods];
        OSSpinLockLock(&lock);
        if (success != ok) {
            success = YES;
        }
    }
    
    NSDictionary *d1 = originalInstanceMethods.copy;
    for (NSString *classKey in d1) {
        OSSpinLockUnlock(&lock);
        BOOL ok = [NSClassFromString(classKey) deswizzleAllMethods];
        OSSpinLockLock(&lock);
        if (success != ok) {
            success = YES;
        }
    }
    OSSpinLockUnlock(&lock);
    
    return success;
    
    return YES;
}

#pragma mark - Global Swizzle Method
NS_INLINE void swizzleClassMethod(__unsafe_unretained Class class, SEL selector, MethodSwizzlerProvider replacement) {
    
    OSSpinLockLock(&lock);
    
    Method originalMethod = class_getClassMethod(class, selector);
    IMP orig = originalClassMethodImplementation(class, selector, NO);
    id replaceBlock = replacement(orig, class, selector);
    Class meta = object_getClass(class);
    
    classSwizzleMethod(meta, originalMethod, imp_implementationWithBlock(replaceBlock));
    
    OSSpinLockUnlock(&lock);
}

NS_INLINE void swizzleInstanceMethod(__unsafe_unretained Class class, SEL selector, MethodSwizzlerProvider replacement) {
    
    OSSpinLockLock(&lock);
    Method originalMethod = class_getInstanceMethod(class, selector);
    
    IMP orig = originalInstanceMethodImplementation(class, selector, NO);
    id replaceBlock = replacement(orig, class, selector);
    IMP replace = imp_implementationWithBlock(replaceBlock);
    
    classSwizzleMethod(class, originalMethod, replace);
    OSSpinLockUnlock(&lock);
}

@implementation NSObject (SwizzleMethod)

+ (void)swizzleClassMethod:(SEL)selector withReplacement:(MethodSwizzlerProvider)replacementProvider {
    swizzleClassMethod(self, selector, replacementProvider);
}

+ (void)swizzleInstanceMethod:(SEL)selector withReplacement:(MethodSwizzlerProvider)replacementProvider {
    swizzleInstanceMethod(self, selector, replacementProvider);
}

+ (void)swizzleInstanceMethod:(SEL)originalSelector withSelector:(SEL)swizzledSelector {
    
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(self,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(self,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)swizzelInstanceMethodForClass:(Class)originalClass originalSel:(SEL)originalSel swizzledClass:(Class)swizzledClass swizzledSelector:(SEL)swizzledSelector noneSel:(SEL)noneSel {
    
    Method originalMethod = class_getInstanceMethod(originalClass, originalSel);
    Method swizzingMethod = class_getInstanceMethod(swizzledClass, swizzledSelector);
    
    // 如果没有实现 delegate 方法，则手动动态添加
    if (!originalMethod) {
        Method noneMethod = class_getInstanceMethod(swizzledClass, noneSel);
        BOOL didAddNoneMethod = class_addMethod(originalClass,
                                                originalSel,
                                                method_getImplementation(noneMethod),
                                                method_getTypeEncoding(noneMethod));
        if (didAddNoneMethod) {
            // NSLog(@"******** 没有实现 (%@) 方法，手动添加成功！！(%@)",NSStringFromSelector(originalSel),NSStringFromClass(originalClass));
//            originalMethod = class_getInstanceMethod(originalClass, originalSel);
            
            
        }
        return;
    }
    
    // 向实现 delegate 的类中添加新的方法
    BOOL didAddMethod = class_addMethod(originalClass,
                                        swizzledSelector,
                                        method_getImplementation(swizzingMethod),
                                        method_getTypeEncoding(swizzingMethod));
    if (didAddMethod) {
        // 添加成功
        // NSLog(@"******** 实现了 (%@) 方法并成功 Hook 为 --> (%@)",NSStringFromSelector(originalSel) ,NSStringFromSelector(swizzledSelector));
        // 重新拿到添加被添加的 method,这里是关键(注意这里 originalClass, 不 replacedClass), 因为替换的方法已经添加到原类中了, 应该交换原类中的两个方法
        Method newMethod = class_getInstanceMethod(originalClass, swizzledSelector);
        // 实现交换
        method_exchangeImplementations(originalMethod, newMethod);
    } else {
        // 添加失败，则说明已经 hook 过该类的 delegate 方法，防止多次交换。
        // NSLog(@"******** 已替换过，避免多次替换 --> (%@)",NSStringFromClass(originalClass));
    }
}

+ (void)swizzleClassMethod:(SEL)originalSelector withSelector:(SEL)swizzledSelector {
    
    Method originalMethod = class_getClassMethod(self, originalSelector);
    Method swizzledMethod = class_getClassMethod(self, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(self,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(self,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


@end

@implementation NSObject (DeSwizzleMethod)

+ (BOOL)deswizzleClassMethod:(SEL)selector {
    
    return deswizzleClassMethod(self, selector);
}

+ (BOOL)deswizzleInstanceMethod:(SEL)selector {
    return deswizzleInstanceMethod(self, selector);
}

+ (BOOL)deswizzleAllClassMethods {
    return deswizzleAllClassMethods(self);
}

+ (BOOL)deswizzleAllInstanceMethods {
    return deswizzleAllInstanceMethods(self);
}

+ (BOOL)deswizzleAllMethods {
    
    BOOL c = [self deswizzleAllClassMethods];
    BOOL i = [self deswizzleAllInstanceMethods];
    return (c || i);
}

@end

@implementation GMHookTool

//判断页面是否实现了某个sel
+ (BOOL)isContainSel:(SEL)sel inClass:(Class)class {
    unsigned int count;
    
    Method *methodList = class_copyMethodList(class,&count);
    for (int i = 0; i < count; i++) {
        Method method = methodList[i];
        NSString *tempMethodString = [NSString stringWithUTF8String:sel_getName(method_getName(method))];
        if ([tempMethodString isEqualToString:NSStringFromSelector(sel)]) {
            return YES;
        }
    }
    return NO;
}

@end

@implementation MMWeakObject

- (instancetype)initWithObj:(id)obj {
    if (self = [super init]) {
        _obj = obj;
    }
    return self;
}
@end
