//
//  Test_ivar.m
//  Test
//
//  Created by wesley_chen on 2020/8/26.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>

@interface Foo : NSObject
@property (nonatomic, readwrite) NSString *string;
@property (nonatomic, readonly) NSInteger count;
@end

@implementation Foo
@end

@interface Test_ivar : XCTestCase

@end

@implementation Test_ivar

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_setIVarOfPrimitiveType {
    // @see http://alanduncan.me/2013/10/02/set-an-ivar-via-the-objective-c-runtime/
    Foo *myFoo = [[Foo alloc] init];
    char *property_name;
    CFTypeRef myFooRef;
    
    property_name = "_count";

    Ivar ivar = class_getInstanceVariable(Foo.class, property_name);
    assert(ivar);

    myFooRef = CFBridgingRetain(myFoo);
    int *ivarPtr = (int *)((uint8_t *)myFooRef + ivar_getOffset(ivar));

    *ivarPtr = 15;
    NSLog(@"%ld", (long)myFoo.count);
    XCTAssertTrue(myFoo.count == 15);
}

- (void)test_setIVarOfObjectType {
    Foo *myFoo = [[Foo alloc] init];
    char *property_name;
    CFTypeRef myFooRef;
    
    property_name = "_string";
    Ivar ivar2 = class_getInstanceVariable(Foo.class, property_name);
    assert(ivar2);
    
    myFooRef = CFBridgingRetain(myFoo);
    uintptr_t *ivarPtr2 = (uintptr_t *)((uint8_t *)myFooRef + ivar_getOffset(ivar2));
    
    NSString *string = @"test"; // @{}
    NSLog(@"%p", string);
    
    //    uintptr_t *ptr = (__bridge void *)string;
    //    NSLog(@"%p", ptr);
    
    *ivarPtr2 = (uintptr_t)(__bridge void *)string;
    
    CFBridgingRelease(myFooRef);
    
    NSLog(@"%@", myFoo.string);
    XCTAssertEqualObjects(myFoo.string, @"test");
}

@end
