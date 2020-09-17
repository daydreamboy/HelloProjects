//
//  WCStringTool.m
//  HelloNSString
//
//  Created by wesley_chen on 2018/5/30.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCStringTool.h"
#import <CommonCrypto/CommonDigest.h>

#ifndef NSPREDICATE
#define NSPREDICATE(expression)    ([NSPredicate predicateWithFormat:@"SELF MATCHES %@", expression])
#endif

@implementation WCStringTool

#pragma mark - Handle String As Text In UILabel

+ (CGSize)textSizeWithSingleLineString:(NSString *)string font:(UIFont *)font {
    if (![string isKindOfClass:[NSString class]] || !string.length || ![font isKindOfClass:[UIFont class]]) {
        return CGSizeZero;
    }
    
    return [self textSizeWithSingleLineString:string attributes:@{ NSFontAttributeName: font }];
}

+ (CGSize)textSizeWithSingleLineString:(NSString *)string attributes:(NSDictionary *)attributes {
    if (![string isKindOfClass:[NSString class]] || !string.length || ![attributes isKindOfClass:[NSDictionary class]]) {
        return CGSizeZero;
    }
    
    // Note: `\n` and `\r` will count for a line, so strip it
    NSString *singleLineString = [[string stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    CGSize textSize = [singleLineString sizeWithAttributes:attributes];
    
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
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

+ (CGSize)textSizeWithFixedLineString:(NSString *)string width:(CGFloat)width font:(UIFont *)font maximumNumberOfLines:(NSUInteger)maximumNumberOfLines mode:(NSLineBreakMode)lineBreakMode widthToFit:(BOOL)widthToFit {
    if (![string isKindOfClass:[NSString class]] || !string.length || ![font isKindOfClass:[UIFont class]] || width <= 0) {
        return CGSizeZero;
    }
    
    if (maximumNumberOfLines <= 0) {
        return [self textSizeWithMultipleLineString:string width:width font:font mode:lineBreakMode widthToFit:widthToFit];
    }
    else {
        CGSize textSizeForOneLine = [self textSizeWithSingleLineString:string font:font];
        CGSize textSizeForMultipleLines = [self textSizeWithMultipleLineString:string width:width font:font mode:lineBreakMode widthToFit:widthToFit];
        
        CGFloat height;
        if (textSizeForMultipleLines.height > (maximumNumberOfLines * textSizeForOneLine.height)) {
            height = (maximumNumberOfLines * textSizeForOneLine.height);
        }
        else {
            height = textSizeForMultipleLines.height;
        }
        return CGSizeMake(textSizeForMultipleLines.width, ceil(height));
    }
}

#pragma mark > Others

+ (nullable NSString *)softHyphenatedStringWithString:(NSString *)string error:(out NSError **)error {
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    
    return [self softHyphenatedStringWithString:string locale:locale error:error];
}

+ (nullable NSString *)softHyphenatedStringWithString:(NSString *)string locale:(NSLocale *)locale error:(out NSError **)error {
    if (![string isKindOfClass:[NSString class]] || ![locale isKindOfClass:[NSLocale class]]) {
        return nil;
    }
    
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
                // Note: use the following line for debugging
                //[stringM insertString:@"-" atIndex:i];
            }
        }
        
        if (error != NULL) { *error = nil; }
        
        return stringM;
    }
}

