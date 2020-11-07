//
//  WCFontTool.h
//  HelloUITextView
//
//  Created by wesley_chen on 2020/9/27.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCFontTool : NSObject

@end

@interface WCFontTool ()

/**
 Find the adaptive font which fit the contrained size
 
 @param initialFont the initial font which for reference
 @param minimumFontSize the minimum font size
 @param contrainedSize the contrained size
 @param mutilpleLines the flag if multiple lines. If YES, use width/height of contrainedSize. If NO, use height of contrainedSize
 @param textString the text string. If nil, use @"abcdefg..." instead.
 
 @discussion If mutilpleLines = YES, textString should not be nil.
 */
+ (nullable UIFont *)adaptiveFontWithInitialFont:(UIFont *)initialFont minimumFontSize:(NSUInteger)minimumFontSize contrainedSize:(CGSize)contrainedSize mutilpleLines:(BOOL)mutilpleLines textString:(nullable NSString *)textString;

/**
 Find the maximum font which fit the contrained size
 
 @param initialFont the initial font which for reference
 @param minimumFontSize the minimum font size
 @param contrainedSize the contrained size
 @param mutilpleLines the flag if multiple lines. If YES, use width/height of contrainedSize. If NO, use height of contrainedSize
 @param textString the text string. If nil, use @"abcdefg..." instead.
 
 @discussion If mutilpleLines = YES, textString should not be nil.
 
 @see https://stackoverflow.com/a/17622215
 */
+ (nullable UIFont *)adaptiveMaximumFontWithInitialFont:(UIFont *)initialFont minimumFontSize:(NSUInteger)minimumFontSize contrainedSize:(CGSize)contrainedSize mutilpleLines:(BOOL)mutilpleLines textString:(nullable NSString *)textString;

@end

NS_ASSUME_NONNULL_END
