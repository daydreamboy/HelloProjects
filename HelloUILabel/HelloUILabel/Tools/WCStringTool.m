//
//  WCStringTool.m
//  HelloUILabel
//
//  Created by wesley_chen on 2018/7/23.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCStringTool.h"

@implementation WCStringTool

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

#pragma mark -

+ (NSString *)softHyphenatedStringWithString:(NSString *)string locale:(NSLocale *)locale error:(out NSError **)error {
    static unichar const sTextDrawingSoftHyphenUniChar = 0x00AD;
    
    CFLocaleRef localeRef = (__bridge CFLocaleRef)(locale);
    if (!CFStringIsHyphenationAvailableForLocale(localeRef)) {
        if(error != NULL) {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: @"Hyphenation is not available for given locale",
                                       NSLocalizedFailureReasonErrorKey: @"Hyphenation is not available for given locale",
                                       NSLocalizedRecoverySuggestionErrorKey: @"You could try using a different locale even though it might not be 100% correct"
                                       };
            
            NSError *errorL = [NSError errorWithDomain:@"" code:-1 userInfo:userInfo];
            *error = errorL;
        }
        return nil;
    }
    else {
        NSMutableString *stringM = [string mutableCopy];
        unsigned char hyphenationLocations[stringM.length];
        memset(hyphenationLocations, 0, stringM.length);
        CFRange range = CFRangeMake(0, stringM.length);
        
        for (int i = 0; i < stringM.length; i++) {
            CFIndex location = CFStringGetHyphenationLocationBeforeIndex((CFStringRef)stringM,
                                                                         i,
                                                                         range,
                                                                         0,
                                                                         localeRef,
                                                                         NULL);
            
            if (location >= 0 && location < stringM.length) {
                hyphenationLocations[location] = 1;
            }
        }
        
        for (NSInteger i = stringM.length - 1; i > 0; i--) {
            if (hyphenationLocations[i]) {
                [stringM insertString:[NSString stringWithFormat:@"%C", sTextDrawingSoftHyphenUniChar] atIndex:i];
                // Note: debug
                //[stringM insertString:@"-" atIndex:i];
            }
        }
        
        if (error != NULL) { *error = nil; }
        
        return stringM;
    }
}

#pragma mark > String Measuration (e.g. length, number of substring, range, ...)

+ (nullable NSArray<NSValue *> *)rangesOfSubstringWithString:(NSString *)string substring:(NSString *)substring {
    if (![string isKindOfClass:[NSString class]] || ![substring isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSRange searchRange = NSMakeRange(0, string.length);
    NSRange foundRange;
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    while (searchRange.location < string.length) {
        searchRange.length = string.length - searchRange.location;
        foundRange = [string rangeOfString:substring options:kNilOptions range:searchRange];
        
        if (foundRange.location != NSNotFound) {
            // found an occurrence of the substring, and add its range to NSArray
            [arrM addObject:[NSValue valueWithRange:foundRange]];
            
            // move forward
            searchRange.location = foundRange.location + foundRange.length;
        }
        else {
            // no more substring to find
            break;
        }
    }
    
    return arrM;
}

@end
