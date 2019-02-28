//
//  WCRegularExpressionTool.m
//  HelloNSRegularExpression
//
//  Created by wesley_chen on 2018/9/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCRegularExpressionTool.h"

@implementation WCRegularExpressionTool

#define WCLog(fmt, ...) \
do { \
    if (self.enableLogging) { \
        NSLog(fmt, ##__VA_ARGS__); \
    } \
} while(0)

@dynamic enableLogging;
static BOOL sEnableLogging;

+ (void)setEnableLogging:(BOOL)enableLogging {
    sEnableLogging = enableLogging;
}

+ (BOOL)enableLogging {
    return sEnableLogging;
}

#pragma mark - Get Matched CheckResult/String

+ (nullable NSTextCheckingResult *)firstMatchInString:(NSString *)string pattern:(nullable NSString *)pattern reusableRegex:(nullable NSRegularExpression *)regex {
    if (![string isKindOfClass:[NSString class]] || string.length == 0) {
        return nil;
    }
    
    if ((![pattern isKindOfClass:[NSString class]] || pattern.length == 0) && (![regex isKindOfClass:[NSRegularExpression class]])) {
        return nil;
    }
    
    NSError *error = nil;
    NSRegularExpression *regexL;
    
    if (![regex isKindOfClass:[NSRegularExpression class]]) {
        regexL = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:&error];
        if (error) {
            return nil;
        }
    }
    else {
        regexL = regex;
    }
    
    NSTextCheckingResult *match = [regexL firstMatchInString:string options:kNilOptions range:NSMakeRange(0, string.length)];
    return match;
}

+ (nullable NSString *)firstMatchedStringInString:(NSString *)string pattern:(nullable NSString *)pattern reusableRegex:(nullable NSRegularExpression *)regex {
    NSTextCheckingResult *match = [self firstMatchInString:string pattern:pattern reusableRegex:regex];
    if (!match) {
        return nil;
    }
    
    return [WCRegularExpressionTool substringWithString:string range:match.range];
}

+ (BOOL)enumerateMatchesInString:(NSString *)string pattern:(NSString *)pattern usingBlock:(void (^)(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop))block {
    __block BOOL matched = NO;
    
    if (![string isKindOfClass:[NSString class]] || string.length == 0 || ![pattern isKindOfClass:[NSString class]] || pattern.length == 0) {
        return matched;
    }
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:&error];
    if (error) {
        return matched;
    }
    
    if (block) {
        // Note: string should not nil
        [regex enumerateMatchesInString:string options:kNilOptions range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            matched = YES;
            
            BOOL shouldStop = NO;
            block(result, flags, &shouldStop);
            *stop = shouldStop;
        }];
        
        return matched;
    }
    else {
        return matched;
    }
}

#pragma mark - Replace Matched String

+ (nullable NSString *)stringByReplacingMatchesInString:(NSString *)string pattern:(NSString *)pattern captureGroupBindingBlock:(nullable NSString *(^)(NSString *matchString, NSArray<NSString *> *captureGroupStrings))captureGroupBindingBlock {
    
    if (![string isKindOfClass:[NSString class]] || string.length == 0) {
        return nil;
    }
    
    if (![pattern isKindOfClass:[NSString class]] || pattern.length == 0) {
        return nil;
    }
    
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
                else {
                    [captureGroupStrings addObject:@""];
                }
            }
            
            NSString *replacementString = captureGroupBindingBlock(matchString, captureGroupStrings);
            if ([replacementString isKindOfClass:[NSString class]]) {
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

+ (nullable NSString *)stringByReplacingMatchesInString:(NSString *)string regularExpression:(NSRegularExpression *)regex captureGroupBindingBlock:(nullable NSString *(^)(NSString *matchString, NSArray<NSString *> *captureGroupStrings))captureGroupBindingBlock {
    
    if (![string isKindOfClass:[NSString class]] || string.length == 0) {
        return nil;
    }
    
    if (![regex isKindOfClass:[NSRegularExpression class]]) {
        return nil;
    }
    
    if (!captureGroupBindingBlock) {
        return string;
    }
    
    NSMutableArray<NSValue *> *ranges = [NSMutableArray array];
    NSMutableArray<NSString *> *replacementStrings = [NSMutableArray array];
    [regex enumerateMatchesInString:string options:kNilOptions range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
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
                else {
                    [captureGroupStrings addObject:@""];
                }
            }
            
            NSString *replacementString = captureGroupBindingBlock(matchString, captureGroupStrings);
            if ([replacementString isKindOfClass:[NSString class]]) {
                [ranges addObject:[NSValue valueWithRange:matchRange]];
                [replacementStrings addObject:replacementString];
            }
        }
    }];
    
    return [WCRegularExpressionTool replaceCharactersInRangesWithString:string ranges:ranges replacementStrings:replacementStrings replacementRanges:nil];
}

