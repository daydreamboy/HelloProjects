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

@interface WCJSCTool : NSObject

+ (void)printExceptionValue:(JSValue *)exception;

/**
 Check global variable if defined in the context
 
 @param context the JS context
 @param variableName the global variable name
 
 @return return YES if the global variable has defined
 */
+ (BOOL)checkGlobalVariableDefinedWithContext:(JSContext *)context variableName:(NSString *)variableName;

@end

NS_ASSUME_NONNULL_END
