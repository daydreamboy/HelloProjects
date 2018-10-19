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

@end

NS_ASSUME_NONNULL_END