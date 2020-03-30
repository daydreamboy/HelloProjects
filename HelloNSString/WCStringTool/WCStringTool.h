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

typedef NS_ENUM(NSUInteger, WCStringTruncatingStyle) {
    WCStringTruncatingStyleNone,
    WCStringTruncatingStyleHead,
    WCStringTruncatingStyleMiddle,
    WCStringTruncatingStyleTrail,
};

typedef NS_ENUM(NSUInteger, WCStringSplitInComponentsMode) {
    WCStringSplitInComponentsModeWithoutDelimiter,
    WCStringSplitInComponentsModeIncludeDelimiter,
};

@interface WCStringTool : NSObject

#pragma mark - Handle String As Text In UILabel

/**
 Calculate text size for single line (numberOfLines = 1)

 @param string the text expected a single line which should have no line wrap '\\n' or '\\r'
 @param font the font of text
 @return the text size
 */
+ (CGSize)textSizeWithSingleLineString:(NSString *)string font:(UIFont *)font NS_AVAILABLE_IOS(7_0);

/**
 Calculate text size for single line (numberOfLines = 1) with attributes
 
 @param string the text expected a single line which should have no line wrap '\\n' or '\\r'
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
 @param maximumNumberOfLines the maximum number of lines. maximumNumberOfLines <= 0, will treat as multiple lines (maximumNumberOfLines = 0)
 @param lineBreakMode the lineBreakMode. NSLineBreakByClipping/NSLineBreakByTruncatingHead/NSLineBreakByTruncatingTail/NSLineBreakByTruncatingMiddle will be treated as NSLineBreakByCharWrapping
 @param widthToFit If NO, the width of calculated text size always is the input width. If YES, the width of calculated text size as it.
 @return the text size. If the actual lines is lower than the numberOfLines, the text size's height is the actual lines height.
 */
+ (CGSize)textSizeWithFixedLineString:(NSString *)string width:(CGFloat)width font:(UIFont *)font maximumNumberOfLines:(NSUInteger)maximumNumberOfLines mode:(NSLineBreakMode)lineBreakMode widthToFit:(BOOL)widthToFit NS_AVAILABLE_IOS(8_0);

#pragma mark > Others

/**
 Get a hyphenated string which can rendered in UILabel and use @"en_US" as locale

 @param string the plain string
 @param error the error. If the locale not support hyphenation, the error is not nil and return nil.
 @return the hyphenated string which has invisible hyphenation (unichar 0x00AD)
 */
+ (nullable NSString *)softHyphenatedStringWithString:(NSString *)string error:(out NSError * _Nullable * _Nullable)error;

/**
 Get a hyphenated string which can rendered in UILabel

 @param string the plain string
 @param locale the NSLocale
 @param error the error. If the locale not support hyphenation, the error is not nil and return nil.
 @return the hyphenated string which has invisible hyphenation (unichar 0x00AD)
 
 @see https://stackoverflow.com/a/19856111
 */
+ (nullable NSString *)softHyphenatedStringWithString:(NSString *)string locale:(NSLocale *)locale error:(out NSError * _Nullable * _Nullable)error;

/**
 Interpolate separator into camel case string

 @param string the string expected to be camel case
 @param separator the separator
 @return the interpolated string
 @see https://stackoverflow.com/questions/7322498/insert-or-split-string-at-uppercase-letters-objective-c
 */
+ (nullable NSString *)interpolatedStringWithCamelCaseString:(NSString *)string separator:(nullable NSString *)separator;

#pragma mark - NSStringFromXXX

+ (NSString *)stringFromUIGestureRecognizerState:(UIGestureRecognizerState)state;

#pragma mark - Handle String As Plain

#pragma mark > Substring String

/**
 Safe get substring with the location and the length

 @param string the whole string
 @param location the start location which expected in the [0, string.length]. If location is equal to the length of the string, returns an empty string.
 @param length the length of substring. And the length > string.length - location, will return the substring from location to the end
 @return the substring. Return nil if the locatio or length is invalid, e.g. location out of the string index [0..string.length].
 @discussion The location is equal to the length of the string, returns an empty string. This is keep same as -[NSString substringFromIndex:].
 */
+ (nullable NSString *)substringWithString:(NSString *)string atLocation:(NSUInteger)location length:(NSUInteger)length;

/**
 Safe get substring with range

 @param string the whole string
 @param range the range.
 @return the substring. Return nil if the range is invalid, e.g. location out of the string index [0..string.length]
 @discussion If the location is string.length, the length is 0, return an empty string, but the length is > 0, return nil.
 */
