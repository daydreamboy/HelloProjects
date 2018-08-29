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
    
    CGSize textSize = [string sizeWithAttributes:@{ NSFontAttributeName: font }];
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}

+ (CGSize)textSizeWithSingleLineString:(NSString *)string attributes:(NSDictionary *)attributes NS_AVAILABLE_IOS(7_0) {
    if (![string isKindOfClass:[NSString class]] || !string.length || ![attributes isKindOfClass:[NSDictionary class]]) {
        return CGSizeZero;
    }
    
    CGSize textSize = [string sizeWithAttributes:attributes];
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

#pragma mark - Handle String As Specific Strings

#pragma mark > String as CGRect/UIEdgeInsets/UIColor

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
+ (NSString *)valueWithUrlString:(NSString *)string forKey:(NSString *)key usingConnector:(NSString *)connector usingSeparator:(NSString *)separator {
    
    NSString *searchedKey = [NSString stringWithFormat:@"%@%@", key, connector];
    
    NSUInteger locationOfSearchedKey = [string rangeOfString:searchedKey options:NSBackwardsSearch].location;
    if (locationOfSearchedKey == NSNotFound) {
        return nil;
    }
    else {
        NSUInteger locationOfSeparator = [string rangeOfString:separator options:0 range:NSMakeRange(locationOfSearchedKey, string.length - locationOfSearchedKey)].location;
        if (locationOfSeparator == NSNotFound) {
            locationOfSeparator = string.length;
        }
        
        NSUInteger start = locationOfSearchedKey + searchedKey.length;
        NSUInteger end = locationOfSeparator;
        NSString *value = [string substringWithRange:NSMakeRange(start, end - start)];
        
        return value;
    }
}

/*!
 *  Get the 'value' string for the given 'key' string, e.g. "http://m.cp.360.cn/news/mobile/150410515.html?act=1&reffer=ios&titleRight=share&empty="
 *
 *  @param key the 'key' in string as "key1=value1&key2=value2&..."
 *
 *  @return the 'value' string
 */
+ (NSString *)valueWithUrlString:(NSString *)string forKey:(NSString *)key {
    
    NSString *separator = @"&";
    NSString *connector = @"=";
    
    return [self valueWithUrlString:string forKey:key usingConnector:connector usingSeparator:separator];
}

+ (NSDictionary *)keyValuePairsWithUrlString:(NSString *)urlString {
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    if (URL) {
        // Note: not URL.parameterString
        // For example, in the URL file:///path/to/file;foo, the parameter string is foo.
        NSArray *pairs = [URL.query componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in pairs) {
            NSArray *keyValue = [keyValuePair componentsSeparatedByString:@"="];
            
            NSString *key = [keyValue firstObject];
            NSString *value = [keyValue lastObject];
            
            if (key && value) {
                dictM[key] = value;
            }
        }
    }
    
    return [dictM copy];
}

#pragma mark - Handle String As Plain

#pragma mark > Substring String

+ (NSString *)substringWithString:(NSString *)string atLocation:(NSUInteger)location length:(NSUInteger)length {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (location < string.length) {
        if (length < string.length - location) {
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

+ (NSString *)substringWithString:(NSString *)string range:(NSRange)range {
    return [self substringWithString:string atLocation:range.location length:range.length];
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

#pragma mark > URL Encode/Decode

+ (NSString *)URLEscapeStringWithString:(nullable NSString *)string {
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

+ (NSString *)URLUnescapeStringWithString:(nullable NSString *)string {
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

+ (nullable NSString *)formattedStringWithString:(NSString *)string format:(NSString *)format arguments:(NSArray *)arguments {
    if (![string isKindOfClass:[NSString class]] || ![format isKindOfClass:[NSString class]] || ![arguments isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    if (arguments.count > 10) {
#if DEBUG
        @throw [NSException exceptionWithName:NSRangeException reason:@"Maximum of 10 arguments allowed" userInfo:@{@"collection": arguments}];
#else
        return nil;
#end
    }
    NSArray *args = [arguments arrayByAddingObjectsFromArray:@[@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X"]];
    return [NSString stringWithFormat:format, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]];
}

#pragma mark - Handle String As JSON

#pragma mark > JSON String to id/NSArray/NSDictionary

+ (nullable id)JSONObjectWithString:(nullable NSString *)string NS_AVAILABLE_IOS(5_0) {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (!jsonData) {
        return nil;
    }
    
    @try {
        NSError *error;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (!jsonObject) {
            NSLog(@"[%@] error parsing JSON: %@", NSStringFromClass([self class]), error);
        }
        return jsonObject;
    }
    @catch (NSException *exception) {
        NSLog(@"[%@] an exception occured:\n%@", NSStringFromClass([self class]), exception);
    }
    
    return nil;
}

+ (nullable NSArray *)JSONArrayWithString:(nullable NSString *)string NS_AVAILABLE_IOS(5_0) {
    NSArray *jsonArray = [self JSONObjectWithString:string];
    if ([jsonArray isKindOfClass:[NSArray class]]) {
        return jsonArray;
    }
    else {
        return nil;
    }
}

+ (nullable NSDictionary *)JSONDictWithString:(nullable NSString *)string NS_AVAILABLE_IOS(5_0) {
    NSDictionary *jsonDict = [self JSONObjectWithString:string];
    if ([jsonDict isKindOfClass:[NSDictionary class]]) {
        return jsonDict;
    }
    else {
        return nil;
    }
}

#pragma mark - Cryption

+ (NSString *)MD5WithString:(NSString *)string {
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

@end
