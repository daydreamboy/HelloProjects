//
//  Tests_JSValue.m
//  Tests
//
//  Created by wesley_chen on 2019/2/14.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "WCJSCTool.h"

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

- (void)test_subscript_for_array {
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:@"var list=[1, 2, 3]"];
    
    // Case 1: number as subscript
    JSValue *list = context[@"list"];
    list[3] = @(4);
    JSValue *element1 = list[0];
    JSValue *element2 = list[1];
    JSValue *element3 = list[2];
    JSValue *element4 = list[3];
    
    XCTAssertTrue([element1 toInt32] == 1);
    XCTAssertTrue([element2 toInt32] == 2);
    XCTAssertTrue([element3 toInt32] == 3);
    XCTAssertTrue([element4 toInt32] == 4);
}

- (void)test_subscript_for_map {
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:@"var map={'key': 'value'}"];
    
    // Case 1: string as subscript
    JSValue *map = context[@"map"];
    JSValue *value = map[@"key"];
    XCTAssertEqualObjects([value toString], @"value");
    
    // Case 2: define value by subscript
    map[@"key2"] = @"value2";
    value = map[@"key2"];
    XCTAssertEqualObjects([value toString], @"value2");
}

- (void)test_function_wrapper {
    JSValue *result;
    JSContext *context = [[JSContext alloc] init];
    
    // Case 1: JSValue represents JavaScript function
    [context evaluateScript:@"var triple = function(value) { return value * 3 }"];
    JSValue *tripleFunction = context[@"triple"];
    result = [tripleFunction callWithArguments:@[@5]];
    XCTAssertTrue([result toInt32] == 15);
    
    // Case 2: callback must be JSValue, not the block type NSNumber*(^callback)(NSNumber *, NSNumber *)
    context[@"calculate"] = ^(JSValue *param1, JSValue *param2, JSValue *param3, JSValue *callback) {
        if ([param1.toString isEqualToString:@"+"]) {
            int sum = param2.toInt32 + param3.toInt32;
            [callback callWithArguments:@[@(sum)]];
        }
    };
    [context evaluateScript:@"var result; calculate('+', 3, 4, function(res){ \
     result = res;\
     })();"];
    result = context[@"result"];
    XCTAssertTrue([result toInt32] == 7);
    
    // Abnormal Case 1: JSValue is not a function wrapper
    [context evaluateScript:@"var fakeFunc = {};"];
    JSValue *fakeFunction = context[@"fakeFunc"];
    // result = nil, fakeFunction is not a function wrapper
    // result = <JSValue object> but isUndefined = YES, fakeFunction has no return value
    result = [fakeFunction callWithArguments:@[]];
    XCTAssertNil(result);
}

- (void)test_undefined {
    JSValue *result;
    
    JSContext *context = [[JSContext alloc] init];
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [WCJSCTool printExceptionValue:exception];
    };
    
    // Case 1
    result = [context evaluateScript:@"var a = 'hello'"]; // execute code
    NSLog(@"%@", result);
    XCTAssertTrue(result.isUndefined);
    XCTAssertEqualObjects([result toString], @"undefined");
    XCTAssertEqualObjects([context[@"a"] toString], @"hello");
    
    // Case 2
    result = [context evaluateScript:@"b = 'hello'"]; // get value
    NSLog(@"%@", result);
    XCTAssertFalse(result.isUndefined);
    XCTAssertEqualObjects([result toString], @"hello");
    XCTAssertEqualObjects([context[@"b"] toString], @"hello");
    
    // Case 3
    result = [context evaluateScript:@"b"]; // get value
    NSLog(@"%@", result);
    XCTAssertFalse(result.isUndefined);
    XCTAssertEqualObjects([result toString], @"hello");
    XCTAssertEqualObjects([context[@"b"] toString], @"hello");
}

- (void)test_defineProperty_descriptor {
    JSContext *context = [[JSContext alloc] init];
    JSValueProperty propertyName;
    JSValue *property;
    
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [WCJSCTool printExceptionValue:exception];
    };
    
    // Case 1: JSPropertyDescriptorWritableKey is NO by default
    // example from https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty
    
    // JSPropertyDescriptorWritableKey
    // JSPropertyDescriptorEnumerableKey
    // JSPropertyDescriptorConfigurableKey
    // JSPropertyDescriptorValueKey
    // JSPropertyDescriptorGetKey
    // JSPropertyDescriptorSetKey
    
    propertyName = @"property1";
    [context.globalObject defineProperty:propertyName descriptor:@{
        JSPropertyDescriptorValueKey: @(42),
    }];
    property = [context.globalObject valueForProperty:propertyName];
    
    // throws an error in strict mode
    context.globalObject[@"property1"] = @(77);

    // expected output: 42
    NSLog(@"%@", context.globalObject[@"property1"]);
    
    // Case 2: modify property value
    propertyName = @"property2";
    [context.globalObject defineProperty:propertyName descriptor:@{
        JSPropertyDescriptorValueKey: @(42),
        JSPropertyDescriptorWritableKey: @(YES),
    }];
    property = [context.globalObject valueForProperty:propertyName];
    
    // throws an error in strict mode
    context.globalObject[@"property2"] = @(77);

    // expected output: 77
    NSLog(@"%@", context.globalObject[@"property2"]);
}

@end