+ (nullable NSString *)substringWithString:(NSString *)string range:(NSRange)range;

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
+ (nullable NSString *)firstSubstringWithString:(NSString *)string substringInCharacterSet:(NSCharacterSet *)characterSet;

#pragma mark > Split String

/**
 Split string into components by multiple delimeters

 @param string the original string
 @param delimeters the multiple delimeters. Split the string with delimeters by the order of the array.
 @return the components after spliting. The components will remove empty strings before return it.
 @discussion If have multiple delimeters, will split the string one by one, and the order of the delimeters
 array will affect the return result.
 */
+ (nullable NSArray<NSString *> *)componentsWithString:(NSString *)string delimeters:(NSArray<NSString *> *)delimeters;

+ (nullable NSArray<NSString *> *)componentsWithString:(NSString *)string delimeters:(NSArray<NSString *> *)delimeters mode:(WCStringSplitInComponentsMode)mode;

/**
 Split string into components by multiple gap ranges

 @param string the string to split
 @param gapRanges the array of NSValue which is range
 @return the component strings. Return nil, if the gapRanges has invalid range, e.g. the two range have intersection; the range out of the string; ...
 */
+ (nullable NSArray<NSString *> *)componentsWithString:(NSString *)string gapRanges:(NSArray<NSValue *> *)gapRanges;

/**
 Split string into components by character set

 @param string the string to split
 @param charactersSet the character set as separators
 @param substringRanges the ranges of components
 @return the components after spliting. 
 */
+ (nullable NSArray<NSString *> *)componentsWithString:(NSString *)string charactersInSet:(NSCharacterSet *)charactersSet substringRangs:(inout NSMutableArray<NSValue *> *)substringRanges;

#pragma mark > unichar

/**
 Convert an unichar to NSString
 
 @param unichar the unichar
 @return the NSString
 
 @see https://stackoverflow.com/a/1354413
 */
+ (nullable NSString *)stringWithUnichar:(unichar)unichar;

#pragma mark > String Validation

/**
 Check string if contains an ascend or descend character sequence with length

 @param string the string to check
 @param charactersLength the length of ascend or descend character sequence. If length <= 1 or string.length <= 1, always return NO
 @return YES if the string has ascend or descend character sequence as least with length (>= `length`)
 */
+ (BOOL)checkStringContainsCharactersAscendOrDescendWithString:(NSString *)string charactersLength:(NSInteger)charactersLength;

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

/**
 Check string if match email

 @param string the string to check
 @return YES if string match email format
 @see https://stackoverflow.com/a/5428376
 */
+ (BOOL)checkStringAsEmailWithString:(NSString *)string;

/**
 Check string if url escaped

 @param string the string to check
 @return YES if string has url escaped
 @see https://stackoverflow.com/questions/33445003/check-nsstring-is-encoded-or-not
 */
+ (BOOL)checkStringURLEscapedWithString:(NSString *)string;

/**
 Check string if contains a chinese character

 @param string the string to check
 @return YES if string contains a chinese character. NO if string contains no chinese characters.
 */
+ (BOOL)checkStringContainsChineseCharactersWithString:(NSString *)string;

/**
 Check string if contains all characters

 @param string the string to check
 @param allCharacters the all characters which expected appear simultaneously in the string
 @return YES if string contains the all characters
 */
+ (BOOL)checkStringContainsAllCharactersWithString:(NSString *)string allCharacters:(NSString *)allCharacters;

#pragma mark > String Generation

/**
 Generate a random alphanumeric string from @"a-zA-Z0-9"

 @param length the length of the random string
 @return the random string. Return nil if length = 0.
 */
+ (nullable NSString *)randomStringWithLength:(NSUInteger)length;

/**
 Generate a random string from characters

 @param characters the characters to generate the random string
 @param length the length of the random string
 @return the random string. Return nil if length = 0 or characters is empty.
 @see http://stackoverflow.com/questions/2633801/generate-a-random-alphanumeric-string-in-cocoa
 */
+ (nullable NSString *)randomStringWithCharacters:(NSString *)characters length:(NSUInteger)length;

/**
 Convert non-spaced string into spaced string with the specified format, e.g. @"12312341234" to @"123 1234 1234" with format @"XXX XXXX XXXX"

 @param string the original string
 @param format the format string contains spaces and non-space characters
 @return the spaced string
 @discussion 1. The trailing space in formatString will be ignored, e.g. @"abc" to @" a b c" with format @" X X X "
        <br/> 2. If the string contains space, the space will be trimmed
 */
