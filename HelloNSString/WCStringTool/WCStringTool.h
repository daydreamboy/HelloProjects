//
//  WCStringTool.h
//  HelloNSString
//
//  Created by wesley_chen on 2018/5/30.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCStringTool : NSObject

#pragma mark - Handle String As Text In UILabel

/**
 Calculate text size for single line (numberOfLines = 1)

 @param string the text
 @param font the font of text
 @return the text size
 */
+ (CGSize)textSizeWithSingleLineString:(NSString *)string font:(UIFont *)font NS_AVAILABLE_IOS(7_0);

/**
 Calculate text size for single line (numberOfLines = 1) with attributes
 
 @param string the text
 @param attributes the attributes dictionary
 @return the text size
 */
+ (CGSize)textSizeWithSingleLineString:(NSString *)string attributes:(NSDictionary *)attributes NS_AVAILABLE_IOS(7_0);

/**
 Calculate text size for multiple lines (numberOfLines = 0)

 @param string the text
 @param width the fixed width
 @param font the font of text
 @param lineBreakMode the lineBreakMode. NSLineBreakByClipping/NSLineBreakByTruncatingHead/NSLineBreakByTruncatingTail/NSLineBreakByTruncatingMiddle will be treated as NSLineBreakByCharWrapping
 @param widthToFit If NO, the width of calculated text size always is the input width. If YES, the width of calculated text size as it.
 @return the text size
 */
+ (CGSize)textSizeWithMultipleLineString:(NSString *)string width:(CGFloat)width font:(UIFont *)font mode:(NSLineBreakMode)lineBreakMode widthToFit:(BOOL)widthToFit NS_AVAILABLE_IOS(8_0);

/**
 Calculate text size for multiple lines (numberOfLines = 0) with attributes

 @param string the text
 @param width the fixed width
 @param attributes the attributes dictionary
 @param widthToFit If NO, the width of calculated text size always is the input width. If YES, the width of calculated text size as it.
 @return the text size
 */
+ (CGSize)textSizeWithMultipleLineString:(NSString *)string width:(CGFloat)width attributes:(NSDictionary *)attributes widthToFit:(BOOL)widthToFit NS_AVAILABLE_IOS(8_0);

/**
 Calculate text size for fixed lines (numberOfLines > 0)

 @param string the text
 @param width the fixed width
 @param font the font of text
 @param numberOfLines the number of lines. numberOfLines <= 0, will treat as multiple lines (numberOfLines = 0)
 @param lineBreakMode the lineBreakMode. NSLineBreakByClipping/NSLineBreakByTruncatingHead/NSLineBreakByTruncatingTail/NSLineBreakByTruncatingMiddle will be treated as NSLineBreakByCharWrapping
 @param widthToFit If NO, the width of calculated text size always is the input width. If YES, the width of calculated text size as it.
 @return the text size
 */
+ (CGSize)textSizeWithFixedLineString:(NSString *)string width:(CGFloat)width font:(UIFont *)font numberOfLines:(NSUInteger)numberOfLines mode:(NSLineBreakMode)lineBreakMode widthToFit:(BOOL)widthToFit NS_AVAILABLE_IOS(8_0);

#pragma mark > Others

/**
 Get a hyphenated string which can rendered in UILabel and use @"en_US" as locale

 @param string the plain string
 @param error the error. If the locale not support hyphenation, the error is not nil and return nil.
 @return the hyphenated string which has invisible hyphenation (unichar 0x00AD)
 */
+ (NSString *)softHyphenatedStringWithString:(NSString *)string error:(out NSError * _Nullable * _Nullable)error;

/**
 Get a hyphenated string which can rendered in UILabel

 @param string the plain string
 @param locale the NSLocale
 @param error the error. If the locale not support hyphenation, the error is not nil and return nil.
 @return the hyphenated string which has invisible hyphenation (unichar 0x00AD)
 
 @see https://stackoverflow.com/a/19856111
 */
+ (NSString *)softHyphenatedStringWithString:(NSString *)string locale:(NSLocale *)locale error:(out NSError * _Nullable * _Nullable)error;

#pragma mark - NSStringFromXXX

