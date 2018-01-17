//
//  GradientView.m
//  HelloGradient
//
//  Created by wesley chen on 15/1/5.
//  Copyright (c) 2015年 wesley chen. All rights reserved.
//

#import "GradientView.h"

@interface GradientView ()
@property (nonatomic, assign) CGGradientRef gradient;
@end

@implementation GradientView

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGGradientRef gradient = [self gradient];
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(self.bounds), 0.0); //CGPointMake(0.0, 0.0);
    CGPoint endPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));//CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds));
    
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
}

- (CGGradientRef)gradient {
    if (NULL == _gradient) {
        CGFloat colors[6] = {
            138.0f / 255.0f, 1.0f,
            162.0f / 255.0f, 1.0f,
            206.0f / 255.0f, 1.0f,
        };
        CGFloat locations[3] = { 0.05f, 0.45f, 0.95f };
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        _gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, 3);
        
        CGColorSpaceRelease(colorSpace);
    }
    return _gradient;
}


@end
