//
//  WCTouchIndicatorFingerView.m
//  HelloUIApplication
//
//  Created by wesley_chen on 2021/1/3.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "WCTouchIndicatorFingerView.h"

static CGFloat const ALPHADefaultMaxFingerRadius = 22.0;
static CGFloat const ALPHADefaultForceTouchScale = 0.75;

@interface WCTouchIndicatorFingerView ()
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CATransform3D touchEndTransform;
@property (nonatomic, assign) CGFloat touchEndAnimationDuration;
@property (nonatomic, strong) UITouch *touch;
@property (nonatomic, assign) CGPoint lastScale;
@end

@implementation WCTouchIndicatorFingerView

#pragma mark - Public Methods

- (instancetype)initWithPoint:(CGPoint)point {
    if ((self = [super initWithFrame:CGRectMake(point.x - ALPHADefaultMaxFingerRadius, point.y - ALPHADefaultMaxFingerRadius, 2 * ALPHADefaultMaxFingerRadius, 2 * ALPHADefaultMaxFingerRadius)])) {
        self.opaque = NO;
        
        self.color = [UIColor colorWithRed:0.251f green:0.424f blue:0.502f alpha:1.0f];
        
        self.backgroundColor = [self.color colorWithAlphaComponent:0.4];

        self.layer.cornerRadius = ALPHADefaultMaxFingerRadius;
        self.layer.borderWidth = 2.0f;
        
        self.touchEndAnimationDuration = 0.5f;
        
        self.lastScale = CGPointMake(1.0, 1.0);
        
        self.touchEndTransform = CATransform3DMakeScale(1.5, 1.5, 1);
    }
    
    return self;
}

- (void)updateWithTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self.superview];
    
    self.center = point;
    
    self.lastScale = CGPointMake(MAX(1, touch.force * ALPHADefaultForceTouchScale), MAX(1, touch.force * ALPHADefaultForceTouchScale));
    
    self.transform = CGAffineTransformMakeScale(self.lastScale.x, self.lastScale.y);
    
    CGFloat force = touch.maximumPossibleForce - touch.force;
    
    UIColor *forceColor = [self.class alpha_interpolatedColorFromStartColor:[UIColor redColor] endColor:self.color fraction:force];
    
    self.backgroundColor = [forceColor colorWithAlphaComponent:0.4];
}

#pragma mark -

- (instancetype)initWithFrame:(CGRect)frame {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"-[%@ %@] not supported", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)removeFromSuperview {
    [UIView animateWithDuration:self.touchEndAnimationDuration animations:^{
        self.alpha = 0.0f;
        self.layer.transform = self.touchEndTransform;
    } completion:^(BOOL completed) {
        [super removeFromSuperview];
    }];
}

#pragma mark - Override

- (void)setBackgroundColor:(UIColor *)color {
    [super setBackgroundColor:color];
    
    self.layer.borderColor = [[color colorWithAlphaComponent:0.6f] CGColor];
}

#pragma mark - Utility

+ (UIColor *)alpha_interpolatedColorFromStartColor:(UIColor *)startColor endColor:(UIColor *)endColor fraction:(CGFloat)fraction {
    fraction = MIN(1, MAX(0, fraction));
    
    const CGFloat *c1 = CGColorGetComponents(startColor.CGColor);
    const CGFloat *c2 = CGColorGetComponents(endColor.CGColor);
    
    CGFloat r = c1[0] + (c2[0] - c1[0]) * fraction;
    CGFloat g = c1[1] + (c2[1] - c1[1]) * fraction;
    CGFloat b = c1[2] + (c2[2] - c1[2]) * fraction;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

@end
