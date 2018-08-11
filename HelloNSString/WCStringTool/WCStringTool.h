//
//  WCStringTool.h
//  HelloNSString
//
//  Created by wesley_chen on 2018/5/30.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WCStringTool : NSObject

#pragma mark - Measure Size for Single-line/Multi-line String

+ (CGSize)textSizeWithSingleLineString:(NSString *)string font:(UIFont *)font;
+ (CGSize)textSizeWithMultipleLineString:(NSString *)string font:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;
+ (CGSize)textSizeWithMultipleLineString:(NSString *)string width:(CGFloat)width attributes:(NSDictionary *)attributes;

#pragma mark - NSStringFromXXX

+ (NSString *)stringFromUIGestureRecognizerState:(UIGestureRecognizerState)state;

#pragma mark - Handle String As Specific Strings

#pragma mark > Handle String as CGRect/UIEdgeInsets/UIColor

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

#pragma mark > Handle String As Url

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

#pragma mark - Handle String As JSON

#pragma mark > JSON String to id/NSArray/NSDictionary

/**
 Convert the JSON formatted string to NSArray or NSDictionary object

 @param string the JSON formatted string
 @return If the string is not JSON formatted, return nil.
 */
+ (id)JSONObjectWithString:(NSString *)string NS_AVAILABLE_IOS(5_0);

/**
 Convert the JSON formatted string to NSArray object

 @param string the JSON formatted string
 @return If the string is not JSON formatted or a JSON array object, return nil.
 */
+ (NSArray *)JSONArrayWithString:(NSString *)string NS_AVAILABLE_IOS(5_0);

/**
 Convert the JSON formatted string to NSDictionary object

 @param string the JSON formatted string
 @return If the string is not JSON formatted or a JSON dictionary object, return nil.
 */
+ (NSDictionary *)JSONDictWithString:(NSString *)string NS_AVAILABLE_IOS(5_0);

#pragma mark - Encryption

+ (NSString *)MD5WithString:(NSString *)string;


@end
