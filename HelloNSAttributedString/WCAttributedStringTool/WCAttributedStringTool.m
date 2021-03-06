//
//  WCAttributedStringTool.m
//  HelloNSAttributedString
//
//  Created by wesley_chen on 2018/10/24.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCAttributedStringTool.h"

@implementation WCAttributedStringTool

// >= `13.0`
#ifndef IOS13_OR_LATER
#define IOS13_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"13.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

// >= `9.0`
#ifndef IOS9_OR_LATER
#define IOS9_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

#pragma mark > Substring String

+ (nullable NSAttributedString *)attributedSubstringWithAttributedString:(NSAttributedString *)attributedString range:(NSRange)range {
    if (![attributedString isKindOfClass:[NSAttributedString class]]) {
        return nil;
    }
    
    if (range.location == NSNotFound) {
        return nil;
    }
    
    if (range.location <= attributedString.length) {
        if (range.length <= attributedString.length - range.location) {
            return [attributedString attributedSubstringFromRange:range];
        }
        else {
            return nil;;
        }
    }
    else {
        return nil;
    }
}

#pragma mark > String Modification

+ (nullable NSAttributedString *)replaceCharactersInRangesWithAttributedString:(NSAttributedString *)attributedString ranges:(NSArray<NSValue *> *)ranges replacementAttributedStrings:(NSArray<NSAttributedString *> *)replacementAttributedStrings replacementRanges:(inout nullable NSMutableArray<NSValue *> *)replacementRanges {
    if (![attributedString isKindOfClass:[NSAttributedString class]] ||
        ![ranges isKindOfClass:[NSArray class]] ||
        ![replacementAttributedStrings isKindOfClass:[NSArray class]] ||
        ranges.count != replacementAttributedStrings.count) {
        return nil;
    }
    
    // Parameter check: replacementRanges
    if (replacementRanges && ![replacementRanges isKindOfClass:[NSMutableArray class]]) {
        return nil;
    }
    
    // Parameter check: replacementAttributedStrings
    for (NSString *element in replacementAttributedStrings) {
        if (![element isKindOfClass:[NSAttributedString class]]) {
            return nil;
        }
    }
    
    // Parameter check: ranges
    for (NSValue *value in ranges) {
        if (![value isKindOfClass:[NSValue class]]) {
            return nil;
        }
        
        NSRange range = [value rangeValue];
        if (range.location == NSNotFound || range.length == 0) {
            return nil;
        }
        
        if (!NSRangeContainsRange(NSMakeRange(0, attributedString.length), range)) {
            return nil;
        }
    }
    
    // Note: empty array just return the original string
    if (ranges.count == 0 && replacementAttributedStrings.count == 0) {
        return attributedString;
    }
    
    // Note: sort the ranges by ascend
    NSArray *sortedRanges = [ranges sortedArrayUsingComparator:^NSComparisonResult(NSValue * _Nonnull value1, NSValue * _Nonnull value2) {
        NSComparisonResult result = NSOrderedSame;
        if (value1.rangeValue.location > value2.rangeValue.location) {
            result = NSOrderedDescending;
        }
        else if (value1.rangeValue.location < value2.rangeValue.location) {
            result = NSOrderedAscending;
        }
        return result;
    }];
    
    NSRange previousRange = NSMakeRange(0, 0);
    for (NSInteger i = 0; i < sortedRanges.count; i++) {
        NSRange currentRange = [sortedRanges[i] rangeValue];
        // @see https://stackoverflow.com/a/10172768
        NSRange intersection = NSIntersectionRange(previousRange, currentRange);
        if (intersection.length > 0) {
            // Note: the two ranges does intersect
            return nil;
        }
        
        previousRange = currentRange;
    }

    NSMutableAttributedString *attrStringM = [[NSMutableAttributedString alloc] initWithString:@""];
    [replacementRanges removeAllObjects];
    previousRange = NSMakeRange(0, 0);
    
    for (NSInteger i = 0; i < sortedRanges.count; i++) {
        NSValue *rangeValue = sortedRanges[i];
        
        NSRange range = [rangeValue rangeValue];
        NSRange rangeOfStringToAppend = NSMakeRange(previousRange.location + previousRange.length, range.location - previousRange.location - previousRange.length);
        
        NSAttributedString *attrStringToAppend = [self attributedSubstringWithAttributedString:attributedString range:rangeOfStringToAppend];
        NSInteger indexOfReplacementString = [ranges indexOfObject:rangeValue];
        
        if (attrStringToAppend && indexOfReplacementString != NSNotFound) {
            [attrStringM appendAttributedString:attrStringToAppend];
            
            NSAttributedString *replacementString = replacementAttributedStrings[indexOfReplacementString];
            [attrStringM appendAttributedString:replacementString];
            
            // Note: the range of replacementString
            NSRange replacementRange = NSMakeRange(attrStringM.length, replacementString.length);
            [replacementRanges addObject:[NSValue valueWithRange:replacementRange]];
        }
        
        if (i == sortedRanges.count - 1 && range.location + range.length < attributedString.length) {
            NSRange rangeOfLastStringToAppend = NSMakeRange(range.location + range.length, attributedString.length - range.location - range.length);
            NSAttributedString *lastAttrStringToAppend = [self attributedSubstringWithAttributedString:attributedString range:rangeOfLastStringToAppend];
            if (lastAttrStringToAppend) {
                [attrStringM appendAttributedString:lastAttrStringToAppend];
            }
        }
        
        previousRange = range;
    }
    
    return attrStringM;
}

