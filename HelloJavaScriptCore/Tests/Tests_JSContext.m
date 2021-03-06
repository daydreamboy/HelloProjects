//
//  Tests_JSContext.m
//  Tests
//
//  Created by wesley_chen on 2019/2/14.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "WCJSCTool.h"

@interface Tests_JSContext : XCTestCase

@end

@implementation Tests_JSContext

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_evaluateScript {
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:@"var num = 5 + 5"];
    [context evaluateScript:@"var names = ['Grace', 'Ada', 'Margaret']"];
    [context evaluateScript:@"var triple = function(value) { return value * 3 }"];
    JSValue *tripleNum = [context evaluateScript:@"triple(num)"];
    NSLog(@"Tripled: %d", [tripleNum toInt32]); // Tripled: 30
    XCTAssertTrue([tripleNum toInt32] == 30);
    
    JSValue *names = context[@"names"];
    JSValue *initialName = names[0];
    NSLog(@"The first name: %@", [initialName toString]); // The first name: Grace
    XCTAssertEqualObjects([initialName toString], @"Grace");
}

- (void)test_subscript {
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:@"var num = 5 + 5"];
    JSValue *num = context[@"num"];
    XCTAssertTrue([num toInt32] == 10);
}

- (void)test_exception_handler {
    JSContext *context = [[JSContext alloc] init];
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [WCJSCTool printExceptionValue:exception];
    };
    
    [context evaluateScript:@"function multiply(value1, value2) { return value1 * value2 "];
}

- (void)test_block_as_JS_function {
    JSContext *context = [[JSContext alloc] init];
    context[@"simplifyString"] = ^(NSString *input) {
        NSMutableString *mutableString = [input mutableCopy];
        CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformStripCombiningMarks, NO);
        return mutableString;
    };
    
    JSValue *result = [context evaluateScript:@"simplifyString('안녕하새요!')"];
    NSLog(@"%@", result);
    XCTAssertEqualObjects([result toString], @"annyeonghasaeyo!");
}

- (void)test_block_retain_recycle {
    __weak JSContext *weak_context;
    @autoreleasepool {
        JSContext *context = [[JSContext alloc] init];
        [context evaluateScript:@"var triple = function(value) { return value * 3 }"];
        JSValue *result = [context evaluateScript:@"triple(10)"];
        context[@"detriple"] = ^double(double num) {
            return [result toInt32] / 3.0;
        };
        
        weak_context = context;
    }
    
    XCTAssertNotNil(weak_context);
}

- (void)test_block_retain_recycle_solution {
    __weak JSContext *weak_context;
    @autoreleasepool {
        JSContext *context = [[JSContext alloc] init];
        [context evaluateScript:@"var triple = function(value) { return value * 3 }"];
        [context evaluateScript:@"var result = triple(10)"];
        context[@"detriple"] = ^double(double num) {
            JSValue *result = [JSContext currentContext][@"result"];
            return [result toInt32] / 3.0;
        };
        
        weak_context = context;
    }
    
    XCTAssertNil(weak_context);
}

- (void)test_JSContext_currentArguments {
    JSContext *context = [[JSContext alloc] init];
    context[@"changeColor"] = ^{
        NSArray<JSValue *> *args = [JSContext currentArguments];
        if (args.count == 3) {
            int32_t r = [args[0] toInt32];
            int32_t g = [args[1] toInt32];
            int32_t b = [args[2] toInt32];
            
            NSLog(@"args: %@", args);
            XCTAssertTrue(r == 255);
            XCTAssertTrue(g == 1);
            XCTAssertTrue(b == 2);
        }
        else if (args.count == 4) {
            int32_t r = [args[0] toInt32];
            int32_t g = [args[1] toInt32];
            int32_t b = [args[2] toInt32];
            int32_t a = [args[3] toInt32];
            
            NSLog(@"args: %@", args);
            XCTAssertTrue(r == 255);
            XCTAssertTrue(g == 1);
            XCTAssertTrue(b == 2);
            XCTAssertTrue(a == 255);
        }
        else {
            NSLog(@"paramters of changeColor function is error");
        }
    };
    
    [context evaluateScript:@"changeColor(255, 1, 2);"];
    [context evaluateScript:@"changeColor(255, 1, 2, 255);"];
}

