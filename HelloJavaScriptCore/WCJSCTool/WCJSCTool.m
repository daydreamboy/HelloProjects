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
        case WCJSCToolFeatureTypeLetVariable: {
            [context evaluateScript:@"let letVariable = 'a';"];
            globalVariableName = @"letVariable";
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

#pragma mark - complementary JSContext

+ (nullable JSContext *)createJSContextWithJSCode:(NSString *)JSCode {
    if (![JSCode isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    JSContext *context = [[JSContext alloc] init];
    
    return context;
}

@end
