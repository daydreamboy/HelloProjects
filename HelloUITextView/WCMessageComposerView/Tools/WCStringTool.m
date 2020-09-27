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

+ (CGSize)textSizeWithSingleLineString:(NSString *)string font:(UIFont *)font NS_AVAILABLE_IOS(7_0) {
    if (![string isKindOfClass:[NSString class]] || !string.length || ![font isKindOfClass:[UIFont class]]) {
        return CGSizeZero;
    }
    
    return [WCStringTool textSizeWithSingleLineString:string attributes:@{ NSFontAttributeName: font }];
}

+ (CGSize)textSizeWithSingleLineString:(NSString *)string attributes:(NSDictionary *)attributes NS_AVAILABLE_IOS(7_0) {
    if (![string isKindOfClass:[NSString class]] || !string.length || ![attributes isKindOfClass:[NSDictionary class]]) {
        return CGSizeZero;
    }
    
    // Note: `\n` will count for a line, so strip it
    NSString *singleLineString = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    CGSize textSize = [singleLineString sizeWithAttributes:attributes];
    
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}

+ (CGSize)textSizeWithMultipleLineString:(NSString *)string width:(CGFloat)width font:(UIFont *)font mode:(NSLineBreakMode)lineBreakMode widthToFit:(BOOL)widthToFit NS_AVAILABLE_IOS(8_0) {
    if (![string isKindOfClass:[NSString class]] || !string.length || ![font isKindOfClass:[UIFont class]] || width <= 0) {
        return CGSizeZero;
    }
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = font;
    NSLineBreakMode fixedLineBreakMode = lineBreakMode;
    // ISSUE: NSLineBreakByClipping/NSLineBreakByTruncatingHead/NSLineBreakByTruncatingTail/NSLineBreakByTruncatingMiddle not working with mutiple line,
    // boundingRectWithSize:options:attributes:context: always calculate one line height
    // @see https://www.jianshu.com/p/5dd5cd803d34
    if (lineBreakMode != NSLineBreakByWordWrapping || lineBreakMode != NSLineBreakByCharWrapping) {
        fixedLineBreakMode = NSLineBreakByCharWrapping;
    }
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = fixedLineBreakMode;
    attr[NSParagraphStyleAttributeName] = paragraphStyle;
    
    return [self textSizeWithMultipleLineString:string width:width attributes:attr widthToFit:widthToFit];
}

+ (CGSize)textSizeWithMultipleLineString:(NSString *)string width:(CGFloat)width attributes:(NSDictionary *)attributes widthToFit:(BOOL)widthToFit NS_AVAILABLE_IOS(8_0) {
    if (width > 0) {
        CGRect rect = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                           options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                        attributes:attributes
                                           context:nil];
        CGSize textSize = rect.size;
        if (widthToFit) {
            return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
        }
        else {
            return CGSizeMake(width, ceil(textSize.height));
        }
    }
    else {
        return CGSizeZero;
    }
}

+ (CGSize)textSizeWithFixedLineString:(NSString *)string width:(CGFloat)width font:(UIFont *)font numberOfLines:(NSUInteger)numberOfLines mode:(NSLineBreakMode)lineBreakMode widthToFit:(BOOL)widthToFit NS_AVAILABLE_IOS(8_0) {
    if (![string isKindOfClass:[NSString class]] || !string.length || ![font isKindOfClass:[UIFont class]] || width <= 0) {
        return CGSizeZero;
    }
    
    if (numberOfLines <= 0) {
        return [self textSizeWithMultipleLineString:string width:width font:font mode:lineBreakMode widthToFit:widthToFit];
    }
    else {
        CGSize textSizeForOneLine = [self textSizeWithSingleLineString:string font:font];
        CGSize textSizeForMultipleLines = [self textSizeWithMultipleLineString:string width:width font:font mode:lineBreakMode widthToFit:widthToFit];
        
        CGFloat height;
        if (textSizeForMultipleLines.height > (numberOfLines * textSizeForOneLine.height)) {
            height = (numberOfLines * textSizeForOneLine.height);
        }
        else {
            height = textSizeForMultipleLines.height;
        }
        return CGSizeMake(textSizeForMultipleLines.width, ceil(height));
    }
}

@end
