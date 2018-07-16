//
//  MPMLightPopoverView.m
//
//
//  Created by wesley chen on 2017/6/14.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import "MPMLightPopoverView.h"

#define kBoxPadding 10.f
//Height/width of the actual arrow
#define kArrowHeight 12.f
#define kArrowHalfWidth  8.f


//control point offset for rounding corners of the main popover box
#define kCPOffset 1.8f

//radius for the rounded corners of the main popover box
#define kBoxRadius 4.f

//Curvature value for the arrow.  Set to 0.f to make it linear.
#define kArrowCurvature 0.f

//Minimum distance from the side of the arrow to the beginning of curvature for the box
#define kArrowHorizontalPadding 5.f

//Alpha value for the shadow behind the YWPopoverView
#define kShadowAlpha 0.5f

//Blur for the shadow behind the YWPopoverView
#define kShadowBlur 4.f;

//Box gradient bg alpha
#define kBoxAlpha 0.95f

//Padding along top of screen to allow for any nav/status bars
#define kTopMargin 50.f

//margin along the left and right of the box
#define kHorizontalMargin 10.f

//padding along top of icons/images
#define kImageTopPadding 3.f

//padding along bottom of icons/images
#define kImageBottomPadding 3.f

//#define kGradientBottomColor  [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:0.50]
//#define kGradientTopColor  [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:0.50]

#define kGradientBottomColor        [UIColor colorWithWhite:1.0 alpha:1.0]
#define kGradientTopColor           [UIColor colorWithWhite:1.0 alpha:1.0]


#define kDividerColor [UIColor colorWithRed:0.329 green:0.341 blue:0.353 alpha:0.15f]

#define CFTYPECAST(exp) (__bridge exp)

@implementation MPMLightPopoverViewDescriptor
- (instancetype)init {
    self = [super init];
    if (self) {
        _showDuration = 0.2;
        _dismissDuration = 0.3;
    }
    return self;
}
@end


@interface MPMLightPopoverView()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *parentView;

@property (nonatomic, assign) CGPoint arrowPoint;

@property (nonatomic, assign) CGRect boxFrame;

@property (nonatomic, strong) MPMLightPopoverViewDescriptor *descriptor;

@end

@implementation MPMLightPopoverView

#pragma mark - Public Methods

+ (MPMLightPopoverView *)showAlwaysAbovePopoverAtPoint:(CGPoint)point inView:(UIView *)view withContentView:(UIView *)cView {
    MPMLightPopoverView *popoverView = [[MPMLightPopoverView alloc] initWithFrame:CGRectZero];
    popoverView.backgroundColor = [UIColor clearColor];
    [popoverView showAtPoint:point inView:view withContentView:cView];
    return popoverView;
}

+ (MPMLightPopoverView *)showAlwaysAbovePopoverAtPoint:(CGPoint)point inView:(UIView *)view withContentView:(UIView *)cView withDescriptor:(MPMLightPopoverViewDescriptor *)descriptor {
    MPMLightPopoverView *popoverView = [[MPMLightPopoverView alloc] initWithFrame:CGRectZero];
    popoverView.backgroundColor = [UIColor clearColor];
    popoverView.descriptor = descriptor;
    [popoverView showAtPoint:point inView:view withContentView:cView];
    return popoverView;
}

- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withContentView:(UIView *)cView {
    self.contentView = cView;
    self.parentView = view;
    
    [self setupLayout:point inView:view];
    
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

- (void)setupLayout:(CGPoint)point inView:(UIView*)view
{
    self.arrowPoint = point;
    
    //NSLog(@"arrowPoint:%f,%f", arrowPoint.x, arrowPoint.y);
    
    CGRect topViewBounds = view.bounds;
    //NSLog(@"topViewBounds %@", NSStringFromCGRect(topViewBounds));
    
    float contentHeight = self.contentView.frame.size.height;
    float contentWidth = self.contentView.frame.size.width;
    
    float padding = self.descriptor ? self.descriptor.boxPadding : kBoxPadding;
    
    float boxHeight = contentHeight + 2.f*padding;
    float boxWidth = contentWidth + 2.f*padding;
    
    float xOrigin = 0.f;
    
    //Make sure the arrow point is within the drawable bounds for the popover.
    float arrowHalfWidth = self.descriptor.arrowWidth ? self.descriptor.arrowWidth / 2.0 : kArrowHalfWidth;
    if (point.x + arrowHalfWidth > topViewBounds.size.width - kHorizontalMargin - kBoxRadius - kArrowHorizontalPadding) {//Too far to the right
        point.x = topViewBounds.size.width - kHorizontalMargin - kBoxRadius - kArrowHorizontalPadding - arrowHalfWidth;
        //NSLog(@"Correcting Arrow Point because it's too far to the right");
    } else if (point.x - arrowHalfWidth < kHorizontalMargin + kBoxRadius + kArrowHorizontalPadding) {//Too far to the left
        point.x = kHorizontalMargin + arrowHalfWidth + kBoxRadius + kArrowHorizontalPadding;
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
    
    float arrowHeight = self.descriptor.arrowHeight ? self.descriptor.arrowHeight : kArrowHeight;
    
    self.boxFrame = CGRectMake(xOrigin, point.y - arrowHeight - boxHeight, boxWidth, boxHeight);
    CGRect contentFrame = CGRectMake(self.boxFrame.origin.x + padding, self.boxFrame.origin.y + padding, contentWidth, contentHeight);
    self.contentView.frame = contentFrame;
    
    //We set the anchorPoint here so the popover will "grow" out of the arrowPoint specified by the user.
    //You have to set the anchorPoint before setting the frame, because the anchorPoint property will
    //implicitly set the frame for the view, which we do not want.
    self.layer.anchorPoint = CGPointMake(point.x / topViewBounds.size.width, point.y / topViewBounds.size.height);
    self.frame = topViewBounds;
    [self setNeedsDisplay];
    
    [self addSubview:self.contentView];
    [view addSubview:self];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    // Build the popover path
    CGRect frame = self.boxFrame;
    
    float xMin = CGRectGetMinX(frame);
    float yMin = CGRectGetMinY(frame);
    
    float xMax = CGRectGetMaxX(frame);
    float yMax = CGRectGetMaxY(frame);
    
    float radius = kBoxRadius; //Radius of the curvature.
    
    float cpOffset = kCPOffset; //Control Point Offset.  Modifies how "curved" the corners are.
    float arrowHalfWidth = self.descriptor.arrowWidth ? self.descriptor.arrowWidth / 2.0 : kArrowHalfWidth;
    
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
    [popoverPath addCurveToPoint:CGPointMake(xMin + radius, yMin) controlPoint1:CGPointMake(xMin, yMin + radius - cpOffset) controlPoint2:CGPointMake(xMin + radius - cpOffset, yMin)];//LT2
    
    [popoverPath addLineToPoint:CGPointMake(xMax - radius, yMin)];//RT1
    [popoverPath addCurveToPoint:CGPointMake(xMax, yMin + radius) controlPoint1:CGPointMake(xMax - radius + cpOffset, yMin) controlPoint2:CGPointMake(xMax, yMin + radius - cpOffset)];//RT2
    [popoverPath addLineToPoint:CGPointMake(xMax, yMax - radius)];//RB1
    [popoverPath addCurveToPoint:CGPointMake(xMax - radius, yMax) controlPoint1:CGPointMake(xMax, yMax - radius + cpOffset) controlPoint2:CGPointMake(xMax - radius + cpOffset, yMax)];//RB2
    
    [popoverPath addLineToPoint:CGPointMake(self.arrowPoint.x + arrowHalfWidth, yMax)];//right side
    [popoverPath addCurveToPoint:self.arrowPoint controlPoint1:CGPointMake(self.arrowPoint.x + arrowHalfWidth - kArrowCurvature, yMax) controlPoint2:self.arrowPoint];//arrow point
    [popoverPath addCurveToPoint:CGPointMake(self.arrowPoint.x - arrowHalfWidth, yMax) controlPoint1:self.arrowPoint controlPoint2:CGPointMake(self.arrowPoint.x - arrowHalfWidth + kArrowCurvature, yMax)];
    
    [popoverPath addLineToPoint:CGPointMake(xMin + radius, yMax)];//LB1
    [popoverPath addCurveToPoint:CGPointMake(xMin, yMax - radius) controlPoint1:CGPointMake(xMin + radius - cpOffset, yMax) controlPoint2:CGPointMake(xMin, yMax - radius + cpOffset)];//LB2
    [popoverPath closePath];
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Shadow Declarations
    UIColor* shadow = [UIColor colorWithWhite:207./255 alpha:kShadowAlpha];
    CGSize shadowOffset = CGSizeMake(0, 2);
    CGFloat shadowBlurRadius = kShadowBlur;
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)kGradientTopColor.CGColor,
                               (id)kGradientBottomColor.CGColor, nil];
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFTYPECAST(CFArrayRef)gradientColors), gradientLocations);
    
    
    //These floats are the top and bottom offsets for the gradient drawing so the drawing includes the arrows.
    float bottomOffset = self.descriptor.arrowHeight ? self.descriptor.arrowHeight : kArrowHeight;
    float topOffset = 0.f;
    
    //Draw the actual gradient and shadow.
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    CGContextBeginTransparencyLayer(context, NULL);
    [popoverPath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame) - topOffset), CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame) + bottomOffset), 0);
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
    
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
        [UIView animateWithDuration:self.descriptor.dismissDuration ?: 0.3f animations:^{
            self.alpha = 0.1f;
            self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        } completion:^(BOOL finished) {
            self.hidden = YES;
            [self removeFromSuperview];
        }];
    }
}

@end
