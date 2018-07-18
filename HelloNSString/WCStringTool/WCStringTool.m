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
        CGSize textSize = [string sizeWithAttributes:@{ NSFontAttributeName: font }];
        return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
    }
    else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize textSize = [string sizeWithFont:font];
        return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
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
        CGSize textSize = rect.size;
        return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
    }
    else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize textSize = [string sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
        return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
#pragma clang diagnostic pop
    }
}

+ (CGSize)textSizeWithMultipleLineString:(NSString *)string width:(CGFloat)width attributes:(NSDictionary *)attributes {
    if (width > 0) {
        CGRect rect = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                           options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                        attributes:attributes
                                           context:nil];
        CGSize textSize = rect.size;
        return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
    }
    else {
        return CGSizeZero;
    }
}

#pragma mark - NSStringFromXXX

+ (NSString *)stringFromUIGestureRecognizerState:(UIGestureRecognizerState)state {
    switch (state) {
        case UIGestureRecognizerStatePossible:
            return @"possible";
        case UIGestureRecognizerStateBegan:
            return @"began";
        case UIGestureRecognizerStateChanged:
            return @"changed";
        case UIGestureRecognizerStateFailed:
            return @"failed";
            // a.k.a UIGestureRecognizerStateRecognized
        case UIGestureRecognizerStateEnded:
            return @"ended";
        case UIGestureRecognizerStateCancelled:
            return @"cancelled";
    }
}

#pragma mark - Handle String As Specific Strings

#pragma mark > Handle String As Url

/*!
 *  Get the 'value' string for the given 'key' string, e.g. "http://m.cp.360.cn/news/mobile/150410515.html?act=1&reffer=ios&titleRight=share&empty="
 *
 *  @param key       the 'key' string
 *  @param connector the sign, such as =, : and so on
 *  @param separator the sign, such as & and so on
 *
 *  @return the 'value' string
 */
+ (NSString *)valueWithUrlString:(NSString *)string forKey:(NSString *)key usingConnector:(NSString *)connector usingSeparator:(NSString *)separator {
    
    NSString *searchedKey = [NSString stringWithFormat:@"%@%@", key, connector];
    
    NSUInteger locationOfSearchedKey = [string rangeOfString:searchedKey options:NSBackwardsSearch].location;
    if (locationOfSearchedKey == NSNotFound) {
        return nil;
    }
    else {
        NSUInteger locationOfSeparator = [string rangeOfString:separator options:0 range:NSMakeRange(locationOfSearchedKey, string.length - locationOfSearchedKey)].location;
        if (locationOfSeparator == NSNotFound) {
            locationOfSeparator = string.length;
        }
        
        NSUInteger start = locationOfSearchedKey + searchedKey.length;
        NSUInteger end = locationOfSeparator;
        NSString *value = [string substringWithRange:NSMakeRange(start, end - start)];
        
        return value;
    }
}

/*!
 *  Get the 'value' string for the given 'key' string, e.g. "http://m.cp.360.cn/news/mobile/150410515.html?act=1&reffer=ios&titleRight=share&empty="
 *
 *  @param key the 'key' in string as "key1=value1&key2=value2&..."
 *
 *  @return the 'value' string
 */
+ (NSString *)valueWithUrlString:(NSString *)string forKey:(NSString *)key {
    
    NSString *separator = @"&";
    NSString *connector = @"=";
    
    return [self valueWithUrlString:string forKey:key usingConnector:connector usingSeparator:separator];
}

+ (NSDictionary *)keyValuePairsWithUrlString:(NSString *)urlString {
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    if (URL) {
        // Note: not URL.parameterString
        // For example, in the URL file:///path/to/file;foo, the parameter string is foo.
        NSArray *pairs = [URL.query componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in pairs) {
            NSArray *keyValue = [keyValuePair componentsSeparatedByString:@"="];
            
            NSString *key = [keyValue firstObject];
            NSString *value = [keyValue lastObject];
            
            if (key && value) {
                dictM[key] = value;
            }
        }
    }
    
    return [dictM copy];
}

@end
