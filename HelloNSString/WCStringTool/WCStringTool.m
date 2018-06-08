//
//  WCStringTool.m
//  HelloNSString
//
//  Created by wesley_chen on 2018/5/30.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCStringTool.h"

@implementation WCStringTool

#pragma mark - NSString to Struct/Object

+ (CGRect)rectFromString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]] || !string.length) {
        return CGRectNull;
    }
    
    NSString *compactString = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([compactString isEqualToString:@"{{0,0},{0,0}}"]) {
        return CGRectZero;
    }
    else {
        CGRect rect = CGRectFromString(string);
        if (CGRectEqualToRect(rect, CGRectZero)) {
            return CGRectNull;
        }
        else {
            return rect;
        }
    }
}

+ (NSValue *)edgeInsetsValueFromString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]] || !string.length) {
        return nil;
    }
    
    NSString *compactString = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([compactString isEqualToString:@"{0,0,0,0}"]) {
        return [NSValue valueWithUIEdgeInsets:UIEdgeInsetsZero];
    }
    else {
        UIEdgeInsets edgeInsets = UIEdgeInsetsFromString(string);
        if (UIEdgeInsetsEqualToEdgeInsets(edgeInsets, UIEdgeInsetsZero)) {
            // string is invalid, return nil
            return nil;
        }
        else {
            return [NSValue valueWithUIEdgeInsets:edgeInsets];
        }
    }
}

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

#pragma mark - Measure Size for Single-line/Multi-line String

+ (CGSize)textSizeWithSingleLineString:(NSString *)string font:(UIFont *)font {
    if (![string isKindOfClass:[NSString class]] || !string.length || ![font isKindOfClass:[UIFont class]]) {
        return CGSizeZero;
    }
    
    if ([string respondsToSelector:@selector(sizeWithAttributes:)]) {
        return [string sizeWithAttributes:@{ NSFontAttributeName: font }];
    }
    else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [string sizeWithFont:font];
#pragma clang diagnostic pop
    }
}

+ (CGSize)textSizeWithMultiLineString:(NSString *)string font:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    if (![string isKindOfClass:[NSString class]] || !string.length || ![font isKindOfClass:[UIFont class]]) {
        return CGSizeZero;
    }
    
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary dictionary];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [string boundingRectWithSize:size
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:attr
                                           context:nil];
        return rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [string sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
}

+ (CGSize)textSizeWithMultipleLineString:(NSString *)string width:(CGFloat)width attributes:(NSDictionary *)attributes {
    if (width > 0) {
        return [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                    options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                 attributes:attributes
                                    context:nil].size;
    }
    else {
        return CGSizeZero;
    }
}

@end
