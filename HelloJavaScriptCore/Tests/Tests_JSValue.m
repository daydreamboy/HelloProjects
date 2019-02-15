//
//  Tests_JSValue.m
//  Tests
//
//  Created by wesley_chen on 2019/2/14.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface Tests_JSValue : XCTestCase

@end

@implementation Tests_JSValue

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_subscript {
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:@"var list=[1, 2, 3]"];
    [context evaluateScript:@"var map={'key': 'value'}"];
    
    // Case 1: number as subscript
    JSValue *list = context[@"list"];
    JSValue *element1 = list[0];
    JSValue *element2 = list[1];
    JSValue *element3 = list[2];
    
    XCTAssertTrue([element1 toInt32] == 1);
    XCTAssertTrue([element2 toInt32] == 2);
    XCTAssertTrue([element3 toInt32] == 3);
    
    // Case 2: string as subscript
    JSValue *map = context[@"map"];
    JSValue *value = map[@"key"];
    XCTAssertEqualObjects([value toString], @"value");
}

- (void)test_function_wrapper {
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:@"var triple = function(value) { return value * 3 }"];
    JSValue *tripleFunction = context[@"triple"];
    JSValue *result = [tripleFunction callWithArguments:@[@5]];
    XCTAssertTrue([result toInt32] == 15);
}

@end
