//
//  Tests_JSVirtualMachine.m
//  Tests
//
//  Created by wesley_chen on 2020/7/4.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "WCJSCTool.h"

@interface Tests_JSVirtualMachine : XCTestCase

@end

@implementation Tests_JSVirtualMachine

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_different_virtualMachine {
    JSContext *context1 = [[JSContext alloc] init];
    JSContext *context2 = [[JSContext alloc] init];
    
    context1.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [WCJSCTool printExceptionValue:exception];
    };
    
    context2.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [WCJSCTool printExceptionValue:exception];
    };
    
    XCTAssertTrue(context1.virtualMachine != context2.virtualMachine);
    
    [context1 evaluateScript:@"function exportedFunc(a, b) { return a + b; }"];
    [context2 evaluateScript:@"console.log(exportedFunc(1, 2));"]; // ReferenceError: Can't find variable: exportedFunc
}

- (void)test_different_virtualMachine_check_different_thread {
    JSContext *context1 = [[JSContext alloc] init];
    JSContext *context2 = [[JSContext alloc] init];
    
    context1.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [WCJSCTool printExceptionValue:exception];
    };
    
    context2.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [WCJSCTool printExceptionValue:exception];
    };
    
    [WCJSCTool injectConsoleLogWithContext:context1 logBlock:^(id  _Nonnull object) {
        NSLog(@"message: %@, thread: %@", object, [NSThread currentThread]);
    }];
    [WCJSCTool injectConsoleLogWithContext:context2 logBlock:^(id  _Nonnull object) {
        NSLog(@"message: %@, thread: %@", object, [NSThread currentThread]);
    }];
    
    [context1 evaluateScript:@"while (1) { console.log(1); };"];
    [context2 evaluateScript:@"while (1) { console.log(2); };"];
}

- (void)test_same_virtualMachine {
    JSVirtualMachine *virtualMachine = [[JSVirtualMachine alloc] init];
    
    JSContext *context1 = [[JSContext alloc] initWithVirtualMachine:virtualMachine];
    JSContext *context2 = [[JSContext alloc] initWithVirtualMachine:virtualMachine];
    
    context1.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [WCJSCTool printExceptionValue:exception];
    };
    
    context2.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [WCJSCTool printExceptionValue:exception];
    };
    
    XCTAssertTrue(context1.virtualMachine == context2.virtualMachine);
    
    [context1 evaluateScript:@"function exportedFunc(a, b) { return a + b; }"];
    [context2 evaluateScript:@"console.log(exportedFunc(1, 2));"]; // ReferenceError: Can't find variable: exportedFunc
}

- (void)test_same_virtualMachine_pass_JSValue {
    JSVirtualMachine *virtualMachine = [[JSVirtualMachine alloc] init];
    
    JSContext *context1 = [[JSContext alloc] initWithVirtualMachine:virtualMachine];
    JSContext *context2 = [[JSContext alloc] initWithVirtualMachine:virtualMachine];
    
    context1.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [WCJSCTool printExceptionValue:exception];
    };
    
    context2.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [WCJSCTool printExceptionValue:exception];
    };
    
    [WCJSCTool injectConsoleLogWithContext:context1 logBlock:nil];
    [WCJSCTool injectConsoleLogWithContext:context2 logBlock:nil];
    
    XCTAssertTrue(context1.virtualMachine == context2.virtualMachine);
    
    [context1 evaluateScript:@"function exportedFunc(a, b) { return a + b; }"];
    
    // Note: context1 shares its global function to context2
    context2[@"exportedFunc"] = context1[@"exportedFunc"];
    [context2 evaluateScript:@"console.log('result is: ' + exportedFunc(1, 2));"];
}

- (void)test_different_virtualMachine_pass_JSValue {
    JSContext *context1 = [[JSContext alloc] init];
    JSContext *context2 = [[JSContext alloc] init];
    
    context1.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [WCJSCTool printExceptionValue:exception];
    };
    
    context2.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [WCJSCTool printExceptionValue:exception];
    };
    
    [WCJSCTool injectConsoleLogWithContext:context1 logBlock:nil];
    [WCJSCTool injectConsoleLogWithContext:context2 logBlock:nil];
    
    XCTAssertTrue(context1.virtualMachine != context2.virtualMachine);
    
    [context1 evaluateScript:@"function exportedFunc(a, b) { return a + b; }"];
    context2[@"exportedFunc"] = context1[@"exportedFunc"];
    [context2 evaluateScript:@"console.log('result is: ' + exportedFunc(1, 2));"]; // Crash: EXC_BREAKPOINT (code=EXC_I386_BPT, subcode=0x0)
}

