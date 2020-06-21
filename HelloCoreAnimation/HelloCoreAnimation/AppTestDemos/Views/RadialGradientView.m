//
//  RadialGradientView.m
//  HelloGradient
//
//  Created by wesley chen on 16/6/1.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "RadialGradientView.h"

@implementation RadialGradientView

- (void)drawRect:(CGRect)rect {
    // @sa http://stackoverflow.com/questions/8125623/how-do-i-add-a-radial-gradient-to-a-uiview
    
    // Setup view
    CGFloat colorComponents[] = {0.0, 0.0, 0.0, 1.0,   // First color:  R, G, B, ALPHA (currently opaque black)
        0.0, 0.0, 0.0, 0.0};  // Second color: R, G, B, ALPHA (currently transparent black)
    CGFloat locations[] = {0, 1}; // {0, 1) -> from center to outer edges, {1, 0} -> from outer edges to center
    CGFloat radius = MIN((self.bounds.size.height / 2), (self.bounds.size.width / 2));
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    // Prepare a context and create a color space
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create gradient object from our color space, color components and locations
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colorComponents, locations, 2);
    
    // Draw a gradient
    CGContextDrawRadialGradient(context, gradient, center, 0.0, center, radius, 0);
    CGContextRestoreGState(context);
    
    // Release objects
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
}

@end
