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

@end
