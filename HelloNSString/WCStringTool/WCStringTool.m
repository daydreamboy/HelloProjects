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

#pragma mark > Others

+ (NSString *)softHyphenatedStringWithString:(NSString *)string error:(out NSError **)error {
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    
    return [self softHyphenatedStringWithString:string locale:locale error:error];
}

+ (NSString *)softHyphenatedStringWithString:(NSString *)string locale:(NSLocale *)locale error:(out NSError **)error {
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

#pragma mark - Handle String As Url

/*!
 *  Get the 'value' string for the given 'key' string, e.g. "http://m.cp.360.cn/news/mobile/150410515.html?act=1&reffer=ios&titleRight=share&empty="
 *
 *  @param key       the 'key' string
 *  @param connector the sign, such as =, : and so on
 *  @param separator the sign, such as & and so on
 *
 *  @return the 'value' string
 */
+ (nullable NSString *)valueWithUrlString:(NSString *)string forKey:(NSString *)key usingConnector:(NSString *)connector usingSeparator:(NSString *)separator {
    
    if (![string isKindOfClass:[NSString class]] ||
        ![key isKindOfClass:[NSString class]] ||
        ![separator isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSRange rangeOfQuestionMark = [string rangeOfString:@"?" options:kNilOptions];
    if (rangeOfQuestionMark.location == NSNotFound || rangeOfQuestionMark.length == 0) {
        return nil;
    }
    
    NSString *queryString;
    if (rangeOfQuestionMark.location + 1 < string.length) {
        queryString = [string substringFromIndex:rangeOfQuestionMark.location + 1];
    }
    
    if (!queryString.length) {
        return nil;
    }
    
    NSArray *keyValuePairs = [queryString componentsSeparatedByString:separator];
    for (NSString *keyValue in keyValuePairs) {
        NSArray *pairComponents = [keyValue componentsSeparatedByString:connector];
        
        NSString *theKey = [pairComponents firstObject];
        NSString *theValue = [pairComponents lastObject];
        if ([theKey isEqualToString:key]) {
            return theValue;
        }
    }
    
    return nil;
}

/*!
 *  Get the 'value' string for the given 'key' string, e.g. "http://m.cp.360.cn/news/mobile/150410515.html?act=1&reffer=ios&titleRight=share&empty="
 *
 *  @param key the 'key' in string as "key1=value1&key2=value2&..."
 *
 *  @return the 'value' string
 */
+ (nullable NSString *)valueWithUrlString:(NSString *)string forKey:(NSString *)key {
    
    NSString *separator = @"&";
    NSString *connector = @"=";
    
    return [self valueWithUrlString:string forKey:key usingConnector:connector usingSeparator:separator];
}

+ (NSDictionary *)keyValuePairsWithUrlString:(NSString *)urlString  {
    if (![urlString isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSRange range = [urlString rangeOfString:@"?"];
    if (range.location == NSNotFound || range.length == 0 || range.location == urlString.length - 1) {
        return nil;
    }
    
    NSString *queryString = [urlString substringFromIndex:range.location + 1];
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
    
    for (NSString *keyValuePair in queryComponents) {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        NSString *key = [pairComponents firstObject];
        NSString *value = [pairComponents lastObject];
        
        if (key && value) {
            dictM[key] = value;
        }
    }
    
    return dictM;
}

#pragma mark - Handle String As Plain

#pragma mark > Substring String

+ (nullable NSString *)substringWithString:(NSString *)string atLocation:(NSUInteger)location length:(NSUInteger)length {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (location < string.length) {
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

+ (nullable NSString *)substringWithString:(NSString *)string range:(NSRange)range {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (range.location == NSNotFound) {
        return nil;
    }
    
    if (range.location < string.length) {
        if (range.location + range.length <= string.length) {
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

+ (NSArray<NSString *> *)componentsWithString:(NSString *)string delimeters:(NSArray<NSString *> *)delimeters {
    NSMutableArray *strings = [NSMutableArray arrayWithObject:string];
    NSArray *components = [self splitStringWithComponents:strings delimeters:[delimeters mutableCopy]];
    return components;
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
        NSString *substring = [WCStringTool substringWithString:string range:extractRange];
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
            
            NSString *substring = [WCStringTool substringWithString:string range:extractRange];
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

#pragma mark > URL Encode/Decode

+ (NSString *)URLEscapedStringWithString:(nullable NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
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
    
    if (arguments.count > 10) {
#if DEBUG
        @throw [NSException exceptionWithName:NSRangeException reason:@"Maximum of 10 arguments allowed" userInfo:@{@"collection": arguments}];
#else
        return nil;
#endif
    }
    NSArray *args = [arguments arrayByAddingObjectsFromArray:@[@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X"]];
    return [NSString stringWithFormat:format, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]];
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

#pragma mark > String Modification

+ (nullable NSString *)replaceCharactersInRangesWithString:(NSString *)string ranges:(NSArray<NSValue *> *)ranges replacementStrings:(NSArray<NSString *> *)replacementStrings {
    if (![string isKindOfClass:[NSString class]] ||
        ![ranges isKindOfClass:[NSArray class]] ||
        ![replacementStrings isKindOfClass:[NSArray class]] ||
        ranges.count != replacementStrings.count) {
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
    
    NSMutableArray<NSString *> *replacementStringsM = [replacementStrings mutableCopy];
    
    NSMutableString *stringM = [NSMutableString stringWithCapacity:string.length];
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
        NSString *character = substring;
        NSRange rangeOfCharacter = substringRange;
        
        NSInteger index = checkChacterInRanges(rangeOfCharacter);
        if (index != NSNotFound) {
            NSValue *rangeValue = sortedRanges[index];
            NSInteger indexOfReplacementString = [ranges indexOfObject:rangeValue];
            if (indexOfReplacementString != NSNotFound) {
                NSString *stringToInsert = replacementStringsM[indexOfReplacementString];
                
                if (stringToInsert.length) {
                    [stringM appendString:stringToInsert];
                    replacementStringsM[indexOfReplacementString] = @"";
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

+ (nullable NSString *)unescapedUnicodeStringWithString:(NSString *)string {
    
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    // Bug: The escaped string must use \u not \U, CFStringTransform only treats \u
    NSString *modifiedString = [string stringByReplacingOccurrencesOfString:@"\\U" withString:@"\\u"];
    // Note: remove left or right redundant `"` if needed
    modifiedString = [modifiedString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
    
    NSMutableString *unescapedString = [modifiedString mutableCopy];
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)unescapedString, NULL, transform, YES);
    
    return [unescapedString copy];
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
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSString *encodedString;
    
    if ([self respondsToSelector:@selector(base64EncodedDataWithOptions:)]) {
        // iOS >= `7.0`
        // one line base64 string
        NSData *data = [[string dataUsingEncoding:NSUTF8StringEncoding] base64EncodedDataWithOptions:0];
        encodedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        // one line base64 string
        encodedString = [[string dataUsingEncoding:NSUTF8StringEncoding] base64Encoding];
#pragma GCC diagnostic pop
    }
    
    return encodedString;
}

+ (nullable NSString *)base64DecodedStringWithString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    // iOS >= `7.0`
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *decodedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return decodedString;
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
