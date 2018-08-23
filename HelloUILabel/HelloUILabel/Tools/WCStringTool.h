//
//  WCStringTool.h
//  HelloUILabel
//
//  Created by wesley_chen on 2018/7/23.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WCStringTool : NSObject
@end

@interface WCStringTool ()

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
@end
