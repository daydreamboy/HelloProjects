//
//  WCImageTool.m
//  HelloUIView
//
//  Created by wesley_chen on 2020/6/1.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCImageTool.h"

@implementation WCImageTool

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
