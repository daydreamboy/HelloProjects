//
//  WCObjectTool.m
//  HelloNSException
//
//  Created by wesley_chen on 2019/9/8.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCObjectTool.h"
#import <objc/runtime.h>

@implementation WCObjectTool

+ (BOOL)exchangeIMPWithClass:(Class)class swizzledIMP:(IMP)swizzledIMP originalSelector:(SEL)originalSelector originalIMPPtr:(IMPPtr)originalIMPPtr {
    
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

@end
