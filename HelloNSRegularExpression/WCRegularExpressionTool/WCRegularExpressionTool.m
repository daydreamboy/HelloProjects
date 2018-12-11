//
//  WCRegularExpressionTool.m
//  HelloNSRegularExpression
//
//  Created by wesley_chen on 2018/9/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCRegularExpressionTool.h"

@implementation WCRegularExpressionTool

+ (nullable NSTextCheckingResult *)firstMatchInString:(NSString *)string pattern:(NSString *)pattern {
    if (![string isKindOfClass:[NSString class]] || string.length == 0 || ![pattern isKindOfClass:[NSString class]] || pattern.length == 0) {
        return nil;
    }
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:&error];
    if (error) {
        return nil;
    }
    
    NSTextCheckingResult *match = [regex firstMatchInString:string options:kNilOptions range:NSMakeRange(0, string.length)];
    return match;
}

+ (BOOL)enumerateMatchesInString:(NSString *)string pattern:(NSString *)pattern usingBlock:(void (^)(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop))block {
    if (![string isKindOfClass:[NSString class]] || string.length == 0 || ![pattern isKindOfClass:[NSString class]] || pattern.length == 0) {
        return NO;
    }
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:&error];
    if (error) {
        return NO;
    }
    
    if (block) {
        // Note: string should not nil
        [regex enumerateMatchesInString:string options:kNilOptions range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            BOOL shouldStop = NO;
            block(result, flags, &shouldStop);
            *stop = shouldStop;
        }];
        
        return YES;
    }
    else {
        return NO;
    }
}

+ (nullable NSString *)stringByReplacingMatchesInString:(NSString *)string pattern:(NSString *)pattern captureGroupBindingBlock:(nullable NSString *(^)(NSString *matchString, NSArray<NSString *> *captureGroupStrings))captureGroupBindingBlock {
    
    if (!captureGroupBindingBlock) {
        return string;
    }
    
    NSMutableArray<NSValue *> *ranges = [NSMutableArray array];
    NSMutableArray<NSString *> *replacementStrings = [NSMutableArray array];
    BOOL status = [self enumerateMatchesInString:string pattern:pattern usingBlock:^(NSTextCheckingResult * _Nonnull result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSRange matchRange = result.range;
        if (matchRange.location != NSNotFound && matchRange.length > 0) {
            NSString *matchString = [WCRegularExpressionTool substringWithString:string range:matchRange];
            
            NSMutableArray *captureGroupStrings = [NSMutableArray array];
            for (NSInteger i = 1; i < result.numberOfRanges; i++) {
                NSRange captureRange = [result rangeAtIndex:i];
                if (captureRange.location != NSNotFound) {
                    NSString *captureGroupString = [WCRegularExpressionTool substringWithString:string range:captureRange];
                    [captureGroupStrings addObject:captureGroupString ?: @""];
                }
            }
            
            NSString *replacementString = captureGroupBindingBlock(matchString, captureGroupStrings);
            if (replacementString) {
                [ranges addObject:[NSValue valueWithRange:matchRange]];
                [replacementStrings addObject:replacementString];
            }
        }
    }];
    
    if (!status) {
        return string;
    }
    
    return [WCRegularExpressionTool replaceCharactersInRangesWithString:string ranges:ranges replacementStrings:replacementStrings replacementRanges:nil];
}

#pragma mark - Utility

+ (nullable NSString *)substringWithString:(NSString *)string range:(NSRange)range {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (range.location == NSNotFound) {
        return nil;
    }
    
    if (range.location <= string.length) {
        // Note: Don't use range.location + range.length <= string.length, because if length is too large (e.g. NSUIntegerMax), location + length will become smaller (upper overflow)
        if (range.length <= string.length - range.location) {
            return [string substringWithRange:range];
        }
        else {
            return nil;;
        }
    }
    else {
        return nil;
    }
}

+ (nullable NSString *)replaceCharactersInRangesWithString:(NSString *)string ranges:(NSArray<NSValue *> *)ranges replacementStrings:(NSArray<NSString *> *)replacementStrings replacementRanges:(inout nullable NSMutableArray<NSValue *> *)replacementRanges {
    
    if (![string isKindOfClass:[NSString class]] ||
        ![ranges isKindOfClass:[NSArray class]] ||
        ![replacementStrings isKindOfClass:[NSArray class]] ||
        ranges.count != replacementStrings.count) {
        return nil;
    }
    
    // Parameter check: replacementRanges
    if (replacementRanges && ![replacementRanges isKindOfClass:[NSMutableArray class]]) {
        return nil;
    }
    
    // Parameter check: replacementStrings
    for (NSString *element in replacementStrings) {
        if (![element isKindOfClass:[NSString class]]) {
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
        
        if (!NSRangeContainsRange(NSMakeRange(0, string.length), range)) {
            return nil;
        }
    }
    
    // Note: empty array just return the original string
    if (ranges.count == 0 && replacementStrings.count == 0) {
        return string;
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
    
    NSInteger (^checkChacterInRanges)(NSRange) = ^NSInteger(NSRange rangeOfCharacter) {
        for (NSInteger i = 0; i < sortedRanges.count; i++) {
            NSRange currentRange = [sortedRanges[i] rangeValue];
            if (NSRangeContainsRange(currentRange, rangeOfCharacter)) {
                return i;
            }
        }
        
        return NSNotFound;
    };
    
    NSMutableArray<id> *replacementStringsM = [replacementStrings mutableCopy];
    [replacementRanges removeAllObjects];
    for (NSInteger i = 0; i < replacementStringsM.count; i++) {
        replacementRanges[i] = [NSValue valueWithRange:NSMakeRange(NSNotFound, 0)];
    }
    
    NSMutableString *stringM = [NSMutableString stringWithCapacity:string.length];
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
        NSString *character = substring;
        NSRange rangeOfCharacter = substringRange;
        
        NSInteger index = checkChacterInRanges(rangeOfCharacter);
        if (index != NSNotFound) {
            NSValue *rangeValue = sortedRanges[index];
            
            // Note: find the index of the replacement string in unsorted array
            NSInteger indexOfReplacementString = [ranges indexOfObject:rangeValue];
            if (indexOfReplacementString != NSNotFound) {
                NSString *stringToInsert = replacementStringsM[indexOfReplacementString];
                
                // Note: allow to insert empty string and check it if [NSNull null]
                if (stringToInsert && [stringToInsert isKindOfClass:[NSString class]]) {
                    // Note: record the range of stringToInsert
                    NSRange replacementRange = NSMakeRange(stringM.length, stringToInsert.length);
                    replacementRanges[indexOfReplacementString] = [NSValue valueWithRange:replacementRange];
                    
                    [stringM appendString:stringToInsert];
                    
                    // Note: set the stringToInsert to [NSNull null] to avoid inserting again
                    replacementStringsM[indexOfReplacementString] = [NSNull null];
                }
            }
        }
        else {
            [stringM appendString:character];
        }
    }];
    
    return stringM;
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
