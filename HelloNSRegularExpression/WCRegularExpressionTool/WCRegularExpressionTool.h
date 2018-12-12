//
//  WCRegularExpressionTool.h
//  HelloNSRegularExpression
//
//  Created by wesley_chen on 2018/9/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCRegularExpressionTool : NSObject

@property (nonatomic, assign, class) BOOL enableLogging;

#pragma mark - Get NSTextCheckingResult

/**
 Get the first match in the string

 @param string the string to search
 @param pattern the regular expression
 @return the match result. Return nil if not match
 */
+ (nullable NSTextCheckingResult *)firstMatchInString:(NSString *)string pattern:(NSString *)pattern;

/**
 Traverse matches in the string

 @param string the string to search
 @param pattern the regular expression
 @param block the traverse block
        - result, the match result
        - flags
        - stop, set *stop = YES to break the traverse
 @return the status. YES if the block called successfully; NO if parameters are wrong and block not called
 */
+ (BOOL)enumerateMatchesInString:(NSString *)string pattern:(NSString *)pattern usingBlock:(void (^)(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop))block;

#pragma mark - Replace Matched String

/**
 Replace multiple matched strings with pattern string

 @param string the original string to regular expression search
 @param pattern the pattern of regular expression
 @param captureGroupBindingBlock the block for replace matched string.
        - matchString, the matched string
        - captureGroupStrings, the array of capture group strings. If capture group match failed, its capture group string is empty string.
        Return the replacement string to replce the matched string. Return nil if not replace.
 @return the replaced string. If parameters checking failed, return the original string.
 */
+ (nullable NSString *)stringByReplacingMatchesInString:(NSString *)string pattern:(NSString *)pattern captureGroupBindingBlock:(nullable NSString *(^)(NSString *matchString, NSArray<NSString *> *captureGroupStrings))captureGroupBindingBlock;

/**
 Replace multiple matched strings with NSRegularExpression

 @param string the original string to regular expression search
 @param regex the NSRegularExpression
 @param captureGroupBindingBlock the block for replace matched string.
        - matchString, the matched string
        - captureGroupStrings, the array of capture group strings. If capture group match failed, its capture group string is empty string.
        Return the replacement string to replce the matched string. Return nil if not replace.
 @return the replaced string. If parameters checking failed, return the original string.
 @discussion This method allows pass an instance of NSRegularExpression which can be created once by caller.
 */
+ (nullable NSString *)stringByReplacingMatchesInString:(NSString *)string regularExpression:(NSRegularExpression *)regex captureGroupBindingBlock:(nullable NSString *(^)(NSString *matchString, NSArray<NSString *> *captureGroupStrings))captureGroupBindingBlock;

#pragma mark > Specific Substitutions

/**
 Velocity Template Variable Substitution

 @param string the template string
 @param bindings the bindings
 @return the substituted string
 */
+ (nullable NSString *)substituteTemplateStringWithString:(NSString *)string bindings:(NSDictionary *)bindings;

#pragma mark - Get Matched String

/**
 Get the first matched string

 @param string the original string
 @param pattern the pattern of regular expression
 @return the first matched string. Return nil if not matched.
 */
+ (nullable NSString *)firstMatchedStringInString:(NSString *)string pattern:(NSString *)pattern;

#pragma mark - Validate Pattern

/**
 Check a string if valid regular expression

 @param string the pattern
 @param error the NSError
 @return Return YES if string is a valid regular expression. Return NO if string is not a valid regular expression.
 */
+ (BOOL)checkPatternWithString:(NSString *)string error:(inout NSError * _Nullable *)error;

@end

NS_ASSUME_NONNULL_END