+ (nullable NSString *)spacedStringWithString:(NSString *)string format:(NSString *)format;

/**
 Get a string with format and an array of arguments

 @param format the format string which used in +[NSString stringWithFormat:]
 @param arguments the array of argument which are objects, and the length of arguments should not > 10
 @return the formatted string
 @see https://stackoverflow.com/questions/1058736/how-to-create-a-nsstring-from-a-format-string-like-xxx-yyy-and-a-nsarr
 @warning If the length of arguments > 20, this method will return an empty string.
 */
+ (nullable NSString *)stringWithFormat:(NSString *)format arguments:(NSArray *)arguments;

/**
 Collapse continuous same characters into only one character, e.g. "AAABBCDD" -> "ABCD"

 @param string the original string
 @param characters the adjacent characters which should be collapsed
 @return the collapsed string. If the characters is empty (@""), just return the original string
 */
+ (nullable NSString *)collapseAdjacentCharactersWithString:(NSString *)string characters:(NSString *)characters;

/**
 Insert an separator into a string at the interval space

 @param string the string to insert
 @param separator the separator string
 @param interval the interval which should > 0.
 @return the inserted string. Return the original string if the interval <=0.
 */
+ (nullable NSString *)insertSeparatorWithString:(NSString *)string separator:(NSString *)separator atInterval:(NSInteger)interval;

/**
 Truncate string with style and separator

 @param string the original string
 @param length the maximum length. If the original string's length exceed the maximum length, truncate the original string
 @param truncatingStyle the truncating style
 @param separator the separator. If nil, use `...` by default
 @return the truncated string
 @see https://stackoverflow.com/a/5723274
 */
+ (nullable NSString *)truncatedStringWithString:(NSString *)string limitedToLength:(NSUInteger)length truncatingStyle:(WCStringTruncatingStyle)truncatingStyle separator:(nullable NSString *)separator;

#pragma mark > String Modification

/**
 Replace string by multiple ranges

 @param string the original string
 @param ranges the ranges to replace which elements are NSValue
 @param replacementStrings the strings to replace and allow empty string (a.k.a. @"")
 @param replacementRanges (inout) the ranges of replacementStrings which is an out parameters. Pass an empty NSMutableArray instance to get elements.
 @return the replaced string. Return nil if the parameters are not valid. Return the original string if the parameters are empty array.
 @discussion The parameters condition are considered
    - the ranges should be valid. (1) ranges have no intersection; (2) ranges not out of the original string
    - the ranges and replacementStrings have same length
 */
+ (nullable NSString *)replaceCharactersInRangesWithString:(NSString *)string ranges:(NSArray<NSValue *> *)ranges replacementStrings:(NSArray<NSString *> *)replacementStrings replacementRanges:(inout nullable NSMutableArray<NSValue *> *)replacementRanges;

#pragma mark > String Conversion

#pragma mark >> String to CGRect/UIEdgeInsets/UIColor

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
+ (nullable NSValue *)edgeInsetsValueFromString:(NSString *)string;

/**
 Convert hex string to UIColor
 
 @param string the hex string with foramt @"#RRGGBB" or @"#RRGGBBAA"
 @return the UIColor object. return nil if string is not valid.
 @discussion If the hex string not prefixed with `#`, use WCColorTool instead.
 */
+ (nullable UIColor *)colorFromHexString:(NSString *)string;

#pragma mark  >> Unicode

/**
 Convert escaped utf8 characters back to their original form, e.g. @"\\U5378\\U8f7d\\U5e94\\U7528" => @"卸载应用"

 @param string the escaped utf8 string
 @return the unescaped string
 @see http://stackoverflow.com/questions/2099349/using-objective-c-cocoa-to-unescape-unicode-characters-ie-u1234/11615076#11615076
 */
+ (nullable NSString *)unescapeUTF8EncodingStringWithString:(NSString *)string;
/**
 Companion with unescapedUnicodeString, escape raw unicode string, e.g. ESCAPE_UNICODE_CSTR("\U5e97\U94fa\U6d4b\U8bd5\U8d26\U53f7") => @"\"\\U5e97\\U94fa\\U6d4b\\U8bd5\\U8d26\\U53f7\""

 @param ... the c string
 @return the NSString
 */
#define ESCAPE_UNICODE_CSTR(...) @#__VA_ARGS__

