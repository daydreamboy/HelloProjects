//
//  WCColorTool.h
//  WCColorTool
//
//  Created by wesley chen on 15/7/31.
//
//

#import <UIKit/UIKit.h>

@interface WCColorTool : NSObject

#pragma mark - Color Modification
+ (UIColor *)alphaColorWithColor:(UIColor *)color alpha:(CGFloat)alpha;

+ (UIColor *)randomColor;
+ (UIColor *)randomRGBAColor;
+ (NSArray *)transitionColorsFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor onProgress:(CGFloat)progress;

#pragma mark - Color Convertion

#pragma mark > UIColor to NSString
+ (NSString *)RGBHexStringFromUIColor:(UIColor *)color;
+ (NSString *)RGBAHexStringFromUIColor:(UIColor *)color;

#pragma mark > NSString to UIColor

/**
 Convert hex string to UIColor

 @param string the hex string with foramt @"#RRGGBB" or @"#RRGGBBAA"
 @return the UIColor object. return nil if string is not valid.
 */
+ (UIColor *)colorWithHexString:(NSString *)string;

#pragma mark - Color Checks

+ (BOOL)isClearWithColor:(UIColor *)color;

@end
