//
//  WCImageTool.m
//  HelloUIImageView
//
//  Created by wesley_chen on 2018/8/28.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCImageTool.h"

@implementation WCImageTool

#pragma mark -

+ (UIImage *)roundCorneredImageWithImage:(UIImage *)image radius:(CGFloat)radius size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [[UIBezierPath bezierPathWithRoundedRect:(CGRect){CGPointZero, size} cornerRadius:radius] addClip];
    [image drawInRect:(CGRect){CGPointZero, size}];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)roundCorneredImageWithImage:(UIImage *)image radius:(CGFloat)radius {
    return [self roundCorneredImageWithImage:image radius:radius size:image.size];
}

@end