+ (nullable NSString *)interpolatedStringWithCamelCaseString:(NSString *)string separator:(nullable NSString *)separator {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (separator && ![separator isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (!separator) {
        return string;
    }
    else {
        NSString *template = [NSString stringWithFormat:@"$1%@$2", separator];
        NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"([a-z])([A-Z])" options:kNilOptions error:NULL];
        NSString *newString = [regexp stringByReplacingMatchesInString:string options:kNilOptions range:NSMakeRange(0, string.length) withTemplate:template];
        return newString;
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

#pragma mark - Handle String As Plain

#pragma mark > Substring String

+ (nullable NSString *)substringWithString:(NSString *)string atLocation:(NSUInteger)location length:(NSUInteger)length byVisualization:(BOOL)byVisualization {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (location <= string.length) {
        // Note: Don't use location + length <= string.length, because if length is too large (e.g. NSUIntegerMax), location + length will become smaller (upper overflow)
        if (length <= string.length - location) {
            return [string substringWithRange:NSMakeRange(location, length)];
        }
        else {
            // Now substring from loc to the end of string
            return [string substringFromIndex:location];
        }
    }
    else {
        return nil;
    }
}

+ (nullable NSString *)substringWithString:(NSString *)string range:(NSRange)range byVisualization:(BOOL)byVisualization {
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

+ (NSString *)firstSubstringWithString:(NSString *)string substringInCharacterSet:(NSCharacterSet *)characterSet {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSString *substring = nil;
    
    NSScanner *scanner = [NSScanner scannerWithString:string];
    
    // Throw away characters before matching the first character in characterSet
    [scanner scanUpToCharactersFromSet:characterSet intoString:NULL];
    
    // Start collecting characters in characterSet until not matching the first character in the characterSet
    [scanner scanCharactersFromSet:characterSet intoString:&substring];
    
    return substring;
}

#pragma mark > Split String

+ (nullable NSArray<NSString *> *)componentsWithString:(NSString *)string delimeters:(NSArray<NSString *> *)delimeters {
    return [self componentsWithString:string delimeters:delimeters mode:WCStringSplitInComponentsModeWithoutDelimiter];
}

+ (nullable NSArray<NSString *> *)componentsWithString:(NSString *)string delimeters:(NSArray<NSString *> *)delimeters mode:(WCStringSplitInComponentsMode)mode {
    if (![string isKindOfClass:[NSString class]] || ![delimeters isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    if (mode != WCStringSplitInComponentsModeWithoutDelimiter && mode != WCStringSplitInComponentsModeIncludeDelimiter) {
        return nil;
    }
    
    if (mode == WCStringSplitInComponentsModeWithoutDelimiter) {
        NSMutableArray *strings = [NSMutableArray arrayWithObject:string];
        NSArray *components = [self splitStringWithComponents:strings delimeters:[delimeters mutableCopy]];
        return components;
    }
    else if (mode == WCStringSplitInComponentsModeIncludeDelimiter) {
        return [self splitStringWithString:string delimeters:delimeters currentDelimeterIndex:0];
    }
    
    return nil;
}

#pragma mark ::

+ (NSArray<NSString *> *)splitStringWithString:(NSString *)string delimeters:(NSArray<NSString *> *)delimeters currentDelimeterIndex:(NSUInteger)currentDelimeterIndex {
    
    if (currentDelimeterIndex < delimeters.count) {
        NSString *separator = delimeters[currentDelimeterIndex];
        NSArray *components = [string componentsSeparatedByString:separator];
        NSUInteger numberOfSeparator = components.count - 1;
        NSUInteger count = 0;
        NSMutableArray *componentsIncludeSeparator = [NSMutableArray arrayWithCapacity:components.count];
        
        for (NSUInteger i = 0; i < components.count; ++i) {
            NSString *component = components[i];
            
            if (component.length == 0) {
                if (count < numberOfSeparator) {
                    [componentsIncludeSeparator addObject:separator];
                }
                ++count;
            }
            else {
                NSArray *subcomponents = [self splitStringWithString:component delimeters:delimeters currentDelimeterIndex:currentDelimeterIndex + 1];
                if (subcomponents.count) {
                    [componentsIncludeSeparator addObjectsFromArray:subcomponents];
                    
                    if (i + 1 < components.count) {
                        NSString *nextComponent = components[i + 1];
                        if (nextComponent.length > 0) {
                            [componentsIncludeSeparator addObject:separator];
                        }
                    }
                }
            }
        }
        
        return componentsIncludeSeparator;
    }
    else {
        return string ? @[string] : nil;
    }
}

+ (NSMutableArray<NSString *> *)splitStringWithComponents:(NSMutableArray<NSString *> *)components delimeters:(NSMutableArray<NSString *> *)delimeters {
    if (delimeters.count) {
        // Get the first delimeter
        NSString *delimeter = [delimeters firstObject];
        NSMutableArray *parts = [NSMutableArray array];
        for (NSString *component in components) {
            NSMutableArray *subcomponents = [[component componentsSeparatedByString:delimeter] mutableCopy];
            [subcomponents removeObject:@""];
            [parts addObjectsFromArray:subcomponents];
        }
        
        // remove the used delimeter
        [delimeters removeObjectAtIndex:0];
        return [self splitStringWithComponents:parts delimeters:delimeters];
    }
    else {
        return components;
    }
}

#pragma mark ::

+ (nullable NSArray<NSString *> *)componentsWithString:(NSString *)string gapRanges:(NSArray<NSValue *> *)gapRanges {
    if (![string isKindOfClass:[NSString class]] || ![gapRanges isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    // Parameter check: gapRanges
    for (NSValue *value in gapRanges) {
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
    
    // Note: sort the gapRanges by ascend
    NSArray *sortedGapRanges = [gapRanges sortedArrayUsingComparator:^NSComparisonResult(NSValue * _Nonnull value1, NSValue * _Nonnull value2) {
        NSComparisonResult result = NSOrderedSame;
        if (value1.rangeValue.location > value2.rangeValue.location) {
            result = NSOrderedDescending;
        }
        else if (value1.rangeValue.location < value2.rangeValue.location) {
            result = NSOrderedAscending;
        }
        return result;
    }];
    
    BOOL valid = YES;
    NSRange previousRange = NSMakeRange(0, 0);
    NSMutableArray<NSString *> *componentsM = [NSMutableArray array];
    for (NSInteger i = 0; i < sortedGapRanges.count; i++) {
        NSRange currentRange = [sortedGapRanges[i] rangeValue];
        // @see https://stackoverflow.com/a/10172768
        NSRange intersection = NSIntersectionRange(previousRange, currentRange);
        if (intersection.length > 0) {
            // Note: the two ranges does intersect
            valid = NO;
            break;
        }
        
        NSRange extractRange = NSMakeRange(previousRange.location + previousRange.length, currentRange.location - (previousRange.location + previousRange.length));
        NSString *substring = [WCStringTool substringWithString:string range:extractRange byVisualization:NO];
        if (substring) {
            [componentsM addObject:substring];
        }
        else {
            valid = NO;
            break;
        }
        
        previousRange = [sortedGapRanges[i] rangeValue];
        
        if (i == sortedGapRanges.count - 1) {
            // last gap range
            NSRange extractRange = NSMakeRange(currentRange.location + currentRange.length, string.length - (previousRange.location + previousRange.length));
            
            NSString *substring = [WCStringTool substringWithString:string range:extractRange byVisualization:NO];
            if (substring) {
                [componentsM addObject:substring];
            }
            else {
                valid = NO;
                break;
            }
        }
    }
    
    if (!valid) {
        return nil;
    }
    
    return componentsM;
}

+ (nullable NSArray<NSString *> *)componentsWithString:(NSString *)string charactersInSet:(NSCharacterSet *)charactersSet substringRangs:(inout NSMutableArray<NSValue *> *)substringRanges {
    
    if (![string isKindOfClass:[NSString class]] || ![charactersSet isKindOfClass:[NSCharacterSet class]]) {
        return nil;
    }
    
    if (substringRanges && ![substringRanges isKindOfClass:[NSMutableArray class]]) {
        return nil;
    }
    
    NSMutableArray<NSString *> *substrings = [NSMutableArray array];
    [substringRanges removeAllObjects];
    
    __block NSMutableString *buffer = nil;
    __block NSRange bufferRange = NSMakeRange(0, 0);
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable character, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
        if ([character rangeOfCharacterFromSet:charactersSet].location == NSNotFound) {
            if (!buffer) {
                buffer = [NSMutableString stringWithCapacity:string.length];
                bufferRange.location = substringRange.location;
            }
            [buffer appendString:character];
            bufferRange.length += character.length;
        }
        else {
            if (buffer.length) {
                [substrings addObject:buffer];
                [substringRanges addObject:[NSValue valueWithRange:bufferRange]];
            }
            
            // reset
            buffer = nil;
            bufferRange = NSMakeRange(0, 0);
        }
    }];
    
    if (buffer.length) {
        [substrings addObject:buffer];
        [substringRanges addObject:[NSValue valueWithRange:bufferRange]];
    }
    
    return substrings;
}

#pragma mark > unichar

+ (NSString *)stringWithUnichar:(unichar)unichar {
    // Note: %C for unichar with 16 bits width
    NSString *string = [NSString stringWithFormat:@"%C", unichar];
    return string;
}

#pragma mark > String Validation

+ (BOOL)checkStringContainsCharactersAscendOrDescendWithString:(NSString *)string charactersLength:(NSInteger)charactersLength {
    if (![string isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if (charactersLength < 2 && string.length < 2) {
        return NO;
    }
    
    NSInteger ascendCount = 1;
    NSInteger descendCount = 1;
    for (NSInteger i = 1; i < string.length; i++) {
        unichar previousChar = [string characterAtIndex:i - 1];
        unichar currentChar = [string characterAtIndex:i];
        
        ascendCount = (currentChar - previousChar == 1 ? ++ascendCount : 1);
        descendCount = (currentChar - previousChar == -1 ? ++descendCount : 1);
        
        if (ascendCount >= charactersLength || descendCount >= charactersLength) {
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL)checkStringUniformedBySingleCharacterWithString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    NSRange range = NSMakeRange(0, string.length);
    
    __block BOOL uniformed = YES;
    __block NSString *previousString = nil;
    
    [string enumerateSubstringsInRange:range options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        if (!previousString) {
            previousString = substring;
        }
        else {
            if (![previousString isEqualToString:substring]) {
                uniformed = NO;
                *stop = YES;
            }
        }
    }];
    
    return uniformed;
}

+ (BOOL)checkStringComposedOfNumbersWithString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    return [NSPREDICATE(@"^[0-9]+[0-9]*$") evaluateWithObject:string];
}

+ (BOOL)checkStringComposedOfLettersWithString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    return [NSPREDICATE(@"^[a-zA-Z]+[a-zA-Z]*$") evaluateWithObject:string];
}

+ (BOOL)checkStringComposedOfLettersLowercaseWithString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    return [NSPREDICATE(@"^[a-z]+[a-z]*$") evaluateWithObject:string];
}

+ (BOOL)checkStringComposedOfLettersUppercaseWithString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    return [NSPREDICATE(@"^[A-Z]+[A-Z]*$") evaluateWithObject:string];
}

+ (BOOL)checkStringComposedOfChineseCharactersWithString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    return [NSPREDICATE(@"^[\u4e00-\u9fa5]+[\u4e00-\u9fa5]*$") evaluateWithObject:string];
}

+ (BOOL)checkStringAsAlphanumericWithString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if (string.length) {
        static NSCharacterSet *characterSet;
        if (!characterSet) {
            characterSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"];
        }
        
        return ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location == NSNotFound);
    }
    else {
        // empty string is not alphanumeric
        return NO;
    }
}

+ (BOOL)checkStringAsNoneNegativeIntegerWithString:(NSString *)string {
    return [self checkStringAsNaturalIntegerWithString:string];
}

+ (BOOL)checkStringAsNaturalIntegerWithString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if (string.length) {
        if ([string hasPrefix:@"0"] && string.length != 1) {
            return NO;
        }
        else {
            NSCharacterSet *noneNumberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
            NSRange range = [string rangeOfCharacterFromSet:noneNumberSet];
            
            return range.location == NSNotFound;
        }
    }
    else {
        return NO;
    }
}

+ (BOOL)checkStringAsPositiveIntegerWithString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    return [NSPREDICATE(@"^[1-9]+[0-9]*$") evaluateWithObject:string];
}

