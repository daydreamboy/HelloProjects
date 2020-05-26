//
//  WCPopoverView.m
//
//
//  Created by wesley chen on 2017/6/14.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import "WCPopoverView.h"

//control point offset for rounding corners of the main popover box
#define kCPOffset 1.8f

//Curvature value for the arrow.  Set to 0.f to make it linear.
#define kArrowCurvature 0.f

//Minimum distance from the side of the arrow to the beginning of curvature for the box
#define kArrowHorizontalPadding 5.f

//margin along the left and right of the box
#define kHorizontalMargin 10.f

#define CFTYPECAST(exp) (__bridge exp)

@implementation WCPopoverViewDescriptor

- (instancetype)init {
    self = [super init];
    if (self) {
        _showDuration = 0.2;
        _dismissDuration = 0.3;
        _boxInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        _arrowWidth = 16.0;
        _arrowHeight = 12.0;
        _boxCornerRadius = 4.0;
        _boxShadowBlurRadius = 4.0;
        _boxShadowBlurColor = [UIColor colorWithWhite:20 / 255.0 alpha:0.5];
        _boxShadowOffset = CGSizeMake(0, 2.0);
        _boxGradientColors = @[
            [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.95f],
            [UIColor colorWithRed:0.98f green:0.98f blue:0.98f alpha:0.95f]
        ];
        _boxGradientLocations = @[@0, @1];
        _boxGradientStartPoint = CGPointMake(0.5, 0.0);
        _boxGradientEndPoint = CGPointMake(0.5, 1.0);
        _autoDismissAfterSeconds = 3.0;
    }
    return self;
}

- (void)setBoxInsets:(UIEdgeInsets)boxInsets {
    _boxInsets = UIEdgeInsetsMake(MAX(boxInsets.top, 0), MAX(boxInsets.left, 0), MAX(boxInsets.bottom, 0), MAX(boxInsets.right, 0));
}

@end


@interface WCPopoverView()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *parentView;

@property (nonatomic, assign) CGPoint arrowPoint;

@property (nonatomic, assign) CGRect boxFrame;

@property (nonatomic, strong) WCPopoverViewDescriptor *descriptor;

@end

@implementation WCPopoverView

#pragma mark - Public Methods

+ (WCPopoverView *)showPopoverViewAtPoint:(CGPoint)point inView:(UIView *)view contentView:(UIView *)cView {
    WCPopoverView *popoverView = [[WCPopoverView alloc] initWithFrame:CGRectZero];
    popoverView.backgroundColor = [UIColor clearColor];
//    popoverView.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.2];
    [popoverView showAtPoint:point inParentView:view contentView:cView];
    return popoverView;
}

+ (WCPopoverView *)showPopoverViewAtPoint:(CGPoint)point inView:(UIView *)view contentView:(UIView *)cView descriptor:(WCPopoverViewDescriptor *)descriptor {
    WCPopoverView *popoverView = [[WCPopoverView alloc] initWithFrame:CGRectZero];
    popoverView.backgroundColor = [UIColor clearColor];
//    popoverView.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.2];
    popoverView.descriptor = descriptor;
    [popoverView showAtPoint:point inParentView:view contentView:cView];
    return popoverView;
}

//+ (WCPopoverView *)showPopoverViewRelativeToView:(UIView *)view locationInView:(CGPoint)locationInView contentView:(UIView *)contentView descriptor:(WCPopoverViewDescriptor *)descriptor {
//
//
//    CGPoint locationInWindow = [view convertPoint:locationInView toView:view.window];
//
//}

