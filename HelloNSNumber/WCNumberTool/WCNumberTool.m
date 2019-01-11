//
//  WCNumberTool.m
//  HelloNSNumber
//
//  Created by wesley_chen on 2018/9/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCNumberTool.h"

@implementation WCNumberTool

+ (nullable NSNumber *)factorialWithNumber:(NSNumber *)number {
    if (![number isKindOfClass:[NSNumber class]]) {
        return nil;
    }
    
    return @(tgamma([number doubleValue] + 1));
}

+ (BOOL)checkNumberAsBooleanWithNumber:(NSNumber *)number {
    if (![number isKindOfClass:[NSNumber class]]) {
        return NO;
    }
    
    CFTypeID boolID = CFBooleanGetTypeID(); // the type ID of CFBoolean
    CFTypeID numID = CFGetTypeID((__bridge CFTypeRef)(number)); // the type ID of num
    return numID == boolID;
}

@end