+ (BOOL)checkStringAsEmailWithString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    return [NSPREDICATE(@"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}") evaluateWithObject:string];
}

+ (BOOL)checkStringURLEscapedWithString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    NSString *decodedString = [WCStringTool URLUnescapedStringWithString:string];
    NSString *encodedString = [WCStringTool URLEscapedStringWithString:decodedString];
    if ([encodedString isEqualToString:string]) {
        return YES;
    }
    return NO;
}

+ (BOOL)checkStringContainsChineseCharactersWithString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]] || string.length == 0) {
        return NO;
    }
    
    __block BOOL containsChineseCharacter = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
        NSString *character = substring;
        if ([WCStringTool checkStringComposedOfChineseCharactersWithString:character]) {
            containsChineseCharacter = YES;
            *stop = YES;
        }
    }];
    
    return containsChineseCharacter;
}

+ (BOOL)checkStringContainsAllCharactersWithString:(NSString *)string allCharacters:(NSString *)allCharacters {
    if (![string isKindOfClass:[NSString class]] || string.length == 0) {
        return NO;
    }
    
    if (![allCharacters isKindOfClass:[NSString class]] || allCharacters.length == 0) {
        return NO;
    }
    
    __block NSMutableDictionary *buckets = [NSMutableDictionary dictionary];
    [allCharacters enumerateSubstringsInRange:NSMakeRange(0, allCharacters.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        NSString *character = substring;
        buckets[character] = @(NO);
    }];
    
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
        NSString *character = substring;
        if (buckets[character]) {
            buckets[character] = @(YES);
        }
    }];
    
    __block BOOL containsAllCharacters = YES;
    [allCharacters enumerateSubstringsInRange:NSMakeRange(0, allCharacters.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        NSString *character = substring;
        // Note: the character is not hit
        if ([buckets[character] boolValue] == NO) {
            containsAllCharacters = NO;
            *stop = YES;
        }
    }];
    
    return containsAllCharacters;
}

