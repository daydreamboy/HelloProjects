//
//  WCSwizzleTool.m
//  HelloNSObject
//
//  Created by wesley_chen on 2021/2/27.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "WCSwizzleTool.h"
#import <objc/runtime.h>

@implementation WCSwizzleTool

#pragma mark - Swizzle with block

+ (BOOL)exchangeIMPWithClass:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL _Nullable)swizzledSelector swizzledBlock:(id)block {
    
    if (class == NULL || !sel_isMapped(originalSelector) || !block) {
        return NO;
    }
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    if (!originalMethod) {
        return NO;
    }
    
    IMP swizzledIMP = imp_implementationWithBlock(block);
    if (swizzledIMP == NULL) {
        return NO;
    }
    
    if (swizzledSelector == NULL) {
        swizzledSelector = [self swizzledSelectorWithSelector:NULL];
    }
    
    // Note: create a new Method with swizzledSelector and block IMP
    BOOL success = class_addMethod(class, swizzledSelector, swizzledIMP, method_getTypeEncoding(originalMethod));
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    if (swizzledMethod == NULL) {
        return NO;
    }
    
    if (success) {
        // Note: exchange the IMPs, so the final mapping is:
        // originalMethod (originalSelector) -> block IMP
        // swizzledMethod (swizzledSelector) -> IMP of the originalMethod
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    else {
        // Note: swizzledSelector's IMP already exist in the class, so set the new/recent IMP to the swizzledSelector
        method_setImplementation(swizzledMethod, swizzledIMP);
    }
    
    return YES;
}

+ (BOOL)replaceIMPWithClass:(Class)class originalSelector:(SEL)originalSelector swizzledBlock:(id)block originalIMPPtr:(inout WCIMPPtr _Nullable)originalIMPPtr {
    
    if (class == NULL || !sel_isMapped(originalSelector) || !block) {
        return NO;
    }
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    if (!originalMethod) {
        return NO;
    }
    
    IMP swizzledIMP = imp_implementationWithBlock(block);
    if (swizzledIMP == NULL) {
        return NO;
    }
    
    if (class_addMethod(class, originalSelector, swizzledIMP, method_getTypeEncoding(originalMethod))) {
        // Note: add new originalSelector -> swizzledIMP pair when originalSelector not exist in the class
        
        if (originalIMPPtr != NULL) {
            *originalIMPPtr = method_getImplementation(originalMethod);
        }
        
        return YES;
    }
    else {
        // Note: change originalSelector -> oldIMP pair to originalSelector -> swizzledIMP pair
        // when originalSelector already exists in the class
        IMP originalIMP = method_setImplementation(originalMethod, swizzledIMP);
        
        if (originalIMPPtr != NULL) {
            *originalIMPPtr = originalIMP;
        }
        
        return YES;
    }
}

#pragma mark - Swizzle with selector

+ (BOOL)exchangeIMPWithClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector forClassMethod:(BOOL)forClassMethod {
    
    if (cls == NULL || !sel_isMapped(originalSelector) || !sel_isMapped(swizzledSelector)) {
        return NO;
    }
    
    Method originalMethod = forClassMethod ? class_getClassMethod(cls, originalSelector) : class_getInstanceMethod(cls, originalSelector);
    Method swizzledMethod = forClassMethod ? class_getClassMethod(cls, swizzledSelector) : class_getInstanceMethod(cls, swizzledSelector);
    
    if (originalMethod == NULL || swizzledMethod == NULL) {
        return NO;
    }
    
    if (forClassMethod) {
        cls = object_getClass((id)cls);
    }
    
    if (class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
    return YES;
}

#pragma mark - Swizzle with C function

+ (BOOL)exchangeIMPWithClass:(Class)class swizzledIMP:(IMP)swizzledIMP originalSelector:(SEL)originalSelector originalIMPPtr:(inout WCIMPPtr _Nullable)originalIMPPtr {
    
    if (class == NULL || swizzledIMP == NULL || !sel_isMapped(originalSelector)) {
        return NO;
    }
    
    IMP originalImp = NULL;
    Method method = class_getInstanceMethod(class, originalSelector);
    if (method) {
        const char *type = method_getTypeEncoding(method);
        // Note: add new method or replace the existing method
        originalImp = class_replaceMethod(class, originalSelector, swizzledIMP, type);
        if (!originalImp) {
            // Note: if originalImp is nil, that's case which add new method, so get the
            // originalSelector's IMP
            originalImp = method_getImplementation(method);
        }
    }
    
    if (originalImp && originalIMPPtr) {
        *originalIMPPtr = originalImp;
    }
    
    return (originalImp != NULL);
}

#pragma mark > Swizzle Assistant Method

+ (SEL)swizzledSelectorWithSelector:(SEL _Nullable)selector {
    if (selector == NULL) {
        return NSSelectorFromString([NSString stringWithFormat:@"WCSwizzleTool_swizzle_%x", arc4random()]);
    }
    
    return NSSelectorFromString([NSString stringWithFormat:@"WCSwizzleTool_swizzle_%@_%x", NSStringFromSelector(selector), arc4random()]);
}

@end
