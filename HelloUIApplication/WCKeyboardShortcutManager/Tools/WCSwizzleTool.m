//
//  WCSwizzleTool.m
//  HelloUIApplication
//
//  Created by wesley_chen on 2021/2/27.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "WCSwizzleTool.h"
#import <objc/runtime.h>

@implementation WCSwizzleTool

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

+ (SEL)swizzledSelectorWithSelector:(SEL _Nullable)selector {
    if (selector == NULL) {
        return NSSelectorFromString([NSString stringWithFormat:@"WCSwizzleTool_swizzle_%x", arc4random()]);
    }
    
    return NSSelectorFromString([NSString stringWithFormat:@"WCSwizzleTool_swizzle_%@_%x", NSStringFromSelector(selector), arc4random()]);
}

@end
