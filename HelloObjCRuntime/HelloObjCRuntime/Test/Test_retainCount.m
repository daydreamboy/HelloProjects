//
//  Test_retainCount.m
//  Test
//
//  Created by wesley_chen on 2019/6/17.
//  Copyright © 2019 wesley chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MyObject.h"

#if __has_attribute(objc_externally_retained)
#else
#warning "objc_externally_retained not supported"
#endif

@interface Test_retainCount : XCTestCase
@property (nonatomic, copy) NSString *caseName;
- (instancetype)initWithCaseName:(NSString *)caseName;
- (void)setupWithSomething;
@end

@implementation Test_retainCount

- (instancetype)initWithCaseName:(NSString *)caseName {
    // Note: self's retainCount increased
    _caseName = caseName;
    NSLog(@"initWithCaseName: %p retain count: %d", self, (int)CFGetRetainCount((__bridge CFTypeRef)(self)));
    XCTAssertTrue(CFGetRetainCount((__bridge CFTypeRef)(self)) == 2);
    return self;
}

- (instancetype)initWithCaseName2:(NSString *)caseName {
    // Note: self's retainCount increased
    _caseName = caseName;
    NSLog(@"initWithCaseName2: %p retain count: %d", self, (int)CFGetRetainCount((__bridge CFTypeRef)(self)));
    XCTAssertTrue(CFGetRetainCount((__bridge CFTypeRef)(self)) == 2);
    return self;
}

- (void)setupWithSomething {
    // Note: self's retainCount not increase
    NSLog(@"setupWithSomething: %p retain count: %d", self, (int)CFGetRetainCount((__bridge CFTypeRef)(self)));
    XCTAssertTrue(CFGetRetainCount((__bridge CFTypeRef)(self)) == 1);
}

#pragma mark - Test Methods

- (void)test_CFGetRetainCount {
    // Case 1
    {
        MyObject *object = [MyObject new];
        // @see https://stackoverflow.com/a/2640572
        NSLog(@"%p retain count: %d", object, (int)CFGetRetainCount((__bridge CFTypeRef)(object)));
        XCTAssertTrue(CFGetRetainCount((__bridge CFTypeRef)(object)) == 1);
        
        [self printObjectWithRetain:object];
        NSLog(@"%p retain count: %d", object, (int)CFGetRetainCount((__bridge CFTypeRef)(object)));
        XCTAssertTrue(CFGetRetainCount((__bridge CFTypeRef)(object)) == 1);
    }
    
    // Case 2
    {
        NSObject *object = [NSObject new];
        NSLog(@"%p retain count: %d", object, (int)CFGetRetainCount((__bridge CFTypeRef)(object)));
        XCTAssertTrue(CFGetRetainCount((__bridge CFTypeRef)(object)) == 1);
        
        [self printObjectWithUnretain:object];
        NSLog(@"%p retain count: %d", object, (int)CFGetRetainCount((__bridge CFTypeRef)(object)));
        XCTAssertTrue(CFGetRetainCount((__bridge CFTypeRef)(object)) == 1);
    }
}

- (void)test_initMethods {
    Test_retainCount *object = [[self class] alloc];
    NSLog(@"%p retain count: %d", object, (int)CFGetRetainCount((__bridge CFTypeRef)(object)));
    XCTAssertTrue(CFGetRetainCount((__bridge CFTypeRef)(object)) == 1);
    
    [object setupWithSomething];
    NSLog(@"%p retain count: %d", object, (int)CFGetRetainCount((__bridge CFTypeRef)(object)));
    XCTAssertTrue(CFGetRetainCount((__bridge CFTypeRef)(object)) == 1);
    
    object = [object initWithCaseName:@"test_initMethods"] ;
    NSLog(@"%p retain count: %d", object, (int)CFGetRetainCount((__bridge CFTypeRef)(object)));
    XCTAssertTrue(CFGetRetainCount((__bridge CFTypeRef)(object)) == 1);
    
    object = [object initWithCaseName2:@"test_initMethods"];
    NSLog(@"%p retain count: %d", object, (int)CFGetRetainCount((__bridge CFTypeRef)(object)));
    XCTAssertTrue(CFGetRetainCount((__bridge CFTypeRef)(object)) == 1);
}

#pragma mark - Dummy Methods

- (void)printObjectWithRetain:(NSObject *)object {
    NSLog(@"%p retain count: %d", object, (int)CFGetRetainCount((__bridge CFTypeRef)(object)));
    XCTAssertTrue(CFGetRetainCount((__bridge CFTypeRef)(object)) == 2);
}

- (void)printObjectWithUnretain:(__unsafe_unretained NSObject *)object {
    NSLog(@"%p retain count: %d", object, (int)CFGetRetainCount((__bridge CFTypeRef)(object)));
    XCTAssertTrue(CFGetRetainCount((__bridge CFTypeRef)(object)) == 1);
}

@end
