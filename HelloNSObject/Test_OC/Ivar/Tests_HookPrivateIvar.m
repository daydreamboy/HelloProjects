//
//  Tests_HookPrivateIvar.m
//  Tests_OC
//
//  Created by wesley_chen on 2021/5/15.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HiddenPrivateIvarClass.h"
#import <objc/runtime.h>
#import "WCObjectTool.h"
#import "WCMacroTool.h"

@interface Tests_HookPrivateIvar : XCTestCase

@end

@implementation Tests_HookPrivateIvar

- (void)test_hook_by_pointer_arithmetic {
    HiddenPrivateIvarClass *foo = [[HiddenPrivateIvarClass alloc] init];
    
    __unsafe_unretained NSString *name = (__bridge id)*(void **)((__bridge void *)foo + 8);
    NSLog(@"name: %@", name);
    XCTAssertEqualObjects(name, @"w");
    
    __unsafe_unretained NSString *job = (__bridge id)*(void **)((__bridge void *)foo + 16);
    NSLog(@"job: %@", job);
    XCTAssertEqualObjects(job, @"hacker");
}

- (void)test_hook_by_runtime_api {
    HiddenPrivateIvarClass *foo = [[HiddenPrivateIvarClass alloc] init];
    ptrdiff_t offset;
    unsigned char *stuffBytes;
    NSValue *value;
    
    // Case 1: object ivar
    Ivar nameIVar = class_getInstanceVariable([foo class], "_name");
    NSString *name = object_getIvar(foo, nameIVar);
    NSLog(@"name: %@", name);
    XCTAssertEqualObjects(name, @"w");
    
    Ivar jobIVar = class_getInstanceVariable([foo class], "_job");
    NSString *job = object_getIvar(foo, jobIVar);
    NSLog(@"job: %@", job);
    XCTAssertEqualObjects(job, @"hacker");
    
    // Case 2: CGSize - primitive ivar
    CGSize outSize;
    /*
    object_getInstanceVariable(foo, "_size", (void *)&outSize); // Compile Error: 'object_getInstanceVariable' is unavailable: not available in automatic reference counting mode
    XCTAssertTrue(outSize.width == 1);
    XCTAssertTrue(outSize.height == 2);
     */
    
    // @see https://stackoverflow.com/a/24107536
    Ivar sizeIVar = class_getInstanceVariable([foo class], "_size");
    offset = ivar_getOffset(sizeIVar);
    stuffBytes = (unsigned char *)(__bridge void *)foo;
    outSize = *((CGSize *)(stuffBytes + offset));
    XCTAssertTrue(outSize.width == 1);
    XCTAssertTrue(outSize.height == 2);
    
    // Use NSValue
    value = [NSValue value:stuffBytes + offset withObjCType:@encode(CGSize)];
    outSize = [value CGSizeValue];
    XCTAssertTrue(outSize.width == 1);
    XCTAssertTrue(outSize.height == 2);
    
    // Case 2: double - primitive ivar
    double outDouble;
    Ivar doubleIVar = class_getInstanceVariable([foo class], "_double");
    offset = ivar_getOffset(doubleIVar);
    stuffBytes = (unsigned char *)(__bridge void *)foo;
    outDouble = *((double *)(stuffBytes + offset));
    
    value = [NSValue value:stuffBytes + offset withObjCType:@encode(double)];
    outDouble = primitiveValueFromNSValue(value, double);
    
    XCTAssertTrue(outDouble == 3.14);
}


@end
