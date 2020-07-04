//
//  WCJSCTool.h
//  HelloJavaScriptCore
//
//  Created by wesley_chen on 2020/1/19.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WCJSCToolFeatureType) {
    WCJSCToolFeatureTypeArrowFunction,
    WCJSCToolFeatureTypeFunctionClearTimeout,
    WCJSCToolFeatureTypeFunctionSetInterval,
    WCJSCToolFeatureTypeFunctionSetTimeout,
    WCJSCToolFeatureTypeGlobal,
    WCJSCToolFeatureTypeGlobalThis,
    WCJSCToolFeatureTypeLetVariable,
    WCJSCToolFeatureTypeMap,
    WCJSCToolFeatureTypePromise,
    WCJSCToolFeatureTypeSelf,
    WCJSCToolFeatureTypeWindow,
};

@interface WCJSCTool : NSObject

+ (void)printExceptionValue:(JSValue *)exception;

/**
 Check global variable if defined in the context
 
 @param context the JS context
 @param variableName the global variable name
 
 @return return YES if the global variable has defined
 */
+ (BOOL)checkGlobalVariableDefinedWithContext:(JSContext *)context variableName:(NSString *)variableName;

/**
 Check JSValue type using `typeof`
 
 @param value the JSValue
 @param context the context which hold the value. Pass nil will use value's context property to evaluate `typeof`
 
 @return the type string, e.g. "undefined", "string", "number", and so on
 */
+ (nullable NSString *)checkJSValueTypeWithValue:(JSValue *)value inContext:(nullable JSContext *)context;

#pragma mark - JSContext Environment Checking

/**
 Check support features if available in JSContext
 
 @param featureType the type of WCJSCToolFeatureType
 
 @return Return YES if available, or return NO if not
 @discussion This method is similar with +[WCJSCTool checkGlobalVariableDefinedWithContext:variableName:]
 */
+ (BOOL)checkIfAvailableInJSCWithFeatureType:(WCJSCToolFeatureType)featureType;

#pragma mark - complementary JSContext

+ (nullable JSContext *)createJSContextWithJSCode:(NSString *)JSCode;

@end

NS_ASSUME_NONNULL_END
