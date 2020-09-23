//
//  WCStringTool.m
//  HelloUITextView
//
//  Created by wesley_chen on 2020/9/23.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCStringTool.h"

@implementation WCStringTool

+ (UIColor *)colorFromHexString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (![string hasPrefix:@"#"] || (string.length != 7 && string.length != 9)) {
        return nil;
    }
    
    // Note: -1 as failure flag
    int r = -1, g = -1, b = -1, a = -1;
    
    if (string.length == 7) {
        a = 0xFF;
        sscanf([string UTF8String], "#%02x%02x%02x", &r, &g, &b);
    }
    else if (string.length == 9) {
        sscanf([string UTF8String], "#%02x%02x%02x%02x", &r, &g, &b, &a);
    }
    
    if (r == -1 || g == -1 || b == -1 || a == -1) {
        // parse hex failed
        return nil;
    }
    
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a / 255.0];
}

@end