#pragma mark > String Generation

+ (NSString *)randomStringWithLength:(NSUInteger)length {
    NSString *characters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    return [self randomStringWithCharacters:characters length:length];
}

+ (NSString *)randomStringWithCharacters:(NSString *)characters length:(NSUInteger)length {
    if (![characters isKindOfClass:[NSString class]] || !characters.length || length == 0) {
        return nil;
    }

    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    for (int i = 0; i < length; i++) {
        [randomString appendFormat:@"%C", [characters characterAtIndex:arc4random_uniform((u_int32_t)characters.length)]];
    }
    
    return randomString;
}

+ (NSString *)spacedStringWithString:(NSString *)string format:(NSString *)format {
    if (![string isKindOfClass:[NSString class]] || ![format isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSString *trimmedString = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSMutableString *stringM = [NSMutableString string];
    NSUInteger i = 0;
    NSUInteger j = 0;
    for (i = 0; i < format.length && j < trimmedString.length; i++) {
        
        unichar char1 = [format characterAtIndex:i];
        unichar char2 = [trimmedString characterAtIndex:j];
        
        if (char1 == ' ') {
            [stringM appendString:@" "];
        }
        else {
            [stringM appendFormat:@"%C", char2];
            j++;
        }
    }
    
    for (; j < trimmedString.length; j++) {
        [stringM appendFormat:@"%C", [trimmedString characterAtIndex:j]];
    }
    
    return [stringM copy];
}

+ (nullable NSString *)stringWithFormat:(NSString *)format arguments:(NSArray *)arguments {
    if (![format isKindOfClass:[NSString class]] || ![arguments isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    if (arguments.count > 20) {
        return @"";
    }
    
    NSArray *args = [arguments arrayByAddingObjectsFromArray:@[@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X"]];
    return [NSString stringWithFormat:format, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19]];
}

+ (nullable NSString *)collapseAdjacentCharactersWithString:(NSString *)string characters:(NSString *)characters {
    if (![string isKindOfClass:[NSString class]] || ![characters isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (characters.length == 0) {
        return string;
    }
    
    NSMutableString *collapsedString = [NSMutableString string];
    __block NSString *testString; // used to ommit continuous same characters
    __block BOOL isFirstSubstring = YES;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock: ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        if (isFirstSubstring) {
            
            [collapsedString appendString:substring];
            testString = substring;
            
            isFirstSubstring = NO;
        }
        else {
            if (![characters rangeOfString:testString].length || ![testString isEqualToString:substring]) {
                
                [collapsedString appendString:substring];
                testString = substring;
            }
        }
    }];
    
    return collapsedString;
}

+ (nullable NSString *)insertSeparatorWithString:(NSString *)string separator:(NSString *)separator atInterval:(NSInteger)interval {
    
    if (![string isKindOfClass:[NSString class]] || ![separator isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (interval <= 0) {
        return string;
    }
    
    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:string];
    for (NSInteger i = 0; i < [mutableString length]; i++) {
        if (i % (interval + 1) == 0) {
            [mutableString insertString:separator atIndex:i];
        }
    }
    NSString *interpolatedString = [mutableString substringFromIndex:1];
    
    return interpolatedString;
}

+ (nullable NSString *)truncatedStringWithString:(NSString *)string limitedToLength:(NSUInteger)length truncatingStyle:(WCStringTruncatingStyle)truncatingStyle separator:(nullable NSString *)separator {
    
    if (![string isKindOfClass:[NSString class]] || (truncatingStyle != WCStringTruncatingStyleNone && truncatingStyle != WCStringTruncatingStyleHead && truncatingStyle != WCStringTruncatingStyleTrail && truncatingStyle != WCStringTruncatingStyleMiddle)) {
        return nil;
    }
    
    if (string.length <= length || truncatingStyle == WCStringTruncatingStyleNone) {
        return string;
    }
    
    NSString *separatorL = separator ?: @"...";
    NSUInteger separatorLength = separatorL.length;
    NSUInteger showedLength = length - separatorLength;
    
    switch (truncatingStyle) {
        case WCStringTruncatingStyleHead: {
            return [NSString stringWithFormat:@"%@%@", separatorL, [self substringWithString:string atLocation:string.length - showedLength length:NSUIntegerMax byVisualization:NO]];
        }
        case WCStringTruncatingStyleMiddle: {
            NSUInteger frontCharsLength = ceil(showedLength / 2.0);
            NSUInteger backCharsLength = floor(showedLength / 2.0);
            
            return [NSString stringWithFormat:@"%@%@%@", [self substringWithString:string atLocation:0 length:frontCharsLength byVisualization:NO], separatorL, [self substringWithString:string atLocation:string.length - backCharsLength length:NSUIntegerMax byVisualization:NO]];
        }
        case WCStringTruncatingStyleTrail: {
            return [NSString stringWithFormat:@"%@%@", [self substringWithString:string atLocation:0 length:showedLength  byVisualization:NO], separatorL];
        }
        case WCStringTruncatingStyleNone:
        default: {
            return string;
        }
    }
}

#pragma mark > String Modification

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
        if (range.location == NSNotFound) {
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
    NSMutableArray *sortedRanges = [[ranges sortedArrayUsingComparator:^NSComparisonResult(NSValue * _Nonnull value1, NSValue * _Nonnull value2) {
        NSComparisonResult result = NSOrderedSame;
        if (value1.rangeValue.location > value2.rangeValue.location) {
            result = NSOrderedDescending;
        }
        else if (value1.rangeValue.location < value2.rangeValue.location) {
            result = NSOrderedAscending;
        }
        return result;
    }] mutableCopy];
    
    [sortedRanges removeObject:[NSValue valueWithRange:NSMakeRange(0, 0)]];
    
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

#pragma mark > String Conversion

#pragma mark >> String to CGRect/UIEdgeInsets/UIColor

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

#pragma mark  >> Unicode

+ (nullable NSString *)unescapeUTF8EncodingStringWithString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    // Bug: The escaped string must use \u not \U, CFStringTransform only treats \u
    NSString *modifiedString = [string stringByReplacingOccurrencesOfString:@"\\U" withString:@"\\u"];
    // Note: remove left or right redundant `"` if needed
    modifiedString = [modifiedString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
    
    NSMutableString *unescapedString = [modifiedString mutableCopy];
    CFStringRef transform = CFSTR("Any-Hex/Java");
    __unused BOOL status = CFStringTransform((__bridge CFMutableStringRef)unescapedString, NULL, transform, YES);
    
    return [unescapedString copy];
}

+ (nullable NSString *)unicodePointStringWithString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    // A -> \U00000041, so length multiply by 10
    NSMutableString *unicodePointString = [NSMutableString stringWithCapacity:string.length * 10];
    
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
        NSUInteger lengthByUnichar = [substring length];
        
        if (lengthByUnichar == 1) {
            unichar buffer[2] = {0};
            
            [substring getBytes:buffer maxLength:sizeof(unichar) usedLength:NULL encoding:NSUTF16StringEncoding options:0 range:NSMakeRange(0, substring.length) remainingRange:NULL];
            
            [unicodePointString appendFormat:@"\\U%08X", buffer[0]];
        }
        else if (lengthByUnichar == 2) {
            unsigned int buffer[2] = {0};
            
            [substring getBytes:buffer maxLength:sizeof(unsigned int) usedLength:NULL encoding:NSUTF32StringEncoding options:0 range:NSMakeRange(0, substring.length) remainingRange:NULL];
            
            [unicodePointString appendFormat:@"\\U%08X", buffer[0]];
        }
    }];

    return unicodePointString;
}

+ (nullable NSNumber *)numberFromString:(NSString *)string encodedType:(char *)encodedType {
    if (![string isKindOfClass:[NSString class]] || string.length == 0 || encodedType == NULL) {
        return nil;
    }
    
    NSNumber *number = nil;
    
    if (strcmp(encodedType, @encode(BOOL)) == 0) {
        BOOL value = [string boolValue];
        number = [NSNumber numberWithBool:value];
    }
    else {
        NSCharacterSet *subSet = [NSCharacterSet characterSetWithCharactersInString:string];
        NSCharacterSet *superSet = [NSCharacterSet characterSetWithCharactersInString:@"-.0123456789"];
        if (![superSet isSupersetOfSet:subSet]) {
            return nil;
        }
        
        // Note: NSString provides doubleValue/floatValue/intValue/longLongValue/boolValue
        if (strcmp(encodedType, @encode(double)) == 0) {
            double value = [string doubleValue];
            number = [NSNumber numberWithDouble:value];
        }
        else if (strcmp(encodedType, @encode(float)) == 0) {
            float value = [string floatValue];
            number = [NSNumber numberWithFloat:value];
        }
        else if (strcmp(encodedType, @encode(int)) == 0) {
            int value = [string intValue];
            number = [NSNumber numberWithInt:value];
        }
        else if (strcmp(encodedType, @encode(NSInteger)) == 0 ||
                 strcmp(encodedType, @encode(long long)) == 0 ||
                 strcmp(encodedType, @encode(long)) == 0) {
            long long value = [string longLongValue];
            number = [NSNumber numberWithLongLong:value];
        }
    }
    
    return number;
}

+ (nullable NSString *)binaryStringFromInt64:(int64_t)intValue {
    int sizeOfByte = 8,            // 8 bits per byte
    numberOfBits = (sizeof(int64_t)) * sizeOfByte; // Total bits
    
    return [self binaryStringFromIntX:intValue numberOfBits:numberOfBits];
}

+ (nullable NSString *)binaryStringFromInt32:(int32_t)intValue {
    int sizeOfByte = 8,            // 8 bits per byte
    numberOfBits = (sizeof(int32_t)) * sizeOfByte; // Total bits
    
    return [self binaryStringFromIntX:intValue numberOfBits:numberOfBits];
}

+ (nullable NSString *)binaryStringFromInt16:(int16_t)intValue {
    int sizeOfByte = 8,            // 8 bits per byte
    numberOfBits = (sizeof(int16_t)) * sizeOfByte; // Total bits
    
    return [self binaryStringFromIntX:intValue numberOfBits:numberOfBits];
}

+ (nullable NSString *)binaryStringFromInt8:(int8_t)intValue {
    int sizeOfByte = 8,            // 8 bits per byte
    numberOfBits = (sizeof(int8_t)) * sizeOfByte; // Total bits
    
    return [self binaryStringFromIntX:intValue numberOfBits:numberOfBits];
}

+ (nullable NSString *)binaryStringFromIntX:(int64_t)intValue numberOfBits:(int64_t)numberOfBits {
    // Note: intValue's type maximum allow int64_t
    int64_t indexOfDigits = numberOfBits;
    
    // C array - storage plus one for null
    char digits[numberOfBits + 1];
    
    while (indexOfDigits-- > 0)
    {
        // Set digit in array based on rightmost bit
        digits[indexOfDigits] = (intValue & 1) ? '1' : '0';
        
        // Shift incoming value one to right
        intValue >>= 1;
    }
    
    // Append null
    digits[numberOfBits] = 0;
    
    // Return the binary string
    return [NSString stringWithUTF8String:digits];
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

+ (NSInteger)lengthWithString:(NSString *)string treatChineseCharacterAsTwoCharacters:(BOOL)chineseCharacterAsTwoCharacters {
    if (![string isKindOfClass:[NSString class]]) {
        return NSNotFound;
    }
    
    NSUInteger len = string.length;
    
    if (!chineseCharacterAsTwoCharacters) {
        return len;
    }
    else {
        // CJK Unified Ideographs, details see http://www.ssec.wisc.edu/~tomw/java/unicode.html
        NSString *pattern = @"[\u4e00-\u9fff]";
        NSError *error;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        if (error) {
            return NSNotFound;
        }
        
        NSUInteger numberOfMatch = [regex numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, len)];
        return len + numberOfMatch;
    }
}

+ (NSInteger)lengthByVisualizationWithString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return NSNotFound;
    }
    
    // @see https://www.objc.io/issues/9-strings/unicode/#length, not work with 🇻🇳
    //NSUInteger lengthByVisualization = [string lengthOfBytesUsingEncoding:NSUTF32StringEncoding] / 4;
    
    __block NSInteger count = 0;
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        ++count;
    }];
    
    return count;
}