+ (nullable NSAttributedString *)replaceStringWithAttributedString:(NSAttributedString *)attributedString occurrenceString:(NSString *)occurrenceString replacementString:(NSString *)replacementString range:(NSRange)range {
    
    if (![attributedString isKindOfClass:[NSAttributedString class]] ||
        !attributedString.length ||
        ![occurrenceString isKindOfClass:[NSString class]] ||
        ![replacementString isKindOfClass:[NSString class]] ||
        range.location == NSNotFound ||
        range.length == 0) {
        return nil;
    }
    
    if (range.location >= attributedString.length) {
        return nil;
    }
    
    if (range.location < attributedString.length && range.length > attributedString.length - range.location) {
        range.length = attributedString.length - range.location;
    }
    
    NSMutableAttributedString *attrStringM = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    
    [attrStringM.mutableString replaceOccurrencesOfString:occurrenceString withString:replacementString options:kNilOptions range:range];
    
    return attrStringM;
}

+ (nullable NSAttributedString *)attributedStringWithFormat:(NSString *)format, ... {
    NSMutableArray *attributes = [NSMutableArray array];
    
    va_list args;
    va_start(args, format);
    
    NSString *string = [format stringByReplacingOccurrencesOfString:@"%@" withString:@""];
    NSUInteger count = ([format length] - [string length]) / [@"%@" length];
    
    for (NSUInteger index = 0; index < count; index++) {
        id argument = va_arg(args, id);
        [attributes addObject:argument];
    }
    va_end(args);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:format];
    [attributedString beginEditing];
    
    NSRange range = [format rangeOfString:@"%@" options:NSBackwardsSearch];
    for (NSUInteger index = 0; range.location != NSNotFound; index++) {
        id attribute = [attributes lastObject];
        [attributes removeLastObject];
        
        if ([attribute isKindOfClass:[NSAttributedString class]]) {
            [attributedString replaceCharactersInRange:range withAttributedString:attribute];
        }
        else {
            [attributedString replaceCharactersInRange:range withString:[attribute description]];
        }
        
        range = NSMakeRange(0, range.location);
        range = [format rangeOfString:@"%@" options:NSBackwardsSearch range:range];
    }
    
    [attributedString endEditing];
    
    return [attributedString copy];
}

#pragma mark > Text Size

