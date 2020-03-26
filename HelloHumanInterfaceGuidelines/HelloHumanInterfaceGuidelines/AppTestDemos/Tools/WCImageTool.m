//
//  WCImageTool.m
//  Test
//
//  Created by wesley_chen on 2018/5/4.
//

#import "WCImageTool.h"

@implementation WCImageTool

#pragma mark - Image Generation

+ (nullable UIImage *)imageWithColor:(UIColor *)color {
    // Note: create 1px X 1px size of rect
    return [self imageWithColor:color size:CGSizeMake(1.0 / [UIScreen mainScreen].scale, 1.0 / [UIScreen mainScreen].scale) cornerRadius:0];
}

+ (nullable UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    return [self imageWithColor:color size:size cornerRadius:0];
}

+ (nullable UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius {
    if (![color isKindOfClass:[UIColor class]]) {
        return nil;
    }
    
    if (size.width <= 0 || size.height <= 0) {
        return nil;
    }
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    // Note: use UIGraphicsBeginImageContextWithOptions instead of UIGraphicsBeginImageContext to set UIImage.scale
    // @see https://stackoverflow.com/questions/4965036/uigraphicsgetimagefromcurrentimagecontext-retina-resolution
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (cornerRadius > 0) {
        [[UIBezierPath bezierPathWithRoundedRect:(CGRect){CGPointZero, size} cornerRadius:cornerRadius] addClip];
    }
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