+ (NSInteger)occurrenceOfSubstringInString:(NSString *)string substring:(NSString *)substring {
    
    if (![string isKindOfClass:[NSString class]] || ![substring isKindOfClass:[NSString class]]) {
        return NSNotFound;
    }
    
    NSArray *parts = [string componentsSeparatedByString:substring];
    if ([parts count] > 0) {
        return [parts count] - 1;
    }
    else {
        return 0;
    }
}

#pragma mark > String Lowercase/Uppercase

+ (nullable NSString *)lowercaseStringWithString:(NSString *)string range:(NSRange)range {
    return [self changeCaseStringWithString:string range:range isUppercase:NO];
}

+ (nullable NSString *)uppercaseStringWithString:(NSString *)string range:(NSRange)range {
    return [self changeCaseStringWithString:string range:range isUppercase:YES];
}

+ (nullable NSString *)changeCaseStringWithString:(NSString *)string range:(NSRange)range isUppercase:(BOOL)isUppercase {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (range.location > string.length) {
        return nil;
    }
    
    NSRange effectiveRange;
    
    // Note: Don't use location + length <= string.length, because if length is too large (e.g. NSUIntegerMax), location + length will become smaller (upper overflow)
    if (range.length <= string.length - range.location) {
        effectiveRange = range;
    }
    else {
        effectiveRange = NSMakeRange(range.location, string.length - range.location);
    }
    
    NSString *effectedString = [string substringWithRange:effectiveRange];
    NSString *stringToReturn = [string stringByReplacingCharactersInRange:effectiveRange withString:isUppercase ? [effectedString uppercaseString] : [effectedString lowercaseString]];
    
    return stringToReturn;
}