- (void)test_same_virtualMachine_contextWithJSGlobalContextRef {
    JSVirtualMachine *virtualMachine = [[JSVirtualMachine alloc] init];
    
    JSContext *context1 = [[JSContext alloc] initWithVirtualMachine:virtualMachine];
    JSContext *context2 = [JSContext contextWithJSGlobalContextRef:context1.JSGlobalContextRef];
    
    context1.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [WCJSCTool printExceptionValue:exception];
    };
    
    context2.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [WCJSCTool printExceptionValue:exception];
    };
    
    XCTAssertTrue(context1 == context2);
    XCTAssertTrue(context1.virtualMachine == context2.virtualMachine);
    
    [WCJSCTool injectConsoleLogWithContext:context1 logBlock:nil];
    //[WCJSCTool injectConsoleLogWithContext:context2 logBlock:nil];
    
    [context1 evaluateScript:@"function exportedFunc(a, b) { return a + b; }"];
    context2[@"exportedFunc"] = context1[@"exportedFunc"];
    [context2 evaluateScript:@"console.log('result is: ' + exportedFunc(1, 2));"];
}

- (void)test_same_virtualMachine_ {
    NSMutableDictionary *intents = [NSMutableDictionary dictionary];
    
    JSVirtualMachine *virtualMachine = [[JSVirtualMachine alloc] init];
    
    JSContext *basicContext = [[JSContext alloc] initWithVirtualMachine:virtualMachine];
    basicContext[@"postNotification"] = ^(JSValue *name, JSValue *userInfo, JSValue *feedback) {
        NSDictionary *callbackInfo = intents[name.toString];
        if (callbackInfo) {
            JSValue *callback = callbackInfo[@"callback"];
            [callback callWithArguments:@[userInfo, feedback]];
        }
        else {
            [feedback callWithArguments:@[@{}, @{ @"error": [NSString stringWithFormat:@"notification `%@` has not registered", name] }]];
        }
    };
    
    basicContext[@"addObserverForNotification"] = ^(JSValue *name, JSValue *callback) {
        intents[name.toString] = @{
            @"callback": callback,
        };
    };
    
    JSContext *context1 = [[JSContext alloc] initWithVirtualMachine:virtualMachine];
    JSContext *context2 = [[JSContext alloc] initWithVirtualMachine:virtualMachine];
    context1.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [WCJSCTool printExceptionValue:exception];
    };
    context2.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [WCJSCTool printExceptionValue:exception];
    };
    [WCJSCTool injectConsoleLogWithContext:context1 logBlock:nil];
    [WCJSCTool injectConsoleLogWithContext:context2 logBlock:nil];
    
    context1[@"postNotification"] = basicContext[@"postNotification"];
    context2[@"postNotification"] = basicContext[@"postNotification"];
    
    context1[@"addObserverForNotification"] = basicContext[@"addObserverForNotification"];
    context2[@"addObserverForNotification"] = basicContext[@"addObserverForNotification"];
    
    /*
    [context1 evaluateScript:STR_OF_JS(
        addObserverForNotification('testNotification', (data, feedback) => {
          console.log(`data: ${JSON.stringify(data)}`);
          feedback({retCode:'Ok'}, undefined);
        });
    )];
     */
    
    [context2 evaluateScript:STR_OF_JS(
        postNotification('testNotification', { data: 'hello'}, (result, error) => {
          console.log('feedback of postNotification');
          console.log(`result: ${JSON.stringify(result)}`);
          console.log(`error: ${JSON.stringify(error)}`);
        });
    )];
    
    [context1 evaluateScript:STR_OF_JS(
        addObserverForNotification('testNotification', (data, feedback) => {
          console.log(`data: ${JSON.stringify(data)}`);
          feedback({retCode:'Ok'}, undefined);
        });
    )];
}

@end
