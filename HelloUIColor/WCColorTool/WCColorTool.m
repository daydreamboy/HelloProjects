//
//  WCColorTool.m
//  WCColorTool
//
//  Created by wesley chen on 15/7/31.
//
//

#import "WCColorTool.h"

@implementation WCColorTool

/*!
 *  Get a random color for debug
 */
+ (UIColor *)randomColor{
    CGFloat red = arc4random() % 255 / 255.0f;
    CGFloat green = arc4random() % 255 / 255.0f;
    CGFloat blue = arc4random() % 255 / 255.0f;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    return color;
}

+ (UIColor *)randomRGBAColor {
    CGFloat red = arc4random() % 255 / 255.0f;
    CGFloat green = arc4random() % 255 / 255.0f;
    CGFloat blue = arc4random() % 255 / 255.0f;
    CGFloat alpha = arc4random() % 10 / 10.0f;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    return color;
}

/*!
 *  Exchange two colors with progress
 *
 *  @param fromColor the fromColor will be transited to the toColor
 *  @param toColor   the toColor will be transited to the fromColor
 *  @param progress  the progress of transition between 0..1
 *
 *  @return a NSArray of two transited colors on progress
 */
+ (NSArray *)transitionColorsFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor onProgress:(CGFloat)progress {
    CGFloat fromRed, fromGreen, fromBlue, fromAlpha, toRed, toGreen, toBlue, toAlpha;
    
    [self componentsOfRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha fromColor:fromColor];
    [self componentsOfRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha fromColor:toColor];
    
    CGFloat ratio = (progress < 0 ? 0 : (progress > 1 ? 1 : progress));
    
    UIColor *transitionColorOfFromColor = [UIColor colorWithRed:fromRed * ratio + toRed * (1 - ratio)
                                                          green:fromGreen * ratio + toGreen * (1 - ratio)
                                                           blue:fromBlue * ratio + toBlue  * (1 - ratio)
                                                          alpha:fromAlpha * ratio + toAlpha  * (1 - ratio)];
    
    UIColor *transitionColorOfToColor = [UIColor colorWithRed:fromRed * (1 - ratio) + toRed * ratio
                                                        green:fromGreen * (1 - ratio) + toGreen * ratio
                                                         blue:fromBlue * (1 - ratio) + toBlue * ratio
                                                        alpha:fromAlpha * (1 - ratio) + toAlpha * ratio];
    
    return @[transitionColorOfFromColor, transitionColorOfToColor];
}

/*!
 *  Set alpha component of a UIColor
 *
 *  @param alpha a CGFloat included between 0..1
 */
+ (UIColor *)alphaColorWithColor:(UIColor *)color alpha:(CGFloat)alpha {
    return [color colorWithAlphaComponent:alpha];
}

#pragma mark - Color Convertion

#pragma mark > UIColor to NSString
+ (NSString *)RGBAHexStringFromUIColor:(UIColor *)color {
    CGFloat r, g, b, a;
    [self componentsOfRed:&r green:&g blue:&b alpha:&a fromColor:color];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255),
            lroundf(a * 255)
            ];
}

+ (NSString *)RGBHexStringFromUIColor:(UIColor *)color {
    CGFloat r, g, b, a;
    [self componentsOfRed:&r green:&g blue:&b alpha:&a fromColor:color];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)
            ];
}

#pragma mark > NSString to UIColor

+ (UIColor *)colorWithHexString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (![string hasPrefix:@"#"] || (string.length != 7 && string.length != 9)) {
        return nil;
    }
    
    // Note: -1 as failure flag
    int r = -1, g = -1, b = -1, a = -1;
    
    if (string.length == 7) {
        a = 0xFF;
        sscanf([string UTF8String], "#%02x%02x%02x", &r, &g, &b);
    }
    else if (string.length == 9) {
        sscanf([string UTF8String], "#%02x%02x%02x%02x", &r, &g, &b, &a);
    }
    
    if (r == -1 || g == -1 || b == -1 || a == -1) {
        // parse hex failed
        return nil;
    }
    
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a / 255.0];
}

#pragma mark - Color Checks

// @see https://stackoverflow.com/a/31565930
+ (BOOL)isClearWithColor:(UIColor *)color {
    CGFloat alpha = CGColorGetAlpha(color.CGColor);
    if (alpha == (CGFloat)0.0) {
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark - Private Methods

+ (void)componentsOfRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha fromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor));
    
    if (colorSpaceModel == kCGColorSpaceModelRGB && CGColorGetNumberOfComponents(color.CGColor) == 4) {
        *red = components[0];
        *green = components[1];
        *blue = components[2];
        *alpha = components[3];
    }
    else if (colorSpaceModel == kCGColorSpaceModelMonochrome && CGColorGetNumberOfComponents(color.CGColor) == 2) {
        *red = *green = *blue = components[0];
        *alpha = components[1];
    }
    else {
        *red = *green = *blue = *alpha = 0;
    }
}

@end