#pragma mark > String Char

+ (nullable NSString *)stringCharWithString:(NSString *)string atIndex:(NSUInteger)index {
    if (![string isKindOfClass:[NSString class]] || string.length == 0) {
        return nil;
    }
    
    if (index >= string.length) {
        return nil;
    }
    
    NSMutableArray<NSString *> *stringChars = [NSMutableArray array];
    
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        [stringChars addObject:substring];
    }];
    
    if (index >= stringChars.count) {
        return nil;
    }
    
    return stringChars[index];
}

+ (BOOL)isLetterWithString:(NSString *)string atIndex:(NSUInteger)index {
    NSString *aChar = [self stringCharWithString:string atIndex:index];
    
    if (aChar.length != 1) {
        return NO;
    }
    
    unichar unicode = [aChar characterAtIndex:0];
    if (('A' <= unicode && unicode <= 'Z') || ('a' <= unicode && unicode <= 'z')) {
        return YES;
    }

    return NO;
}

+ (BOOL)isUpperCaseLetterWithString:(NSString *)string atIndex:(NSUInteger)index {
    NSString *aChar = [self stringCharWithString:string atIndex:index];
    
    if (aChar.length != 1) {
        return NO;
    }
    
    unichar unicode = [aChar characterAtIndex:0];
    if (('A' <= unicode && unicode <= 'Z')) {
        return YES;
    }

    return NO;
}