+ (nullable NSString *)unescapeUnicodeStringWithString:(NSString *)string;

+ (nullable NSString *)unicodePointStringWithString:(NSString *)string;

/**
 Convert NSString to NSNumber with \@encode

 @param string the string
        1. number type, characters are in @"-.0123456789"
        2. bool type, YES for string started by "Y", "y", "T", "t", or a digit 1-9 and ignore leading whitespace; others for NO.
 @param encodedType the char string using \@encode
 @return the number. Return nil if encodedType not support
 @discussion The encodedType supports as following:
     \@encode(double)
     \@encode(float)
     \@encode(int)
     \@encode(NSInteger)
     \@encode(long long)
     \@encode(long)
     \@encode(BOOL)
 @see https://stackoverflow.com/a/17093809
 */
+ (nullable NSNumber *)numberFromString:(NSString *)string encodedType:(char *)encodedType;

/**
 Convert int64 to binary string
 
 @param intValue the int value of 64 bits
 @return the NSString with binary style, e.g. @"...01010" (the length is 64)
 
 @see http://iosdevelopertips.com/objective-c/convert-integer-to-binary-nsstring.html
 */
+ (nullable NSString *)binaryStringFromInt64:(int64_t)intValue;
+ (nullable NSString *)binaryStringFromInt32:(int32_t)intValue;
+ (nullable NSString *)binaryStringFromInt16:(int16_t)intValue;
+ (nullable NSString *)binaryStringFromInt8:(int8_t)intValue;
+ (nullable NSString *)binaryStringFromIntX:(int64_t)intValue numberOfBits:(int64_t)numberOfBits;

#pragma mark > String Measuration (e.g. length, number of substring, range, ...)

/**
 Find ranges of all substrings

 @param string the string
 @param substring the substring maybe occurred many times
 @return the array constructed by [NSValue valueWithRange:range]
 @see http://stackoverflow.com/questions/7033574/find-all-locations-of-substring-in-nsstring-not-just-first
 */
+ (nullable NSArray<NSValue *> *)rangesOfSubstringWithString:(NSString *)string substring:(NSString *)substring;

/**
 Get the length with treat a chinese character as two characters

 @param string the string
 @param chineseCharacterAsTwoCharacters YES, treat a chinese character as two characters; NO, use string.length
 @return the number of characters in the string. Return NSNotFound if an error happened.
 */
+ (NSInteger)lengthWithString:(NSString *)string treatChineseCharacterAsTwoCharacters:(BOOL)chineseCharacterAsTwoCharacters;

+ (NSInteger)lengthByVisualizationWithString:(NSString *)string;

/**
 Get the occurrence times of substring in string

 @param string the whole string
 @param substring the substring
 @return the occurrence times of substring. If substring is \@"", return 0. Return NSNotFound if an error happened.
 */
+ (NSInteger)occurrenceOfSubstringInString:(NSString *)string substring:(NSString *)substring;

#pragma mark > String Lowercase/Uppercase

/**
 Lowercase substring with range

 @param string the original string
 @param range the range to lowercase
 @return the new string
 */
+ (nullable NSString *)lowercaseStringWithString:(NSString *)string range:(NSRange)range;

/**
 Uppercase substring with range

 @param string the original string
 @param range the range to uppercase
 @return the new string
 */
+ (nullable NSString *)uppercaseStringWithString:(NSString *)string range:(NSRange)range;

/**
 Change case of the substring with ranage

 @param string the original string
 @param range the range to change
 @param isUppercase YES, uppercase; NO, lowercase
 @return the new string
 */
+ (nullable NSString *)changeCaseStringWithString:(NSString *)string range:(NSRange)range isUppercase:(BOOL)isUppercase;

#pragma mark - Handle String As Url/Url-like

/**
 Get key/value pairs from the string with the specific connector and separator
 
 @param string the string contains key-value format
 @param connector the connector sign which connects key and value
 @param separator the separator sign which separate the key value pairs
 @return the dictionary of the key value pairs
 @discussion If parse url-like key values, use +[WCStringTool keyValuePairsWithUrlString:] instead.
 */
+ (nullable NSDictionary<NSString *, NSString *> *)keyValuePairsWithString:(NSString *)string usingConnector:(NSString *)connector usingSeparator:(NSString *)separator;