+ (CGSize)textSizeWithMultipleLineAttributedString:(NSAttributedString *)attributedString width:(CGFloat)width widthToFit:(BOOL)widthToFit {
    if (![attributedString isKindOfClass:[NSAttributedString class]] || !attributedString.length || width <= 0) {
        return CGSizeZero;
    }
    
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                 context:nil];
    CGSize textSize = rect.size;
    if (widthToFit) {
        return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
    }
    else {
        return CGSizeMake(width, ceil(textSize.height));
    }
}

+ (CGSize)textSizeWithSingleLineAttributedString:(NSAttributedString *)attributedString {
    if (![attributedString isKindOfClass:[NSAttributedString class]] || !attributedString.length) {
        return CGSizeZero;
    }
    
    // Note: `\n` or `\r` will count for a line, so strip it
    attributedString = [self replaceStringWithAttributedString:attributedString occurrenceString:@"\n" replacementString:@"" range:NSMakeRange(0, attributedString.length)];
    attributedString = [self replaceStringWithAttributedString:attributedString occurrenceString:@"\r" replacementString:@"" range:NSMakeRange(0, attributedString.length)];
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                 context:nil];
    CGSize textSize = rect.size;
    
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}

+ (CGSize)textSizeWithFixedLineAttributedString:(NSAttributedString *)attributedString width:(CGFloat)width maximumNumberOfLines:(NSUInteger)maximumNumberOfLines forceUseFixedLineHeight:(BOOL)forceUseFixedLineHeight widthToFit:(BOOL)widthToFit {
    if (![attributedString isKindOfClass:[NSAttributedString class]] || !attributedString.length || width <= 0) {
        return CGSizeZero;
    }
    
    if (maximumNumberOfLines <= 0) {
        return [self textSizeWithMultipleLineAttributedString:attributedString width:width widthToFit:widthToFit];
    }
    else {
        CGFloat height = 0;
        
        NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:attributedString];
        NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
        NSTextContainer *textContainer = [[NSTextContainer alloc] init];
        textContainer.lineFragmentPadding = 0;
        textContainer.size = CGSizeMake(width, 0.0);
        
        [textStorage addLayoutManager:layoutManager];
        [layoutManager addTextContainer:textContainer];
        
        NSUInteger numberOfNonEmptyLines = 0;
        NSUInteger index = 0;
        NSUInteger numberOfGlyphs = layoutManager.numberOfGlyphs;
        while (index < numberOfGlyphs && numberOfNonEmptyLines < maximumNumberOfLines) {
            NSRange lineRange = {0, 0};
            if (IOS9_OR_LATER) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability"
                height += [layoutManager lineFragmentRectForGlyphAtIndex:index effectiveRange:&lineRange withoutAdditionalLayout:NO].size.height;
#pragma GCC diagnostic pop
            }
            else {
                height += [layoutManager lineFragmentRectForGlyphAtIndex:index effectiveRange:&lineRange].size.height;
            }
            
            index = NSMaxRange(lineRange);
            numberOfNonEmptyLines += 1;
        }
        
        NSInteger numberOfEmptyLines = maximumNumberOfLines - numberOfNonEmptyLines;
        if (forceUseFixedLineHeight && numberOfEmptyLines > 0) {
            NSRange effectiveRange = NSMakeRange(NSNotFound, 0);
            UIFont *font = [attributedString attribute:NSFontAttributeName atIndex:0 effectiveRange:&effectiveRange];
            font = font ?: [UIFont systemFontOfSize:[UIFont systemFontSize]];
            
            CGFloat lineHeight = font.lineHeight;
            NSParagraphStyle *paragraphStyle = [attributedString attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:&effectiveRange];
            paragraphStyle = paragraphStyle ?: [NSParagraphStyle defaultParagraphStyle];
            
            if (paragraphStyle) {
                if (paragraphStyle.lineHeightMultiple > 0) {
                    lineHeight *= paragraphStyle.lineHeightMultiple;
                }
                
                if (paragraphStyle.minimumLineHeight > 0 && lineHeight < paragraphStyle.minimumLineHeight) {
                    lineHeight = paragraphStyle.minimumLineHeight;
                }
                else if (paragraphStyle.maximumLineHeight > 0 && lineHeight > paragraphStyle.maximumLineHeight) {
                    lineHeight = paragraphStyle.maximumLineHeight;
                }
                
                lineHeight += paragraphStyle.lineSpacing;
            }
            height += lineHeight * numberOfEmptyLines;
        }
        
        return CGSizeMake(width, ceil(height));
    }
}