- (void)test_execute_not_on_main_thread {
    JSContext *context = [[JSContext alloc] init];
    
    // Case 1: exceptionHandler maybe called on non-main thread
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [WCJSCTool printExceptionValue:exception];
        XCTAssertFalse([[NSThread currentThread] isMainThread]);
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [context evaluateScript:@"function multiply(value1, value2) { return value1 * value2 "];
    });
    
    // Case 2:
    context[@"simplifyString"] = ^(NSString *input) {
        XCTAssertFalse([[NSThread currentThread] isMainThread]);
        
        NSMutableString *mutableString = [input mutableCopy];
        CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformStripCombiningMarks, NO);
        return mutableString;
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        JSValue *result = [context evaluateScript:@"simplifyString('안녕하새요!')"];
        NSLog(@"%@", result);
        XCTAssertEqualObjects([result toString], @"annyeonghasaeyo!");
    });
}

- (void)test_check_global_objects {
    JSContext *context = [[JSContext alloc] init];
    JSValue *output;
    // @see https://www.contentful.com/blog/2017/01/17/the-global-object-in-javascript/
    
    // globalThis is global JSContext object
    output = context[@"globalThis"];
    XCTAssertFalse([output isUndefined]);
    NSLog(@"%@", [output toObject]);
    
    // globalObject property is the same address with globalThis
    output = context.globalObject;
    XCTAssertFalse([output isUndefined]);
    NSLog(@"%@", [output toObject]);
    
    // this is undefined
    output = context[@"this"];
    XCTAssertTrue([output isUndefined]);
    
    // window is undefined
    output = context[@"window"];
    XCTAssertTrue([output isUndefined]);
    
    // global is undefined
    output = context[@"global"];
    XCTAssertTrue([output isUndefined]);
    
    // self is undefined
    output = context[@"self"];
    XCTAssertTrue([output isUndefined]);
}

//- (void)test_copy_JSValue_to_another_context {
//    JSContext *context1 = [[JSContext alloc] init];
//    context1.globalObject defineProperty:<#(JSValueProperty)#> descriptor:<#(id)#>
//    JSContext *context2 = [[JSContext alloc] init];
//
//    [context1 evaluateScript:@"var a = 1;"];
//    JSValue *value = context1[@"a"];
//
//    context2[@"b"] = value;
//
//    [context2 evaluateScript:@"console.log(b)"];
//}

- (void)test_JSValue_object_keys {
//    JSContext *context = [[JSContext alloc] init];
//    JSValue *output;
//
//
//    context[@"exception"] = exception;
//    JSValue *keys = [context evaluateScript:@"Object.keys(exception)"];
//    NSLog(@"keys: %@", keys);
}

#pragma mark - Issue

- (void)test_JSContext_issue {
    NSString *output;
    
    JSContext *context = [[JSContext alloc] init];

    [context evaluateScript:@"var x1 = Object;"];
    [context evaluateScript:@"var x2 = Math;"];
    [context evaluateScript:@"var x3 = JSON;"];
    
    output = [self checkJSValueTypeWithValue:context[@"x1"]];
    XCTAssertEqualObjects(output, @"function");
    
    output = [self checkJSValueTypeWithValue:context[@"x2"]]; // Cause to crash
    XCTAssertEqualObjects(output, @"object");
    
    output = [self checkJSValueTypeWithValue:context[@"x3"]]; // Cause to crash
    XCTAssertEqualObjects(output, @"object");
}

- (NSString *)checkJSValueTypeWithValue:(JSValue *)value {
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:@"function __checkObjectType(obj) { return typeof obj; }"];
    JSValue *function = [[context globalObject] valueForProperty:@"__checkObjectType"];
    JSValue *type = [function callWithArguments:@[ value ]]; // Crash
    
    return [type toString];
}

@end
