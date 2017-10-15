//
//  BallDelegate.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 15/4/5.
//  Copyright (c) 2015年 wesley_chen. All rights reserved.
//

#import "BallDelegate.h"

@implementation BallDelegate

@synthesize parent;

#pragma mark - NSObject (CALayerDelegate)

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    CGContextSaveGState(ctx);
    CGRect bounds = layer.bounds;
    
    CGMutablePathRef clipPath = CGPathCreateMutable();
    CGPathAddEllipseInRect(clipPath, NULL, CGRectMake(0.5, 0.5, bounds.size.width - 2 * 0.5, bounds.size.height - 2 * 0.5));
    CGContextAddPath(ctx, clipPath);
    CGContextClip(ctx);
    CGPathRelease(clipPath);
    
    CGGradientRef gradient;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 0.9, 0.1, 0, 1.0, // start color
        0.3, 0.1, 0, 1.0 }; // end color
    
    gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, num_locations);
    
    CGColorSpaceRelease(colorSpace);
    
    CGPoint startPoint, endPoint;
    CGFloat startRadius, endRadius;
    startPoint.x = CGRectGetMidX(bounds) - 12;
    startPoint.y = CGRectGetMidY(bounds) - 10;
    endPoint.x = CGRectGetMidX(bounds);
    endPoint.y = CGRectGetMidY(bounds);
    startRadius = 0;
    endRadius = CGRectGetWidth(bounds) / 2;
    
    CGContextDrawRadialGradient(ctx, gradient, startPoint, startRadius, endPoint, endRadius, 0);
    CGGradientRelease(gradient);
    CGContextRestoreGState(ctx);
}

#pragma mark - NSObject (CAAnimationDelegate)

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    
    // If <animation>.removedOnCompletion = YES, animationForKey: method will return nil
    if (theAnimation == [[parent animatedBall] animationForKey:@"bowl"]) {
        [parent scatterLetters];
    }
    else if (theAnimation == [[parent animatedLetter] animationForKey:@"letterScatted"]) {
        [parent.jumpingText removeTextLayers];
        [parent.jumpingText addTextLayersTo:parent.view.layer];
    }
    else {
        // Ignore other letters' animation finished
    }
}

@end