+ (BOOL)isLowerCaseLetterWithString:(NSString *)string atIndex:(NSUInteger)index {
    NSString *aChar = [self stringCharWithString:string atIndex:index];
    
    if (aChar.length != 1) {
        return NO;
    }
    
    unichar unicode = [aChar characterAtIndex:0];
    if (('a' <= unicode && unicode <= 'z')) {
        return YES;
    }

    return NO;
}

#pragma mark - Handle String As Url/Url-like

+ (nullable NSDictionary<NSString *, NSString *> *)keyValuePairsWithString:(NSString *)string usingConnector:(NSString *)connector usingSeparator:(NSString *)separator {
    
    if (![string isKindOfClass:[NSString class]] ||
        ![connector isKindOfClass:[NSString class]] ||
        ![separator isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSMutableDictionary *keyValuePairsM = [NSMutableDictionary dictionary];
    
    NSArray *keyValuePairs = [string componentsSeparatedByString:separator];
    for (NSString *keyValue in keyValuePairs) {
        NSArray *pairComponents = [keyValue componentsSeparatedByString:connector];
        
        NSString *theKey = [pairComponents firstObject];
        NSString *theValue = [pairComponents lastObject];
        
        if (theKey && theValue) {
            keyValuePairsM[theKey] = theValue;
        }
    }
    
    return keyValuePairsM;
}

+ (nullable NSDictionary *)keyValuePairsWithUrlString:(NSString *)urlString {
    if (![urlString isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSRange range = [urlString rangeOfString:@"?"];
    if (range.location == NSNotFound || range.length == 0 || range.location == urlString.length - 1) {
        return nil;
    }
    
    NSString *patternOfFragment = @"#([^#]+)$";
    NSRange rangeOfFragment = [urlString rangeOfString:patternOfFragment options:NSRegularExpressionSearch];
    if (rangeOfFragment.location != NSNotFound && rangeOfFragment.length) {
        // Note: ommit the fragment (#fragment) if needed
        urlString = [urlString stringByReplacingCharactersInRange:rangeOfFragment withString:@""];
    }
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?:\\?|&)([^=&]*)=([^&]*)" options:kNilOptions error:&error];
    if (error) {
        return nil;
    }
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    [regex enumerateMatchesInString:urlString options:kNilOptions range:NSMakeRange(0, urlString.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        
        NSTextCheckingResult *matchOfQueryItems = result;
        
        if (matchOfQueryItems.numberOfRanges == 3) {
            NSRange keyRange = [matchOfQueryItems rangeAtIndex:1];
            NSRange valueRange = [matchOfQueryItems rangeAtIndex:2];
            
            NSString *key = [self substringWithString:urlString range:keyRange byVisualization:NO];
            NSString *value = [self substringWithString:urlString range:valueRange byVisualization:NO];
            
            if (key && value) {
                dictM[key] = value;
            }
        }
    }];
    
    return dictM;
}

#pragma mark > URL Encode/Decode

+ (NSString *)URLEscapedStringWithString:(nullable NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@?/"; // Note: RFC 3986 - Section 3.4 does not include "?" or "/"
    static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
    
    // FIXME: https://github.com/AFNetworking/AFNetworking/pull/3028
    // return [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
    static NSUInteger const batchSize = 50;
    
    NSUInteger index = 0;
    NSMutableString *escapedString = @"".mutableCopy;
    
    while (index < string.length) {
        NSUInteger length = MIN(string.length - index, batchSize);
        NSRange range = NSMakeRange(index, length);
        
        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [string rangeOfComposedCharacterSequencesForRange:range];
        
        NSString *substring = [string substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escapedString appendString:encoded];
        
        index += range.length;
    }
    
    return escapedString;
}

+ (NSString *)URLUnescapedStringWithString:(nullable NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSString *decodedString;
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending) {
        // iOS 9 or later
        decodedString = CFBridgingRelease(
                CFURLCreateStringByReplacingPercentEscapes(
                    kCFAllocatorDefault,
                    (__bridge CFStringRef)string,
                    CFSTR("")
                    )
                );
    }
    else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        decodedString = CFBridgingRelease(
                CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                    kCFAllocatorDefault,
                    (__bridge CFStringRef)string,
                    CFSTR(""),
                    kCFStringEncodingUTF8
                    )
                );
#pragma GCC diagnostic pop
    }
    
    return decodedString;
}

#pragma mark - Handle String As HTML

