//
//  CustomImageView.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 15/1/24.
//  Copyright (c) 2015年 wesley_chen. All rights reserved.
//

#import "DrawedImageView.h"

@implementation DrawedImageView

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _image = image;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [[UIColor brownColor] setFill];
    
    // A retangle
    //UIRectFill(rect);
    
    // A retangle with rounded corner
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:30];
	[path fillWithBlendMode:kCGBlendModeNormal alpha:1.0f];
    
    [_image drawInRect:rect];
}

@end
