//
//  NSObject+Subclass.m
//  HelloCreateDynamicClass
//
//  Created by wesley_chen on 04/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "NSObject+Subclass.h"

@implementation NSObject (Subclass)

+ (Class)newSubclassNamed:(NSString *)name protocols:(Protocol **)protocols impls:(selBlockPair *)impls {
    if (!name) {
        name = [NSString stringWithFormat:@"%s_%i_%i", class_getName(self), arc4random(), arc4random()];
    }
    
    Class newClass = objc_allocateClassPair(self, [name UTF8String], 0);
    
    // Note: recreate the same subclass will get NULL
    if (newClass != NULL) {
        // Note: add an array of protocols to new class
        while (protocols && *protocols != NULL) {
            class_addProtocol(newClass, *protocols);
            protocols++;
        }
        
        // Note: add an array of selBlockPairs to new class
        while (impls && impls->sel) {
            class_addMethod(newClass, impls->sel, imp_implementationWithBlock(impls->block), "@@:*");
            impls++;
        }
        
        objc_registerClassPair(newClass);
    }
    
    return newClass;
}

@end