+ (nullable NSString *)stripTagsWithHTMLString:(NSString *)htmlString {
    if (![htmlString isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSMutableString *strippedString = [NSMutableString stringWithCapacity:[htmlString length]];
    
    NSScanner *scanner = [NSScanner scannerWithString:htmlString];
    scanner.charactersToBeSkipped = nil;
    NSString *tempText = nil;
    
    while (![scanner isAtEnd]) {
        [scanner scanUpToString:@"<" intoString:&tempText];
        
        if (tempText != nil)
            [strippedString appendString:tempText];
        
        [scanner scanUpToString:@">" intoString:NULL];
        
        if (![scanner isAtEnd])
            [scanner setScanLocation:[scanner scanLocation] + 1];
        
        tempText = nil;
    }
    
    return strippedString;
}

#pragma mark - Handle String As Path

+ (nullable NSString *)pathWithPathString:(NSString *)pathString relativeToPath:(NSString *)anchorPath {
    if (![pathString isKindOfClass:[NSString class]] || ![anchorPath isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSArray *pathComponents = [pathString pathComponents];
    NSArray *anchorComponents = [anchorPath pathComponents];
    
    NSInteger componentsInCommon = MIN([pathComponents count], [anchorComponents count]);
    for (NSInteger i = 0, n = componentsInCommon; i < n; i++) {
        if (![[pathComponents objectAtIndex:i] isEqualToString:[anchorComponents objectAtIndex:i]]) {
            componentsInCommon = i;
            break;
        }
    }
    
    NSUInteger numberOfParentComponents = [anchorComponents count] - componentsInCommon;
    NSUInteger numberOfPathComponents = [pathComponents count] - componentsInCommon;
    
    NSMutableArray *relativeComponents = [NSMutableArray arrayWithCapacity:numberOfParentComponents + numberOfPathComponents];
    for (NSInteger i = 0; i < numberOfParentComponents; i++) {
        [relativeComponents addObject:@".."];
    }
    [relativeComponents addObjectsFromArray:[pathComponents subarrayWithRange:NSMakeRange(componentsInCommon, numberOfPathComponents)]];
    
    return [NSString pathWithComponents:relativeComponents];
}

+ (nullable NSString *)pathWithSubpathInCacheFolder:(NSString *)subpath {
    return [self pathWithSubpath:subpath inDirectory:NSCachesDirectory];
}

+ (nullable NSString *)pathWithSubpathInDocumentFolder:(NSString *)subpath {
    return [self pathWithSubpath:subpath inDirectory:NSDocumentDirectory];
}

+ (nullable NSString *)pathWithSubpathInLibraryFolder:(NSString *)subpath {
    return [self pathWithSubpath:subpath inDirectory:NSLibraryDirectory];
}

+ (nullable NSString *)pathWithSubpath:(NSString *)subpath inDirectory:(NSSearchPathDirectory)systemDirectory {
    if (![subpath isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    static NSMutableDictionary *sDict = nil;
    
    if (!sDict) {
        sDict = [NSMutableDictionary dictionary];
    }
    
    NSNumber *key = @(systemDirectory);
    if (!sDict[key]) {
        NSString *directoryPath = [NSSearchPathForDirectoriesInDomains(systemDirectory, NSUserDomainMask, YES) firstObject];
        sDict[key] = directoryPath;
    }
    
    NSString *folderPath = [sDict[key] stringByAppendingPathComponent:subpath];
    
    return folderPath;
}

#pragma mark - Handle String As Number

+ (nullable NSString *)removeTrailZerosWithNumberString:(NSString *)numberString {
    if (![numberString isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if ([numberString rangeOfString:@"."].location == NSNotFound) {
        return numberString;
    }
    
    NSRange range = NSMakeRange(0, 0);
    range = [numberString rangeOfString:@"0*$" options:NSRegularExpressionSearch];
    if (range.location != NSNotFound && range.length) {
        numberString = [numberString stringByReplacingCharactersInRange:range withString:@""];
    }
    
    range = [numberString rangeOfString:@"\\.$" options:NSRegularExpressionSearch];
    if (range.location != NSNotFound && range.length) {
        numberString = [numberString stringByReplacingCharactersInRange:range withString:@""];
    }
    
    return numberString;
}

#pragma mark - Cryption

#pragma mark > MD5

+ (nullable NSString *)MD5WithString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (string.length) {
        const char *cStr = [string UTF8String];
        unsigned char result[16];
        CC_MD5(cStr, (unsigned int)strlen(cStr), result);
        return [NSString stringWithFormat:
                @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                result[0], result[1], result[2], result[3],
                result[4], result[5], result[6], result[7],
                result[8], result[9], result[10], result[11],
                result[12], result[13], result[14], result[15]
                ];
    }
    else {
        return nil;
    }
}

#pragma mark > Base64 Encode/Decode

+ (nullable NSString *)base64EncodedStringWithString:(NSString *)string {
    // Note: kNilOptions for one line base64 string
    return [self base64EncodedStringWithString:string options:kNilOptions];
}

+ (nullable NSString *)base64EncodedStringWithString:(NSString *)string options:(NSDataBase64EncodingOptions)options {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSData *data = [[string dataUsingEncoding:NSUTF8StringEncoding] base64EncodedDataWithOptions:options];
    if (!data) {
        return nil;
    }
    
    NSString *encodedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return encodedString;
}

+ (nullable NSString *)base64DecodedStringWithString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    if (!data) {
        return nil;
    }
    
    NSString *decodedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return decodedString;
}

#pragma mark - Unit String

+ (NSString *)prettySizeWithMemoryBytes:(unsigned long long)memoryBytes {
    NSString *sizeString = [NSByteCountFormatter stringFromByteCount:memoryBytes countStyle:NSByteCountFormatterCountStyleBinary];
    return sizeString;
}

+ (NSString *)prettySizeWithFileBytes:(unsigned long long)fileBytes {
    NSString *sizeString = [NSByteCountFormatter stringFromByteCount:fileBytes countStyle:NSByteCountFormatterCountStyleDecimal];
    return sizeString;
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
