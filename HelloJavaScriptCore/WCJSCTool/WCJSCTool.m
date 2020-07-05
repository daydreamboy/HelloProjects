//
//  WCJSCTool.m
//  HelloJavaScriptCore
//
//  Created by wesley_chen on 2020/1/19.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCJSCTool.h"

@implementation WCJSCTool

+ (void)printExceptionValue:(JSValue *)exception {
    if ([exception isKindOfClass:[JSValue class]]) {
        NSLog(@"JS Error: %@", [exception toString]); // e.g. JS Error: SyntaxError: Unexpected end of script
        if (exception.isObject) {
            NSLog(@"JS Error (More Info): %@", [exception toObject]);
            // @see https://stackoverflow.com/questions/34273540/ios-javascriptcore-exception-detailed-stacktrace-info
            NSLog(@"JS Error (Stack): %@", exception[@"stack"]);
        }
    }
    else {
        NSLog(@"%@ is not a JSValue object", exception);
    }
}

+ (BOOL)checkGlobalVariableDefinedWithContext:(JSContext *)context variableName:(NSString *)symbolName {
    if (![context isKindOfClass:[JSContext class]] || ![symbolName isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    JSValue *value = context[symbolName];
    
    return !value.isUndefined;
}

+ (nullable NSString *)checkJSValueTypeWithValue:(JSValue *)value inContext:(nullable JSContext *)context {
    if (![value isKindOfClass:[JSValue class]]) {
        return nil;
    }
    
    if (context && ![context isKindOfClass:[JSContext class]]) {
        return nil;;
    }
    
    if (context && value.context != context) {
        return nil;
    }
    
    JSContext *contextL = context ?: value.context;
    
    [contextL evaluateScript:@"function __internal_checkObjectType(obj) { return typeof obj; }"];
    JSValue *function = [[contextL globalObject] valueForProperty:@"__internal_checkObjectType"];
    JSValue *type = [function callWithArguments:@[ value ]];
    
    return [type toString];
}

#pragma mark - JSContext Environment Checking

+ (BOOL)checkIfAvailableInJSCWithFeatureType:(WCJSCToolFeatureType)featureType {
    JSContext *context = [[JSContext alloc] init];
    JSValue *value;
    NSString *globalVariableName = @"";
    
    switch (featureType) {
        case WCJSCToolFeatureTypeArrowFunction: {
            [context evaluateScript:@"var arrowFunction = () => {};"];
            globalVariableName = @"arrowFunction";
            break;
        }
        case WCJSCToolFeatureTypeConsole: {
            globalVariableName = @"console";
            break;
        }
        case WCJSCToolFeatureTypeFunctionClearTimeout: {
            // @see https://stackoverflow.com/questions/1042138/how-to-check-if-function-exists-in-javascript
            [context evaluateScript:@"var isExists = typeof clearTimeout === 'function' ? true : undefined;"];
            globalVariableName = @"isExists";
            break;
        }
        case WCJSCToolFeatureTypeFunctionSetInterval: {
            [context evaluateScript:@"var isExists = typeof setInterval === 'function' ? true : undefined;"];
            globalVariableName = @"isExists";
            break;
        }
        case WCJSCToolFeatureTypeFunctionSetTimeout: {
            [context evaluateScript:@"var isExists = typeof setTimeout === 'function' ? true : undefined;"];
            globalVariableName = @"isExists";
            break;
        }
        case WCJSCToolFeatureTypeLetVariable: {
            [context evaluateScript:@"let letVariable = 'a';"];
            globalVariableName = @"letVariable";
            break;
        }
        case WCJSCToolFeatureTypeGlobal:
            globalVariableName = @"global";
            break;
        case WCJSCToolFeatureTypeGlobalThis:
            globalVariableName = @"globalThis";
            break;
        case WCJSCToolFeatureTypeMap:
            globalVariableName = @"Map";
            break;
        case WCJSCToolFeatureTypePromise:
            globalVariableName = @"Promise";
            break;
        case WCJSCToolFeatureTypeSelf:
            globalVariableName = @"self";
            break;
        case WCJSCToolFeatureTypeWindow:
            globalVariableName = @"window";
            break;
        default:
            break;
    }
    
    if (globalVariableName.length) {
        value = context[globalVariableName];
        return !value.isUndefined;
    }
    
    return NO;
}

#pragma mark - Complementary JSContext

+ (nullable JSContext *)createJSContextWithJSCode:(NSString *)JSCode {
    if (![JSCode isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    JSContext *context = [[JSContext alloc] init];
    [self injectConsoleLogWithContext:context logBlock:nil];
    
    return context;
}

#pragma mark > Injection

+ (BOOL)injectConsoleLogWithContext:(JSContext *)context logBlock:(nullable void (^)(id object))logBlock {
    if (![context isKindOfClass:[JSContext class]]) {
        return NO;
    }
    
    void (^logBlockL)(id object);
    
    if (logBlock) {
        logBlockL = [logBlock copy];
    }
    else {
        logBlockL = ^(id object) {
            NSString *message = [object description];
            NSLog(@"JS Console: %@", message);
        };
    }
    
    JSValue *consoleValue = context[@"console"];
    if (consoleValue.isUndefined) {
        [context.globalObject defineProperty:@"console" descriptor:@{
            JSPropertyDescriptorValueKey: @{
                @"log": logBlockL,
            }
        }];
    }
    else {
        consoleValue[@"log"] = logBlockL;
    }
    
    return YES;
}

#pragma mark - Debug

+ (nullable NSDictionary *)dumpPropertiesWithValue:(JSValue *)value {
    JSVirtualMachine *virtualMachine = value.context.virtualMachine;
    if (!virtualMachine) {
        return nil;
    }
    
    // Note: make sure use the same virtualMachine to refer to JSValue cross two different JSContext
    JSContext *context = [[JSContext alloc] initWithVirtualMachine:virtualMachine];
    context[@"gValueToCheck"] = value;
    JSValue *result = [context evaluateScript:STR_OF_JS(
        (function check(variable) {
            var props = {};
            var propsValid = false;
            try {
                let propertyNames = Object.getOwnPropertyNames(variable);
                propertyNames.forEach((prop) => {
                    if (variable.hasOwnProperty(prop)) {
                        props[prop] = `[${typeof variable[prop]}]`;
                        propsValid = true;
                    }
                });
            }
            catch (e) {}
            return propsValid ? props : undefined;
        })(gValueToCheck);
    )];
    
    NSDictionary *properties = [result toDictionary];
    if (result.isUndefined || ![properties isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    return properties;
}

@end
