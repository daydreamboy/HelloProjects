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

/**
 The match pattern
 */
@property (nonatomic, copy, readonly) NSString *pattern;

/**
 The match regular expression
 */
@property (nonatomic, copy, readonly, nullable) NSRegularExpression *regexp;

/**
 Enable cache the match results
 
 Default is YES
 */
@property (nonatomic, assign) BOOL enableCache;

- (instancetype)initWithPattern:(NSString *)pattern options:(NSRegularExpressionOptions)options;

#pragma mark > Get first matched result/string

- (nullable NSTextCheckingResult *)firstMatchInString:(NSString *)string;
- (nullable NSTextCheckingResult *)firstMatchInString:(NSString *)string options:(NSMatchingOptions)options range:(NSRange)range;

- (nullable NSString *)firstMatchedStringInString:(NSString *)string;
- (nullable NSString *)firstMatchedStringInString:(NSString *)string options:(NSMatchingOptions)options range:(NSRange)range;

#pragma mark > Traverse matched result

- (BOOL)enumerateMatchesInString:(NSString *)string usingBlock:(void (^)(NSTextCheckingResult *_Nullable result, NSMatchingFlags flags, BOOL *stop))block;
- (BOOL)enumerateMatchesInString:(NSString *)string options:(NSMatchingOptions)options range:(NSRange)range usingBlock:(void (^)(NSTextCheckingResult *_Nullable result, NSMatchingFlags flags, BOOL *stop))block;

#pragma mark > Traverse matched string

- (BOOL)enumerateMatchedStringsInString:(NSString *)string usingBlock:(void (^)(NSString * _Nullable matchedString, NSMatchingFlags flags, BOOL *stop))block;
- (BOOL)enumerateMatchedStringsInString:(NSString *)string options:(NSMatchingOptions)options range:(NSRange)range usingBlock:(void (^)(NSString * _Nullable matchedString, NSMatchingFlags flags, BOOL *stop))block;

#pragma mark > Replace matched string

- (nullable NSString *)stringByReplacingMatchesInString:(NSString *)string captureGroupBindingBlock:(nullable NSString *(^)(NSString *matchString, NSArray<NSString *> *captureGroupStrings))captureGroupBindingBlock;

#pragma mark - Class Methods

@property (nonatomic, assign, class) BOOL enableLogging;

#pragma mark - Get Matched CheckResult/String

/**
 Get the first match in the string

 @param string the string to search
 @param pattern the regular expression
 @param regex the regular expression to reuse. If not nil, use it first.
 @return the match result. Return nil if not match
 */
+ (nullable NSTextCheckingResult *)firstMatchInString:(NSString *)string pattern:(nullable NSString *)pattern reusableRegex:(nullable NSRegularExpression *)regex;

/**
 Get the first matched string
 
 @param string the original string
 @param pattern the pattern of regular expression
 @param regex the regular expression to reuse. If not nil, use it first.
 @return the first matched string. Return nil if not matched.
 */
+ (nullable NSString *)firstMatchedStringInString:(NSString *)string pattern:(nullable NSString *)pattern reusableRegex:(nullable NSRegularExpression *)regex;

#pragma mark - Traverse Matched CheckResult/String

/**
 Traverse matches in the string

 @param string the string to search
 @param pattern the regular expression
 @param block the traverse block
        - result, the match result
        - flags
        - stop, set *stop = YES to break the traverse
 @return the flag if match at less once. YES if the string has at less one match; NO if parameters are wrong or the string have no matches.
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

#pragma mark > Specific Substitutions

/**
 Velocity Template Variable Substitution

 @param string the template string
 @param bindings the bindings
 @return the substituted string
 */
+ (nullable NSString *)substituteTemplateStringWithString:(NSString *)string bindings:(NSDictionary *)bindings;

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
