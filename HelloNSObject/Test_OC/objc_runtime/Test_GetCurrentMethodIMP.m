//
//  Test_GetCurrentMethodIMP.m
//  Tests_OC
//
//  Created by wesley_chen on 2021/3/21.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>

@interface Test_GetCurrentMethodIMP : XCTestCase

@end

@implementation Test_GetCurrentMethodIMP

IMP impOfCallingMethod(id lookupObject, SEL selector)
{
    NSUInteger returnAddress = (NSUInteger)__builtin_return_address(0);
    printf("returnAddress: %p\n", (void *)returnAddress);
    NSUInteger closest = 0;
    
    // Iterate over the class and all superclasses
    Class currentClass = object_getClass(lookupObject);
    while (currentClass)
    {
        // Iterate over all instance methods for this class
        unsigned int methodCount;
        Method *methodList = class_copyMethodList(currentClass, &methodCount);
        unsigned int i;
        for (i = 0; i < methodCount; i++)
        {
            // Ignore methods with different selectors
            if (method_getName(methodList[i]) != selector)
            {
                continue;
            }
            
            // If this address is closer, use it instead
            NSUInteger address = (NSUInteger)method_getImplementation(methodList[i]);
            if (address < returnAddress && address > closest)
            {
                closest = address;
            }
        }
    
        free(methodList);
        currentClass = class_getSuperclass(currentClass);
    }
    
    return (IMP)closest;
}

- (void)test_get_current_method_IMP {
    Method m = class_getInstanceMethod([self class], _cmd);
    IMP impGetByObjCRuntime = method_getImplementation(m);
    IMP impGetByCustom = impOfCallingMethod(self, _cmd);
    
    printf("%p\n", impGetByObjCRuntime);
    printf("%p\n", impGetByCustom);
}

@end
