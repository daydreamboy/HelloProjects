//
//  WCAttributedStringTool.m
//  HelloNSAttributedString
//
//  Created by wesley_chen on 2018/10/24.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCAttributedStringTool.h"

@implementation WCAttributedStringTool

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
