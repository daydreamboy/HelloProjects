//
//  NSObject+WCDebug.m
//  HelloNSObject
//
//  Created by wesley_chen on 2020/4/29.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "NSObject+WCDebug.h"
#import <objc/runtime.h>

@implementation NSObject (WCDebug)
@dynamic WCDebugVariableName;

static void * const kAssociatedKeyWCDebugVariableName = (void *)&kAssociatedKeyWCDebugVariableName;

- (void)setWCDebugVariableName:(NSString *)WCDebugVariableName {
    objc_setAssociatedObject(self, kAssociatedKeyWCDebugVariableName, WCDebugVariableName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)WCDebugVariableName {
    return objc_getAssociatedObject(self, kAssociatedKeyWCDebugVariableName);
}

@end
