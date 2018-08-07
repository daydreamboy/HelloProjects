//
//  WCImageTool.m
//  HelloUILabel
//
//  Created by wesley_chen on 2018/8/7.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCImageTool.h"

@implementation WCImageTool

+ (UIImage *)imageWithColor:(UIColor *)color {
    // Note: create 1px X 1px size of rect
    return [self imageWithColor:color size:CGSizeMake(1.0 / [UIScreen mainScreen].scale, 1.0 / [UIScreen mainScreen].scale)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
