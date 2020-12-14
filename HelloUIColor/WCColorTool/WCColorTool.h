//
//  WCColorTool.h
//  WCColorTool
//
//  Created by wesley chen on 15/7/31.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCColorTool : NSObject

#pragma mark - Color Creation

/**
 Get a color with the specific alpha

 @param color the original color
 @param alpha a CGFloat included between 0..1
 @return the color with the specific alpha
 */
+ (nullable UIColor *)alphaColorWithColor:(UIColor *)color alpha:(CGFloat)alpha;

/**
 Get a random color with alpha = 1

 @return the random color
 */
+ (UIColor *)randomColor;

/**
 Get a random color with a random alpha

 @return the random color
 */
+ (UIColor *)randomRGBAColor;

#pragma mark - Color Conversion

#pragma mark > UIColor to NSString

+ (nullable NSString *)RGBHexStringFromUIColor:(UIColor *)color;
+ (nullable NSString *)RGBAHexStringFromUIColor:(UIColor *)color;

#pragma mark > NSString to UIColor

/**
 Convert hex string to UIColor
 
 @param string the hex string with foramt @"#RRGGBB" or @"#RRGGBBAA"
 @return the UIColor object. return nil if string is not valid.
 */
+ (nullable UIColor *)colorWithHexString:(NSString *)string;

/**
 Convert hex string to UIColor with the specific prefix

 @param string the hex string with foramt @"<prefix>RRGGBB" or @"<prefix>RRGGBBAA"
 @param prefix the prefix. For safety, prefix not allow the `%` character
 @return the UIColor object. return nil if string is not valid.
 @discussion If the prefix contains `%` character, will return nil.
 */
+ (nullable UIColor *)colorWithHexString:(NSString *)string prefix:(nullable NSString *)prefix;

#pragma mark > UIColor to NSNumber

/**
 Convert UIColor to NSNumber (long long)
 
 @param color the UIColor
 
 @return the NSNumber (long long). Return nil if failed.
 */
+ (nullable NSNumber *)numberFromUIColor:(UIColor *)color;

#pragma mark - Assistant Methods

#pragma mark > Color Checks

/**
 Check color if clear

 @param color the UIColor
 @return YES if the color is clear, NO if the color is not clear or the color is not a UIColor
 @see https://stackoverflow.com/a/31565930
 */
+ (BOOL)checkColorClearWithColor:(UIColor *)color;

#pragma mark > Others

/**
 Exchange two colors with progress
 
 @param fromColor the fromColor will be transited to the toColor
 @param toColor the toColor will be transited to the fromColor
 @param progress the progress of transition between 0..1
 @return a NSArray of two transited colors on progress
 */
+ (nullable NSArray *)transitionColorsFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor onProgress:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_END
