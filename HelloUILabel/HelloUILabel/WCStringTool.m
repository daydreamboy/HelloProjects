//
//  WCStringTool.m
//  HelloUILabel
//
//  Created by wesley_chen on 2018/7/23.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCStringTool.h"

@implementation WCStringTool

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
@end