+ (NSString *)stringFromUIGestureRecognizerState:(UIGestureRecognizerState)state;

#pragma mark - Handle String As Specific Strings

#pragma mark > String as CGRect/UIEdgeInsets/UIColor

/**
 Safe convert NSString to CGRect
 
 @param string the NSString represents CGRect
 @return the CGRect. If the NSString is malformed, return the CGRectNull
 @warning not allow 0.0, instead of just using 0.
 */
+ (CGRect)rectFromString:(NSString *)string;

/**
 Safe convert NSString to UIEdgeInsets, use value.UIEdgeInsets to get UIEdgeInsets
 
 @param string the NSString represents UIEdgeInsets
 @return the NSValue to wrap UIEdgeInsets. Return nil if string is invalid.
 @warning not allow 0.0, instead of just using 0.
 */
+ (NSValue *)edgeInsetsValueFromString:(NSString *)string;

/**
 Convert hex string to UIColor
 
 @param string the hex string with foramt @"#RRGGBB" or @"#RRGGBBAA"
 @return the UIColor object. return nil if string is not valid.
 */
+ (UIColor *)colorFromHexString:(NSString *)string;

#pragma mark - Handle String As Url

/// get value for key like `key1=value1&key2=value2`
+ (NSString *)valueWithUrlString:(NSString *)string forKey:(NSString *)key usingConnector:(NSString *)connector usingSeparator:(NSString *)separator;
+ (NSString *)valueWithUrlString:(NSString *)string forKey:(NSString *)key;

/**
 Get key/value from url string like `http://xxx?key1=value1&key2=value2`

 @param string the url string, e.g. xxx://....
 @return return empty dictionary if the url string is invalid.
 */
+ (NSDictionary *)keyValuePairsWithUrlString:(NSString *)string;

#pragma mark - Handle String As Plain

#pragma mark > Substring String

/**
 Safe get substring with the location and the length

 @param string the whole string
 @param location the start location
 @param length the length of substring
 @return the substring. Return nil if the locatio or length is invalid, e.g. location out of the string index [0..string.length]
 */
+ (NSString *)substringWithString:(NSString *)string atLocation:(NSUInteger)location length:(NSUInteger)length;

/**
 Safe get substring with the length which started at the location

 @param string the whole string
 @param range the range
 @return the substring. Return nil if the range is invalid.
 @discussion this method will internally call +[WCStringTool substringWithString:atLocation:length:]
 */
+ (NSString *)substringWithString:(NSString *)string range:(NSRange)range;

/**
 Get the first substring which matches the characterSet

 @param string the whole string
 @param characterSet the character set to match
 @return the substring
 @code
 // Input
 NSString *originalString = @"*_?.幸运号This's my string：01234adbc5678";
 
 NSString *numberString = [originalString firstSubstringInCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
 NSLog(@"%@", numberString); // 01234
 @endcode
 */
+ (NSString *)firstSubstringWithString:(NSString *)string substringInCharacterSet:(NSCharacterSet *)characterSet;

#pragma mark > Split String

+ (NSArray<NSString *> *)componentsWithString:(NSString *)string delimeters:(NSArray<NSString *> *)delimeters;

#pragma mark > URL Encode/Decode

/**
 Get a URL encoded string

 @param string the string
 @return the URL encoded string
 
 @see AFPercentEscapedStringFromString function, https://github.com/AFNetworking/AFNetworking/blob/master/AFNetworking/AFURLRequestSerialization.m#L47
 */
+ (NSString *)URLEscapeStringWithString:(nullable NSString *)string;

/**
 Get a URL decoded string with UTF-8 encoding

 @param string the string
 @return the URL decoded string
 
 @see http://isobar.logdown.com/posts/211030-url-encode-decode-in-ios
 */
+ (NSString *)URLUnescapeStringWithString:(nullable NSString *)string;

#pragma mark > unichar

/**
 Convert an unichar to NSString
 
 @param unichar the unichar
 @return the NSString
 
 @see https://stackoverflow.com/a/1354413
 */
+ (NSString *)stringWithUnichar:(unichar)unichar;

#pragma mark > String Validation