#pragma mark - Attachment

+ (NSAttributedString *)attributedStringWithImageName:(NSString *)imageName frame:(CGRect)frame {
    if (![imageName isKindOfClass:[NSString class]] || imageName.length == 0) {
        return [[NSAttributedString alloc] initWithString:@""];
    }
    
    UIImage *image = [UIImage imageNamed:imageName];
    if (!image) {
        return [[NSAttributedString alloc] initWithString:@""];
    }
    
    // BUG: textAttachment is black
    // @see https://stackoverflow.com/questions/58153505/nstextattachment-image-in-attributed-text-with-foreground-colour
    //NSTextAttachment *textAttachment = [NSTextAttachment textAttachmentWithImage:image];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = image;
    // Note: bounds consider baseline, and ignore x, only conside y/width/height, y is upward
    textAttachment.bounds = frame;
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    return attrStringWithImage;
}

+ (NSAttributedString *)attributedStringWithImageName:(NSString *)imageName imageSize:(CGSize)imageSize alignToFont:(UIFont *)font {
    if (![imageName isKindOfClass:[NSString class]] || imageName.length == 0) {
        return [[NSAttributedString alloc] initWithString:@""];
    }
    
    UIImage *image = [UIImage imageNamed:imageName];
    if (!image) {
        return [[NSAttributedString alloc] initWithString:@""];
    }
    
    return [self attributedStringWithImage:image imageSize:imageSize alignToFont:font];
}

+ (NSAttributedString *)attributedStringWithImage:(UIImage *)image imageSize:(CGSize)imageSize alignToFont:(UIFont *)font {
    if (![image isKindOfClass:[UIImage class]]) {
        return [[NSAttributedString alloc] initWithString:@""];
    }
    
    // BUG: textAttachment is black
    // @see https://stackoverflow.com/questions/58153505/nstextattachment-image-in-attributed-text-with-foreground-colour
    //NSTextAttachment *textAttachment = [NSTextAttachment textAttachmentWithImage:image];
    
    CGFloat scaledHeight;
    CGFloat scaledWidth;
    CGFloat offsetY;
    
    if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
        scaledHeight = font.lineHeight;
        scaledWidth = scaledHeight / image.size.height * image.size.width;
        
        offsetY = -(scaledHeight - font.capHeight) / 2.0;
    }
    else {
        scaledHeight = imageSize.height;
        scaledWidth = imageSize.width;
        
        offsetY = -(scaledHeight - font.capHeight) / 2.0;
    }
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = image;
    // Note: bounds consider baseline, and ignore x, only conside y/width/height, y is upward
    textAttachment.bounds = CGRectMake(0, offsetY, scaledWidth, scaledHeight);
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    return attrStringWithImage;
}

#pragma mark - Private Utility Functions

/**
 Check if NSRange contains the other NSRange
 
 @param range1 the range which is expected as super range
 @param range2 the range which is expected as sub range
 @return YES if range1 contains or equals range2, and otherwise NO.
 @see https://gist.github.com/wokalski/3130403
 */
static BOOL NSRangeContainsRange(NSRange range1, NSRange range2) {
    BOOL retval = NO;
    if (range1.location <= range2.location && range1.location + range1.length >= range2.length + range2.location) {
        retval = YES;;
    }
    
    return retval;
}

@end
