//
//  WCAttributedStringTool.h
//  HelloNSAttributedString
//
//  Created by wesley_chen on 2018/10/24.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCAttributedStringTool : NSObject

#pragma mark > Substring String

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

/**
 Replace string in attributed string

 @param attributedString the attributed string
 @param occurrenceString the occurrence of string
 @param replacementString the replacement string
 @param range the range of replacing.
        - If range.location out of [0, attributedString.length) return nil.
        - If range.location is [0, attributedString.length), but range.length exceed the length of attributedString, range is from location to the end of attributedString
 @return the attributed string after replace.
 @see https://stackoverflow.com/questions/8231240/replace-substring-of-nsattributedstring-with-another-nsattributedstring
 */
+ (nullable NSAttributedString *)replaceStringWithAttributedString:(NSAttributedString *)attributedString occurrenceString:(NSString *)occurrenceString replacementString:(NSString *)replacementString range:(NSRange)range;

/**
 Create an attributed string by using a given format string as a template into which the remaining argument values are substituted.

 @param format A format string. This value must not be nil.
 @param ... A comma-separated list of arguments to substitute into format.
 @return An attributed string created by using format as a template into which the remaining argument values are substituted.
 */
+ (nullable NSAttributedString *)attributedStringWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

#pragma mark > Text Size (UILabel)

/**
 Calculate text size for multiple lines (numberOfLines = 0)

 @param attributedString the attributed string
 @param width the fixed width
 @param widthToFit If NO, the width of calculated text size always is the input width. If YES, the width of calculated text size as it.
 @return the text size
 @see http://stackoverflow.com/questions/13621084/boundingrectwithsize-for-nsattributedstring-returning-wrong-size
 */
+ (CGSize)textSizeWithMultipleLineAttributedString:(NSAttributedString *)attributedString width:(CGFloat)width widthToFit:(BOOL)widthToFit;

/**
 Calculate text size for single line (numberOfLines = 1)

 @param attributedString tha attributed string expected a single line which should have no line wrap '\\n'
 @return the text size
 */
+ (CGSize)textSizeWithSingleLineAttributedString:(NSAttributedString *)attributedString;

/**
 Calculate text size for fixed lines (numberOfLines > 0)
 
 @param attributedString the attributed string
 @param width the fixed width
 @param maximumNumberOfLines the maximum number of lines. maximumNumberOfLines <= 0, will treat as multiple lines (maximumNumberOfLines = 0)
 @param widthToFit If NO, the width of calculated text size always is the input width. If YES, the width of calculated text size as it. Note: this flag only works when maximumNumberOfLines > 0
 
 @return the text size
 */
+ (CGSize)textSizeWithFixedLineAttributedString:(NSAttributedString *)attributedString width:(CGFloat)width maximumNumberOfLines:(NSUInteger)maximumNumberOfLines widthToFit:(BOOL)widthToFit;

#pragma mark - Attachment

/**
 Get an image attachment attributed string
 
 @param imageName  the image name
 @param frame the frame of image
 @return the attributed string contains the image. If the image not found, return an empty attributed string.
 */
+ (NSAttributedString *)attributedStringWithImageName:(NSString *)imageName frame:(CGRect)frame;

/**
 Get an image attachment attributed string which aligned vertically to the UIFont
 
 @param imageName  the image name
 @param imageSize the actual image size. If want the image scaled by font, set CGSizeZero
 @param font the UIFont of the text
 @return the attributed string contains the image. If the image not found, return an empty attributed string.
 @see https://stackoverflow.com/a/47888862
 */
+ (NSAttributedString *)attributedStringWithImageName:(NSString *)imageName imageSize:(CGSize)imageSize alignToFont:(UIFont *)font;

/**
 Get an image attachment attributed string which aligned vertically to the UIFont
 
 @param image the UIImage
 @param imageSize the actual image size. If want the image scaled by font, set CGSizeZero
 @param font the UIFont of the text
 @return the attributed string contains the image. If the image not found, return an empty attributed string.
 */
+ (NSAttributedString *)attributedStringWithImage:(UIImage *)image imageSize:(CGSize)imageSize alignToFont:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