/**
 Get key value pairs from url-like string
 
 @param urlString the url-like string which should contains a `?`, e.g. ?key1=value1&key2=value2#jumpLocation
 @return the key value pairs
 @note For checking http/https URL strictly, use WCURLTool instead
 @discussion
 1. The urlString expected to have different keys. If have the same key, the return result is not determined.
 2. This method not validates the urlString, pass malformed string may get the wrong result. e.g. abc@key1=A#key2=B
 */
+ (nullable NSDictionary *)keyValuePairsWithUrlString:(NSString *)urlString;

#pragma mark > URL Encode/Decode

/**
 Get a URL encoded string
 
 @param string the string
 @return the URL encoded string
 
 @see AFPercentEscapedStringFromString function, https://github.com/AFNetworking/AFNetworking/blob/master/AFNetworking/AFURLRequestSerialization.m#L47
 */
+ (nullable NSString *)URLEscapedStringWithString:(nullable NSString *)string;

/**
 Get a URL decoded string with UTF-8 encoding
 
 @param string the string
 @return the URL decoded string
 
 @see http://isobar.logdown.com/posts/211030-url-encode-decode-in-ios
 */
+ (nullable NSString *)URLUnescapedStringWithString:(nullable NSString *)string;

#pragma mark - Handle String As HTML

/**
 Remove all html tags (<a></a> or <not a tag>) for html string

 @param htmlString the string expected to be html string
 @return the striped string
 */
+ (nullable NSString *)stripTagsWithHTMLString:(NSString *)htmlString;

#pragma mark - Handle String As Path

/**
 Get a relative path based on anchorPath

 @param pathString the path
 @param anchorPath the anchor path which is based on
 @return the relative path, e.g. "b/c", "../b/c"
 @see http://stackoverflow.com/questions/6539273/objective-c-code-to-generate-a-relative-path-given-a-file-and-a-directory
 */
+ (nullable NSString *)pathWithPathString:(NSString *)pathString relativeToPath:(NSString *)anchorPath;

+ (nullable NSString *)pathWithSubpathInCacheFolder:(NSString *)subpath;
+ (nullable NSString *)pathWithSubpathInDocumentFolder:(NSString *)subpath;
+ (nullable NSString *)pathWithSubpathInLibraryFolder:(NSString *)subpath;

/**
 Get path in some folder

 @param subpath the subpath expected in the system directory
 @param systemDirectory the system directory
 @return the path
 */
+ (nullable NSString *)pathWithSubpath:(NSString *)subpath inDirectory:(NSSearchPathDirectory)systemDirectory;

#pragma mark - Handle String As Number

/**
 Remove trailing zeros after decimal dot if needed

 @param numberString the number string
 @return the new number string
 @see https://stackoverflow.com/a/14985235
 @discussion for examples as follows
 1000    -> 1000
 10.000  -> 10 (without point in result)
 10.0100 -> 10.01
 10.1234 -> 10.1234
 */
+ (nullable NSString *)removeTrailZerosWithNumberString:(NSString *)numberString;

#pragma mark - Encryption

#pragma mark > MD5

/*!
 *  MD5 encryption
 *
 *  @header #import <CommonCrypto/CommonDigest.h>
 */
+ (nullable NSString *)MD5WithString:(NSString *)string;

#pragma mark > Base64 Encode/Decode

/**
 Encode plain string into single line base64 string

 @param string the plain string
 @return the base64 encoded string
 */
+ (nullable NSString *)base64EncodedStringWithString:(NSString *)string NS_AVAILABLE_IOS(7_0);

/**
 Encode plain string into base64 string

 @param string the plain string
 @param options the NSDataBase64EncodingOptions
        - NSDataBase64EncodingEndLineWithCarriageReturn, the line ending to insert `\r`
        - NSDataBase64EncodingEndLineWithLineFeed, the line ending to insert `\n`
        - kNilOptions, the line ending to insert `\r\n`
        - NSDataBase64Encoding64CharacterLineLength, the maximum length of each line is 64
        - NSDataBase64Encoding76CharacterLineLength, the maximum length of each line is 76
 @return the base64 encoded string
 @see About `\r` (CarriageReturn) and `\n` (LineFeed), https://stackoverflow.com/a/12747850
 */
+ (nullable NSString *)base64EncodedStringWithString:(NSString *)string options:(NSDataBase64EncodingOptions)options NS_AVAILABLE_IOS(7_0);

/**
 Decode base64 string to plain string

 @param string the base64 encoded string
 @return the plain string
 */
+ (nullable NSString *)base64DecodedStringWithString:(NSString *)string NS_AVAILABLE_IOS(7_0);

@end

NS_ASSUME_NONNULL_END
