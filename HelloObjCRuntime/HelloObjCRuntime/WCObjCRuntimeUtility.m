//
//  WCObjCRuntimeUtility.m
//  HelloObjCRuntime
//
//  Created by wesley chen on 16/12/8.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "WCObjCRuntimeUtility.h"

#import <objc/runtime.h>

@implementation WCObjCRuntimeUtility

#pragma mark - Swizzle Helper Methods

/**
 Replace IMP of original selector with swizzled selector's block

 @param originalSelector the original selector
 @param swizzledSelector the swizzled selector
 @param class the Class
 @param block the block style IMP for the swizzled selector
 */
+ (void)replaceIMPOfOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector onClass:(Class)class withBlock:(id)block
{
    Method originalMethod  = class_getInstanceMethod(class, originalSelector);
    if (!originalMethod) {
        return;
    }
    
    IMP implementation = imp_implementationWithBlock(block);
    class_addMethod(class, swizzledSelector, implementation, method_getTypeEncoding(originalMethod));
    Method newMethod = class_getInstanceMethod(class, swizzledSelector);
    method_exchangeImplementations(originalMethod, newMethod);
}

/**
 The Swizzle （TODO）
 
 @param originalSelector    the selector which should exists on the class
 @param class               the class which owns the original selector
 @param block               the block style for ObjC Method
 @return                    the IMP
 */
+ (IMP)replaceMethodWithSelector:(SEL)originalSelector onClass:(Class)class withBlock:(id)block {
    if (!block) {
        return NULL;
    }
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    if (!originalMethod) {
        return NULL;
    }
    
    IMP newIMP = imp_implementationWithBlock(block);
    
    if (!class_addMethod(class, originalSelector, newIMP, method_getTypeEncoding(originalMethod))) {
        return method_setImplementation(originalMethod, newIMP);
    } else {
        return method_getImplementation(originalMethod);
    }
}

/**
 Exchange IMPs for two Methods

 @param class the Class
 @param originalSelector the original selector
 @param swizzledSelector the swizzled selector
 */
+ (void)exchangeIMPForClass:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    // Note: mapping originalSelector -> IMP of swizzledMethod
    if (class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        // Note: mapping swizzledSelector -> IMP of originalMethod
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        // Note: Class have both original and swizzled selectors
    }
    else {
        // If addMethod failed, exchange IMPs of original and swizzled methods directly
        method_exchangeImplementations(originalMethod, swizzledMethod);
        // Note: Class only has original selector
    }
}


/**
 Exchange IMPs (C functions) for two Methods

 @param originalSelector the original selector
 @param class the Class
 @param swizzledIMP the swizzled C function (a.k.a. IMP)
 @param originalIMPPtr the original C function pointer which will store the original IMP
 @return YES if swizzled successfully, NO if failed
 @see http://stackoverflow.com/questions/5339276/what-are-the-dangers-of-method-swizzling-in-objective-c
 */
+ (BOOL)exchangeIMPForSelector:(SEL)originalSelector onClass:(Class)class swizzledIMP:(IMP)swizzledIMP originalIMP:(IMPPtr)originalIMPPtr
{
    IMP imp = NULL;
    Method method = class_getInstanceMethod(class, originalSelector);
    if (method) {
        const char *type = method_getTypeEncoding(method);
        imp = class_replaceMethod(class, originalSelector, swizzledIMP, type);
        if (!imp) {
            imp = method_getImplementation(method);
        }
    }
    if (imp && originalIMPPtr) { *originalIMPPtr = imp; }
    return (imp != NULL);
}

/**
 Return a random selector name for given selector

 @param selector the selector
 @return the modified selector
 */
+ (SEL)swizzledSelectorForSelector:(SEL)selector
{
    return NSSelectorFromString([NSString stringWithFormat:@"_swizzle_%x_%@", arc4random(), NSStringFromSelector(selector)]);
}

@end
