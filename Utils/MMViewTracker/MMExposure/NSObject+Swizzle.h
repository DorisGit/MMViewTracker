//
//  NSObject+Swizzle.h
//  Mikasa
//
//  Created by Mikasa on 2019/6/19.
//  Copyright © 2019 Mikasa. All rights reserved.
//

#define MethodSwizzlerReplacement(returntype, selftype, ...) ^ returntype (__unsafe_unretained selftype self, ##__VA_ARGS__)
#define MethodSwizzlerReplacementProviderBlock ^ id (IMP original, __unsafe_unretained Class swizzledClass, SEL _cmd)
#define MethodSwizzlerOriginalImplementation(functype, ...) do{\
                                                                if (original)\
                                                                ((functype)original)(self, _cmd, ##__VA_ARGS__);\
                                                            }while(0);

typedef id (^MethodSwizzlerProvider)(IMP original, __unsafe_unretained Class swizzledClass, SEL selector);

OBJC_EXTERN BOOL deswizzleAll(void);

@interface NSObject (SwizzleMethod)

/**
 swizzleClassMethod

 @param selector swizzleClass selector
 @param replacementProvider replacementProvider
 */
+ (void)swizzleClassMethod:(SEL)selector withReplacement:(MethodSwizzlerProvider)replacementProvider;

/**
 swizzleInstanceMethod

 @param selector swizzleInstanceMethod selector
 @param replacementProvider replacementProvider
 */
+ (void)swizzleInstanceMethod:(SEL)selector withReplacement:(MethodSwizzlerProvider)replacementProvider;

/**
 Swizzle the specified instance method with another selector
 
 @param selector         Selector of the method to swizzle.
 @param swizzledSelector Selector of the new method will be swizzled.
 */
+ (void)swizzleInstanceMethod:(SEL)selector withSelector:(SEL)swizzledSelector;

/**
 Swizzle the specified class method with another selector
 
 @param selector         Selector of the method to swizzle.
 @param swizzledSelector Selector of the new method will be swizzled.
 */
+ (void)swizzleClassMethod:(SEL)selector withSelector:(SEL)swizzledSelector;


/**
 Swizzle the specified instance method with another swizzledClass swizzledMethod

 @param originalClass originalClass
 @param originalSel originalSel
 @param swizzledClass swizzledClass
 @param swizzledMethod swizzledMethod
 @param noneSel noneSel
 */
+ (void)swizzelInstanceMethodForClass:(Class)originalClass originalSel:(SEL)originalSel swizzledClass:(Class)swizzledClass swizzledSelector:(SEL)swizzledSelector noneSel:(SEL)noneSel;

@end

@interface NSObject (DeSwizzleMethod)
/**
 Restore the specified class method by removing all swizzles.
 
 @param selector Selector of the swizzled method.
 
 @return \c YES if the method was successfully restored, \c NO if the method has never been swizzled.
 
 */
+ (BOOL)deswizzleClassMethod:(SEL)selector;

/**
 Restore the specified class method by removing all swizzles.
 
 @param selector Selector of the swizzled method.
 
 @return \c YES if the method was successfully restored, \c NO if the method has never been swizzled.
 
 */

+ (BOOL)deswizzleInstanceMethod:(SEL)selector;

/**
 Restore all swizzled class methods.
 
 @return \c YES if the method was successfully restored, \c NO if no method has never been swizzled
 
 */

+ (BOOL)deswizzleAllClassMethods;

/**
 Restore all swizzled instance methods.
 
 @return \c YES if the method was successfully restored, \c NO if no method has never been swizzled.
 
 */

+ (BOOL)deswizzleAllInstanceMethods;

/**
 Restore all swizzled class and instance methods.
 
 @return \c YES if the method was successfully restored, \c NO if no method has never been swizzled.
 */

+ (BOOL)deswizzleAllMethods;
@end

@interface GMHookTool : NSObject

//判断页面是否实现了某个sel
+ (BOOL)isContainSel:(SEL)sel inClass:(Class)class;
@end

@interface MMWeakObject : NSObject
@property (nonatomic, weak) id obj;

- (instancetype)initWithObj:(id)obj;
@end

