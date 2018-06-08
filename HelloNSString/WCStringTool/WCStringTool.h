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

#pragma mark - NSString to Struct/Object

/**
 Safe convert NSString to CGRect
 
 @param string the NSString represents CGRect
 @return the CGRect. If the NSString is malformed, return the CGRectNull
 @warning not allow 0.0, instead of just using 0.
 */
+ (CGRect)rectFromString:(NSString *)string;

/**
 Safe convert NSString to UIEdgeInsets

 @param string the NSString represents UIEdgeInsets
 @return the NSValue to wrap UIEdgeInsets, use value.UIEdgeInsets to get UIEdgeInsets
 @warning not allow 0.0, instead of just using 0.
 */
+ (NSValue *)edgeInsetsValueFromString:(NSString *)string;

/**
 Convert hex string to UIColor
 
 @param string the hex string with foramt @"#RRGGBB" or @"#RRGGBBAA"
 @return the UIColor object. return nil if string is not valid.
 */
+ (UIColor *)colorFromHexString:(NSString *)string;

#pragma mark - Measure Size for Single-line/Multi-line String

+ (CGSize)textSizeWithSingleLineString:(NSString *)string font:(UIFont *)font;
+ (CGSize)textSizeWithMultiLineString:(NSString *)string font:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;
+ (CGSize)textSizeWithMultipleLineString:(NSString *)string width:(CGFloat)width attributes:(NSDictionary *)attributes;

@end