- (void)showAtPoint:(CGPoint)point inParentView:(UIView *)parentView contentView:(UIView *)cView {
    self.contentView = cView;
    self.parentView = parentView;
    
    self.arrowPoint = point;
    
    //NSLog(@"arrowPoint:%f,%f", arrowPoint.x, arrowPoint.y);
    
    CGRect topViewBounds = parentView.bounds;
    //NSLog(@"topViewBounds %@", NSStringFromCGRect(topViewBounds));
    
    float contentHeight = self.contentView.frame.size.height;
    float contentWidth = self.contentView.frame.size.width;
    
    float boxHeight = contentHeight + self.descriptor.boxInsets.top + self.descriptor.boxInsets.bottom;
    float boxWidth = contentWidth + self.descriptor.boxInsets.left + self.descriptor.boxInsets.right;
    
    float xOrigin = 0.f;
    
    //Make sure the arrow point is within the drawable bounds for the popover.
    float arrowHalfWidth = self.descriptor.arrowWidth / 2.0;
    if (point.x + arrowHalfWidth > topViewBounds.size.width - kHorizontalMargin - self.descriptor.boxCornerRadius - kArrowHorizontalPadding) {//Too far to the right
        point.x = topViewBounds.size.width - kHorizontalMargin - self.descriptor.boxCornerRadius - kArrowHorizontalPadding - arrowHalfWidth;
        //NSLog(@"Correcting Arrow Point because it's too far to the right");
    } else if (point.x - arrowHalfWidth < kHorizontalMargin + self.descriptor.boxCornerRadius + kArrowHorizontalPadding) {//Too far to the left
        point.x = kHorizontalMargin + arrowHalfWidth + self.descriptor.boxCornerRadius + kArrowHorizontalPadding;
        //NSLog(@"Correcting Arrow Point because it's too far to the left");
    }
    
    //NSLog(@"arrowPoint:%f,%f", arrowPoint.x, arrowPoint.y);
    
    xOrigin = floorf(point.x - boxWidth*0.5f);
    
    //Check to see if the centered xOrigin value puts the box outside of the normal range.
    if (xOrigin < CGRectGetMinX(topViewBounds) + kHorizontalMargin) {
        xOrigin = CGRectGetMinX(topViewBounds) + kHorizontalMargin;
    } else if (xOrigin + boxWidth > CGRectGetMaxX(topViewBounds) - kHorizontalMargin) {
        //Check to see if the positioning puts the box out of the window towards the left
        xOrigin = CGRectGetMaxX(topViewBounds) - kHorizontalMargin - boxWidth;
    }
    
    float arrowHeight = self.descriptor.arrowHeight;
    
    self.boxFrame = CGRectMake(xOrigin, point.y - arrowHeight - boxHeight, boxWidth, boxHeight);
    CGRect contentFrame = CGRectMake(self.boxFrame.origin.x + self.descriptor.boxInsets.left, self.boxFrame.origin.y + self.descriptor.boxInsets.top, contentWidth, contentHeight);
    self.contentView.frame = contentFrame;
    
    //We set the anchorPoint here so the popover will "grow" out of the arrowPoint specified by the user.
    //You have to set the anchorPoint before setting the frame, because the anchorPoint property will
    //implicitly set the frame for the view, which we do not want.
    self.layer.anchorPoint = CGPointMake(point.x / topViewBounds.size.width, point.y / topViewBounds.size.height);
    self.frame = topViewBounds;
    [self setNeedsDisplay];
    
    [self addSubview:self.contentView];
    self.clipsToBounds = NO;
    [parentView addSubview:self];
    
    // Make the view small and transparent before animation
    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    
    // animate into full size
    // First stage animates to 1.05x normal size, then second stage animates back down to 1x size.
    // This two-stage animation creates a little "pop" on open.
    [UIView animateWithDuration:self.descriptor.showDuration ?: 0.2f  delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1.f;
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (self.descriptor.autoDismissAfterSeconds > 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.descriptor.autoDismissAfterSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismiss:YES];
                });
            }
        }];
    }];
}

