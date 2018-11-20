//
//  WCStringTool.m
//  HelloNSExpression
//
//  Created by wesley_chen on 2018/11/20.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCStringTool.h"

@implementation WCStringTool

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

+ (CGSize)textSizeWithMultipleLineString:(NSString *)string width:(CGFloat)width font:(UIFont *)font mode:(NSLineBreakMode)lineBreakMode widthToFit:(BOOL)widthToFit {
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

+ (CGSize)textSizeWithMultipleLineString:(NSString *)string width:(CGFloat)width attributes:(NSDictionary *)attributes widthToFit:(BOOL)widthToFit {
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

@end
