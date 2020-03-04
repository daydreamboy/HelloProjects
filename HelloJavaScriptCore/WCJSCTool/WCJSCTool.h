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

+ (BOOL)checkSymbolDefinedWithContext:(JSContext *)context symbolName:(NSString *)symbolName;

@end

NS_ASSUME_NONNULL_END
