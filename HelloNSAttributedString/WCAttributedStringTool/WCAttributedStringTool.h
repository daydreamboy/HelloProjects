//
//  WCAttributedStringTool.h
//  HelloNSAttributedString
//
//  Created by wesley_chen on 2018/10/24.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark > Substring String

@interface WCAttributedStringTool : NSObject

/**
 Get substring of an attributed string with the range

 @param attributedString the NSAttributedString
 @param range the range of substring
 @return the attributed substring
 @discussion This method is safe wrapper of -[NSAttributedString(NSExtendedAttributedString) attributedSubstringFromRange:]
 */
+ (nullable NSAttributedString *)attributedSubstringWithAttributedString:(NSAttributedString *)attributedString range:(NSRange)range;

#pragma mark > String Modification

/**
 Replace attributed string by multiple ranges

 @param attributedString the original attributed string
 @param ranges the ranges to replace which elements are NSValue
 @param replacementAttributedStrings the attributed strings to replace
 @param replacementRanges the ranges of replacementStrings which is an out parameters. Pass a NSMutableArray instance to get elements.
 @return the replaced attributed string. Return nil if the parameters are not valid. Return the original attributed string if the parameters are empty array.
 @discussion The parameters condition are considered
    - the ranges should be valid. (1) ranges have no intersection; (2) ranges not out of the original string
    - the ranges and replacementStrings have same length
 */
+ (nullable NSAttributedString *)replaceCharactersInRangesWithAttributedString:(NSAttributedString *)attributedString ranges:(NSArray<NSValue *> *)ranges replacementAttributedStrings:(NSArray<NSAttributedString *> *)replacementAttributedStrings replacementRanges:(inout nullable NSMutableArray<NSValue *> *)replacementRanges;

@end

NS_ASSUME_NONNULL_END
