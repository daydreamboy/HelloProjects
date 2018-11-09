//
//  WCAttributedStringTool.m
//  HelloNSAttributedString
//
//  Created by wesley_chen on 2018/10/24.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCAttributedStringTool.h"

@implementation WCAttributedStringTool

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
        
        NSAttributedString *attrStringToAppend = [WCAttributedStringTool attributedSubstringWithAttributedString:attributedString range:rangeOfStringToAppend];
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
            NSAttributedString *lastAttrStringToAppend = [WCAttributedStringTool attributedSubstringWithAttributedString:attributedString range:rangeOfLastStringToAppend];
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
    
    // Note: `\n` will count for a line, so strip it
    attributedString = [self replaceStringWithAttributedString:attributedString occurrenceString:@"\n" replacementString:@"" range:NSMakeRange(0, attributedString.length)];
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                 context:nil];
    CGSize textSize = rect.size;
    
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
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