/**
 Check string if contains an ascend or descend character sequence with length

 @param string the string to check
 @param length the length of ascend or descend character sequence. If length <= 1 or string.length <= 1, always return NO
 @return YES if the string has ascend or descend character sequence as least with length (>= `length`)
 */
+ (BOOL)checkStringWithString:(NSString *)string charactersOrderByAscendOrDescendWithLength:(NSInteger)length;

/**
 Check string if composed by only one character

 @param string the string to check
 @return YES if the string is composed by only one character
 */
+ (BOOL)checkStringUniformedBySingleCharacterWithString:(NSString *)string;

/**
 Check string if numeric, e.g. @"000", @"010", @"1"
 
 @param string the string to check
 @return NO, if empty string @"" or nil, or not a numeric string
 */
+ (BOOL)checkStringComposedOfNumbersWithString:(NSString *)string;

/**
 Check string only if contains a-z and A-Z, e.g. @"aaa", @"ABC", @"abcABC"

 @param string the string to check
 @return NO, if empty string @"" or nil, or contains non-letter characters
 */
+ (BOOL)checkStringComposedOfLettersWithString:(NSString *)string;
+ (BOOL)checkStringComposedOfLettersLowercaseWithString:(NSString *)string;
+ (BOOL)checkStringComposedOfLettersUppercaseWithString:(NSString *)string;

/**
 Check string if chinese characters, e.g. @"中文", @"中国"

 @param string the string to check
 @return NO, if empty string @"" or nil, or contains non-chinese characters
 @see http://www.ssec.wisc.edu/~tomw/java/unicode.html#x4E00 (CJK Unified Ideographs)
 */
+ (BOOL)checkStringComposedOfChineseCharactersWithString:(NSString *)string;

/**
 Check string if non-negative integer value, e.g. @"0", @"1", @"10"

 @param string the string to check
 @return If YES, the string is integer value and NUMBER(string) >= 0.
 @warning <br/> 1. positive sign (+) is NOT allowed <br/> 2. leading zeros are NOT allowed, e.g. @"00", @"010"
 @discussion same as checkStringAsNaturalIntegerWithString
 */
+ (BOOL)checkStringAsNoneNegativeIntegerWithString:(NSString *)string;

/**
 Check string if non-negative integer value, e.g. @"0", @"1", @"10".

 @param string the string to check
 @return If YES, the string is integer value and NUMBER(string) >= 0.
 @see http://stackoverflow.com/questions/6644004/how-to-check-if-nsstring-is-contains-a-numeric-value
 */
+ (BOOL)checkStringAsNaturalIntegerWithString:(NSString *)string;

/**
 Check string if positive integer value, e.g. @"1", @"2"

 @param string the string to check
 @return If YES, the string is integer value and NUMBER(string) > 0.
 */
+ (BOOL)checkStringAsPositiveIntegerWithString:(NSString *)string;

/**
 Check string if alphabetical and numerical
 
 @param string the string to check
 @return YES if string contains only letters (uppercase or lowercase) and numbers
 @see http://stackoverflow.com/questions/7546235/check-if-nsstring-contains-alphanumeric-underscore-characters-only
 */
+ (BOOL)checkStringAsAlphanumericWithString:(NSString *)string;

#pragma mark - Handle String As JSON

#pragma mark > JSON String to id/NSArray/NSDictionary

/**
 Convert the JSON formatted string to NSArray or NSDictionary object

 @param string the JSON formatted string
 @return If the string is not JSON formatted, return nil.
 */
+ (nullable id)JSONObjectWithString:(nullable NSString *)string NS_AVAILABLE_IOS(5_0);

/**
 Convert the JSON formatted string to NSArray object

 @param string the JSON formatted string
 @return If the string is not JSON formatted or a JSON array object, return nil.
 */
+ (nullable NSArray *)JSONArrayWithString:(nullable NSString *)string NS_AVAILABLE_IOS(5_0);

/**
 Convert the JSON formatted string to NSDictionary object

 @param string the JSON formatted string
 @return If the string is not JSON formatted or a JSON dictionary object, return nil.
 */
+ (nullable NSDictionary *)JSONDictWithString:(nullable NSString *)string NS_AVAILABLE_IOS(5_0);

#pragma mark - Encryption

+ (NSString *)MD5WithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
