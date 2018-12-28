//
//  WCColorTool.m
//  HelloNSScanner
//
//  Created by wesley_chen on 2018/12/28.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCColorTool.h"

@implementation WCColorTool

+ (nullable UIColor *)colorWithHexString:(NSString *)string prefix:(nullable NSString *)prefix {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    // Note: prefix is not nil, but not a NSString
    if (prefix && ![prefix isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    // Note: prefix is nil, expect string length is 6 or 8
    if (!prefix && (string.length != 6 && string.length != 8)) {
        return nil;
    }
    
    if (prefix == nil) {
        prefix = @"";
    }
    
    if ([prefix rangeOfString:@"%"].location != NSNotFound) {
        return nil;
    }
    
    if ([string hasPrefix:prefix] && (string.length != (6 + prefix.length) && string.length != (8 + prefix.length))) {
        return nil;
    }
    
    // Note: -1 as failure flag
    int r = -1, g = -1, b = -1, a = -1;
    
    if (string.length == (6 + prefix.length)) {
        a = 0xFF;
        NSString *formatString = [NSString stringWithFormat:@"%@%%02x%%02x%%02x", prefix];
        sscanf([string UTF8String], [formatString UTF8String], &r, &g, &b);
    }
    else if (string.length == (8 + prefix.length)) {
        NSString *formatString = [NSString stringWithFormat:@"%@%%02x%%02x%%02x%%02x", prefix];
        sscanf([string UTF8String], [formatString UTF8String], &r, &g, &b, &a);
    }
    
    if (r == -1 || g == -1 || b == -1 || a == -1) {
        // parse hex failed
        return nil;
    }
    
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a / 255.0];
}

@end
