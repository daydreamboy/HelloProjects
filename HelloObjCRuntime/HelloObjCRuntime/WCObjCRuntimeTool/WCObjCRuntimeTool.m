//
//  WCObjCRuntimeTool.m
//  HelloObjCRuntime
//
//  Created by wesley_chen on 2019/7/18.
//  Copyright © 2019 wesley chen. All rights reserved.
//

#import "WCObjCRuntimeTool.h"
#import <objc/runtime.h>

@implementation WCObjCRuntimeTool

#pragma mark - Create Class

+ (nullable Class)createSubclassWithClassName:(nullable NSString *)className baseClassName:(nullable NSString *)baseClassName protocolNames:(NSArray<NSString *> * _Nullable)protocolNames selBlockPairs:(selBlockPair * _Nullable)selBlockPairs {
    
    if ((className && ![className isKindOfClass:[NSString class]]) ||
        (baseClassName && ![baseClassName isKindOfClass:[NSString class]]) ||
        (protocolNames && ![protocolNames isKindOfClass:[NSArray class]])) {
        return NULL;
    }
    
    Class baseClass = baseClassName == nil ? NSClassFromString(@"NSObject") : NSClassFromString(baseClassName);
    NSString *subclassName = className == nil ? [NSString stringWithFormat:@"%s_%i_%i", class_getName(baseClass), arc4random(), arc4random()] : className;
    
    Class newClass = objc_allocateClassPair(baseClass, [subclassName UTF8String], 0);
    
    // Note: recreate the same subclass will get NULL
    if (newClass != NULL) {
        // Note: add an array of protocols to new class
        for (NSString *protocolName in protocolNames) {
            if ([protocolName isKindOfClass:[NSString class]] && protocolName.length) {
                Protocol *protocol = NSProtocolFromString(protocolName);
                class_addProtocol(newClass, protocol);
            }
        }
        
        // Note: add an array of selBlockPairs to new class
        while (selBlockPairs && selBlockPairs->sel) {
            // Note: the function must take at least two arguments—self and _cmd,
            // the second and third characters must be “@:” (the first character is the return type)
            class_addMethod(newClass, selBlockPairs->sel, imp_implementationWithBlock(selBlockPairs->block), "@@:*");
            selBlockPairs++;
        }
        
        objc_registerClassPair(newClass);
    }
    
    return newClass;
}

@end
