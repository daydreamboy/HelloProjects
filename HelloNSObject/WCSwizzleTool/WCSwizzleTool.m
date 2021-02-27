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

#pragma mark - Runtime Modify

#pragma mark > Swizzle Method

+ (BOOL)exchangeIMPWithClass:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector swizzledBlock:(id)block {
    
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

+ (BOOL)exchangeIMPWithClass:(Class)class selector1:(SEL)selector1 selector2:(SEL)selector2 {
    
    if (class == NULL || !sel_isMapped(selector1) || !sel_isMapped(selector2)) {
        return NO;
    }
    
    Method originalMethod = class_getInstanceMethod(class, selector1);
    Method swizzledMethod = class_getInstanceMethod(class, selector2);
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
    
    return YES;
}

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

+ (SEL)swizzledSelectorWithSelector:(SEL)selector {
    if (selector == NULL) {
        return NSSelectorFromString([NSString stringWithFormat:@"WCObjectTool_swizzle_%x", arc4random()]);
    }
    
    return NSSelectorFromString([NSString stringWithFormat:@"WCObjectTool_swizzle_%@_%x", NSStringFromSelector(selector), arc4random()]);
}

@end