- (void)drawRect:(CGRect)rect
{
    // Build the popover path
    CGRect frame = self.boxFrame;
    
    float xMin = CGRectGetMinX(frame);
    float yMin = CGRectGetMinY(frame);
    
    float xMax = CGRectGetMaxX(frame);
    float yMax = CGRectGetMaxY(frame);
    
    float radius = MIN(MAX(self.descriptor.boxCornerRadius, 0), CGRectGetHeight(frame) / 2.0);
    float arrowHalfWidth = self.descriptor.arrowWidth / 2.0;
    
    /*
     LT2            RT1
     LT1⌜⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⌝RT2
     |               |
     |    popover    |
     |               |
     LB2⌞_______________⌟RB1
     LB1           RB2
     
     Traverse rectangle in clockwise order, starting at LT1
     L = Left
     R = Right
     T = Top
     B = Bottom
     1,2 = order of traversal for any given corner
     
     */
    
    UIBezierPath *popoverPath = [UIBezierPath bezierPath];
    [popoverPath moveToPoint:CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame) + radius)];//LT1
    [popoverPath addArcWithCenter:CGPointMake(xMin + radius, yMin + radius) radius:radius startAngle:M_PI endAngle:M_PI * 1.5 clockwise:YES];
    
    [popoverPath addLineToPoint:CGPointMake(xMax - radius, yMin)];//RT1
    [popoverPath addArcWithCenter:CGPointMake(xMax - radius, yMin + radius) radius:radius startAngle:M_PI * 1.5 endAngle:M_PI * 2.0 clockwise:YES];
    
    [popoverPath addLineToPoint:CGPointMake(xMax, yMax - radius)];//RB1
    [popoverPath addArcWithCenter:CGPointMake(xMax - radius, yMax - radius) radius:radius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    
    [popoverPath addLineToPoint:CGPointMake(self.arrowPoint.x + arrowHalfWidth, yMax)];//right side
    [popoverPath addCurveToPoint:self.arrowPoint controlPoint1:CGPointMake(self.arrowPoint.x + arrowHalfWidth - kArrowCurvature, yMax) controlPoint2:self.arrowPoint];//arrow point
    [popoverPath addCurveToPoint:CGPointMake(self.arrowPoint.x - arrowHalfWidth, yMax) controlPoint1:self.arrowPoint controlPoint2:CGPointMake(self.arrowPoint.x - arrowHalfWidth + kArrowCurvature, yMax)];
    
    [popoverPath addLineToPoint:CGPointMake(xMin + radius, yMax)];//LB1
    [popoverPath addArcWithCenter:CGPointMake(xMin + radius, yMax - radius) radius:radius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    
    [popoverPath closePath];
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Shadow Declarations
    UIColor *shadowColor = self.descriptor.boxShadowBlurColor;
    CGSize shadowOffset = self.descriptor.boxShadowOffset;
    CGFloat shadowBlurRadius = self.descriptor.boxShadowBlurRadius;
    
    //// Gradient Declarations
    
    NSMutableArray *gradientColors = [NSMutableArray arrayWithCapacity:self.descriptor.boxGradientColors.count];
    CGGradientRef gradient = NULL;
    
    if (self.descriptor.boxGradientColors.count > 0 &&
        self.descriptor.boxGradientLocations.count > 0 &&
        self.descriptor.boxGradientColors.count == self.descriptor.boxGradientLocations.count) {
        
        for (UIColor *color in self.descriptor.boxGradientColors) {
            if ([color isKindOfClass:[UIColor class]]) {
                [gradientColors addObject:(id)color.CGColor];
            }
        }
        
        CGFloat gradientLocations[self.descriptor.boxGradientLocations.count];
        NSUInteger i = 0;
        for (; i < self.descriptor.boxGradientLocations.count; ++i) {
            NSNumber *location = self.descriptor.boxGradientLocations[i];
            if ([location isKindOfClass:[NSNumber class]]) {
                gradientLocations[i] = [location floatValue];
            }
        }
        
        if (gradientColors.count == i) {
            gradient = CGGradientCreateWithColors(colorSpace, (CFTYPECAST(CFArrayRef)gradientColors), gradientLocations);
        }
    }
    
    //These floats are the top and bottom offsets for the gradient drawing so the drawing includes the arrows.
    float bottomOffset = self.descriptor.arrowHeight;
    
    //Draw the actual gradient and shadow.
    CGContextSaveGState(context);
    
    if (shadowBlurRadius > 0 && [shadowColor isKindOfClass:[UIColor class]]) {
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadowColor.CGColor);
    }
    
    CGContextBeginTransparencyLayer(context, NULL);
    
    [popoverPath addClip];
    
    if (gradient != NULL) {
        CGFloat startPointXRatio = MIN(MAX(self.descriptor.boxGradientStartPoint.x, 0), 1);
        CGFloat startPointYRatio = MIN(MAX(self.descriptor.boxGradientStartPoint.y, 0), 1);
        CGFloat endPointXRatio = MIN(MAX(self.descriptor.boxGradientEndPoint.x, 0), 1);
        CGFloat endPointYRatio = MIN(MAX(self.descriptor.boxGradientEndPoint.y, 0), 1);

        CGPoint startPoint = CGPointMake(CGRectGetMinX(frame) + startPointXRatio * CGRectGetWidth(frame), CGRectGetMinY(frame) + startPointYRatio * (CGRectGetHeight(frame) + bottomOffset));
        CGPoint endPoint = CGPointMake(CGRectGetMinX(frame) + endPointXRatio * CGRectGetWidth(frame), CGRectGetMinY(frame) + endPointYRatio * (CGRectGetHeight(frame) + bottomOffset));
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kNilOptions);
    }
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
    
    if (self.descriptor.borderWidth > 0 && [self.descriptor.borderColor isKindOfClass:[UIColor class]]) {
        [self.descriptor.borderColor setStroke];
        popoverPath.lineWidth = self.descriptor.borderWidth;
        [popoverPath stroke];
    }
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(self.boxFrame, point)) {
        return YES;
    }
    else {
        if (self.descriptor.autoDismissWhenTapOutside) {
            [self dismiss:YES];
        }
        return NO;
    }
}

- (void)dismiss:(BOOL)animated {
    if (!animated) {
        self.hidden = YES;
        [self removeFromSuperview];
    }
    else {
        [UIView animateWithDuration:self.descriptor.dismissDuration animations:^{
            self.alpha = 0.1f;
            self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        } completion:^(BOOL finished) {
            self.hidden = YES;
            [self removeFromSuperview];
        }];
    }
}

@end
