//
//  WCHorizontalSliderViewUtility.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/7/17.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCHorizontalSliderViewUtility.h"

@implementation WCHorizontalSliderViewUtility

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    // Note: use UIGraphicsBeginImageContextWithOptions instead of UIGraphicsBeginImageContext to set UIImage.scale
    // @see https://stackoverflow.com/questions/4965036/uigraphicsgetimagefromcurrentimagecontext-retina-resolution
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