+ (nullable NSString *)substituteTemplateStringWithString:(NSString *)string bindings:(NSDictionary *)bindings {
    NSString *pattern = @"\\$!?(?:\\{([a-zA-Z]+[a-zA-Z0-9_\\-\\.\\[\\]\\$!]*)\\}|([a-zA-Z]+[a-zA-Z0-9_\\-.\\[\\]\\$!]*))";
    return [self stringByReplacingMatchesInString:string pattern:pattern captureGroupBindingBlock:^NSString * _Nonnull(NSString * _Nonnull matchString, NSArray<NSString *> * _Nonnull captureGroupStrings) {
        
        if (captureGroupStrings.count == 2) {
            BOOL useEmptyStringWhenMissing = [matchString hasPrefix:@"$!"] ? YES : NO;
            
            // i = 0, match ${a}
            // i = 1, match $a
            for (NSInteger i = 0; i < captureGroupStrings.count; i++) {
                NSString *variableName = captureGroupStrings[i];
                if (variableName.length) {
                    NSString *substitutedString = [WCRegularExpressionTool valueOfKVCObject:bindings usingKeyPath:variableName bindings:bindings];
                    if (substitutedString) {
                        return substitutedString;
                    }
                    else {
                        return useEmptyStringWhenMissing ? @"" : nil;
                    }
                }
            }
        }
        
        return nil;
    }];
}

#pragma mark - Validate Pattern

+ (BOOL)checkPatternWithString:(NSString *)string error:(inout NSError * _Nullable *)error {
    if (![string isKindOfClass:[NSString class]] || string.length == 0) {
        return NO;
    }
    
    NSError *errorL = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:string options:kNilOptions error:&errorL];
    if (error) {
        *error = errorL;
    }
    
    return regex ? YES : NO;
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

+ (nullable id)valueOfKVCObject:(id)KVCObject usingKeyPath:(NSString *)keyPath bindings:(nullable NSDictionary *)bindings {
#define NSPREDICATE(expression)    ([NSPredicate predicateWithFormat:@"SELF MATCHES %@", expression])
    if (!KVCObject || ![keyPath isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (keyPath.length == 0) {
        return KVCObject;
    }
    
    NSArray *parts = [keyPath componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@".[]"]];
    NSMutableArray *keys = [NSMutableArray arrayWithArray:parts];
    // Note: remove all empty string
    [keys removeObject:@""];
    
    id value = KVCObject;
    while (keys.count) {
        NSString *key = [keys firstObject];
        
        if (bindings && [key rangeOfString:@"$"].location != NSNotFound) {
            key = [WCRegularExpressionTool stringByReplacingMatchesInString:key pattern:@"\\$!?(?:\\{([a-zA-Z]+[a-zA-Z0-9_-]*)\\}|([a-zA-Z]+[a-zA-Z0-9_-]*))" captureGroupBindingBlock:^NSString *(NSString *matchString, NSArray<NSString *> *captureGroupStrings) {
                for (NSString *captureGroupString in captureGroupStrings) {
                    if (bindings[captureGroupString]) {
                        WCLog(@"Info: Replace %@ to %@", matchString, bindings[captureGroupString]);
                        return bindings[captureGroupString];
                    }
                }
                return nil;
            }];
        }
        
        if ([value isKindOfClass:[NSArray class]]) {
            // Note: handle NSArray container
            if (![NSPREDICATE(@"0|[1-9]\\d*") evaluateWithObject:key]) {
                WCLog(@"Error: %@ is not a subscript of NSArray", key);
                return nil;
            }
            
            NSInteger subscript = [key integerValue];
            NSArray *arr = (NSArray *)value;
            
            if (subscript < 0 || subscript >= arr.count) {
                WCLog(@"Error: subscript %@ is out of bounds [0..%ld]", key, (long)arr.count - 1);
                return nil;
            }
            
            value = arr[subscript];
        }
        else if ([value isKindOfClass:[NSDictionary class]]) {
            // Note: handle NSDictionary container
            NSDictionary *dict = (NSDictionary *)value;
            
            value = dict[key];
        }
        else if ([value isKindOfClass:[NSObject class]]) {
            // Note: handle custom container
            NSObject *KVCObject = (NSObject *)value;
            @try {
                value = [KVCObject valueForKey:key];
            }
            @catch (NSException *e) {
                WCLog(@"Error: object `%@` is not KVC compliant for key `%@`", KVCObject, key);
                return nil;
            }
        }
        else {
            WCLog(@"Error: unsupported object %@", KVCObject);
            return nil;
        }
        
        [keys removeObjectAtIndex:0];
    }
    
    return value;
#undef NSPREDICATE
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
