//
//  Tests_JSContext.m
//  Tests
//
//  Created by wesley_chen on 2019/2/14.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <JavaScriptCore/JavaScriptCore.h>

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
        NSLog(@"JS Error: %@", exception); // JS Error: SyntaxError: Unexpected end of script
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
    // TODO: check retain recycle
    __weak JSContext *weak_context;
    {
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
    {
        JSContext *context = [[JSContext alloc] init];
        [context evaluateScript:@"var triple = function(value) { return value * 3 }"];
        [context evaluateScript:@"var result = triple(10)"];
        context[@"detriple"] = ^double(double num) {
            JSValue *result = [JSContext currentContext][@"result"];
            return [result toInt32] / 3.0;
        };
        
        weak_context = context;
    }
    
    // TODO: check nil
    //XCTAssertNil(weak_context);
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

@end