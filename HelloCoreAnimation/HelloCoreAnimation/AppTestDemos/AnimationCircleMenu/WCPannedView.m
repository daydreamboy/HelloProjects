//
//  WCPannedView.m
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2020/7/26.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCPannedView.h"
#import "WCViewTool.h"

@interface WCPannedView ()
@property (nonatomic, strong, readwrite) UIView *contentView;
@property (nonatomic, strong, readwrite) UIView *backgroundView;
@property (nonatomic, strong, readwrite) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong, readwrite) UITapGestureRecognizer *tapGesture;
@end

@implementation WCPannedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        _scaleFactorWhenHolding = 1.5;
        
        [self addSubview:_backgroundView];
        [self addSubview:_contentView];
    }
    
    return self;
}

#pragma mark - Public

- (void)addToView:(UIView *)view {
    if (self.superview == nil || self.superview != view) {
        if (self.panGesture) {
            [self.superview removeGestureRecognizer:self.panGesture];
        }
        
        [view addSubview:self];
        
        if (!self.panGesture) {
            UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewPanned:)];
            [self addGestureRecognizer:panGesture];
            self.panGesture = panGesture;
        }
        
        if (!self.tapGesture) {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
            [self addGestureRecognizer:tapGesture];
            self.tapGesture = tapGesture;
        }
    }
}

#pragma mark - Actions

- (void)viewTapped:(UITapGestureRecognizer *)recognizer {
    UIView *targetView = recognizer.view;
    if (targetView == self) {
        if ([self.delegate respondsToSelector:@selector(pannedViewTapped:)]) {
            [self.delegate pannedViewTapped:self];
        }
    }
}

- (void)viewPanned:(UIPanGestureRecognizer *)recognizer {
    UIView *targetView = recognizer.view;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint translation = [recognizer translationInView:targetView];
        targetView.center = CGPointMake(targetView.center.x + translation.x, targetView.center.y + translation.y);
        [recognizer setTranslation:CGPointZero inView:targetView];
        
        if ([self.delegate respondsToSelector:@selector(pannedViewDragBegin:)]) {
            [self.delegate pannedViewDragBegin:self];
        }
        
        if (self.scaleFactorWhenHolding > 0) {
            [UIView animateWithDuration:0.2 animations:^{
                self.backgroundView.transform = CGAffineTransformMakeScale(self.scaleFactorWhenHolding, self.scaleFactorWhenHolding);
            }];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:targetView];
        targetView.center = CGPointMake(targetView.center.x + translation.x, targetView.center.y + translation.y);
        [recognizer setTranslation:CGPointZero inView:targetView];
        
        if ([self.delegate respondsToSelector:@selector(pannedViewDragMoving:)]) {
            [self.delegate pannedViewDragMoving:self];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            if ([self.delegate respondsToSelector:@selector(pannedViewDragEnd:)]) {
                [self.delegate pannedViewDragEnd:self];
            }
        }
        else {
            if ([self.delegate respondsToSelector:@selector(pannedViewDragCanelled:)]) {
                [self.delegate pannedViewDragCanelled:self];
            }
        }
        
        UIView *clippingView = [WCViewTool clippingParentViewWithView:self];
        
        CGRect clippingFrame = [clippingView convertRect:clippingView.bounds toView:self.superview];
        if (CGRectContainsRect(clippingFrame, self.frame)) {
            if (self.scaleFactorWhenHolding > 0) {
                [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.backgroundView.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                }];
            }
        }
        else {
            CGRect frame = self.frame;
            CGFloat x = frame.origin.x;
            CGFloat y = frame.origin.y;
            
            CGFloat newX = x;
            CGFloat newY = y;
            
            if (CGRectGetMinX(frame) < CGRectGetMinX(clippingFrame)) {
                newX = CGRectGetMinX(clippingFrame);
            }
            else if (CGRectGetMaxX(frame) > CGRectGetMaxX(clippingFrame)) {
                newX = CGRectGetMaxX(clippingFrame) - frame.size.width;
            }
            
            if (CGRectGetMinY(frame) < CGRectGetMinY(clippingFrame)) {
                newY = CGRectGetMinY(clippingFrame);
            }
            else if (CGRectGetMaxY(frame) > CGRectGetMaxY(clippingFrame)) {
                newY = CGRectGetMaxY(clippingFrame) - frame.size.height;
            }
            
            CGRect newFrame = frame;
            newFrame.origin.x = newX;
            newFrame.origin.y = newY;
            
            [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.frame = newFrame;
                if (self.scaleFactorWhenHolding > 0) {
                    self.backgroundView.transform = CGAffineTransformIdentity;
                }
            } completion:^(BOOL finished) {
            }];
        }
    }
}

#pragma mark -

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self.touchThroughSubview isKindOfClass:[UIView class]]) {
        // @see https://developer.apple.com/library/archive/qa/qa2013/qa1812.html
        // Convert the point to the target view's coordinate system.
        // The target view isn't necessarily the immediate subview
        CGPoint pointForTargetView = [self.touchThroughSubview convertPoint:point fromView:self];

        if (CGRectContainsPoint(self.touchThroughSubview.bounds, pointForTargetView)) {

            // The target view may have its view hierarchy,
            // so call its hitTest method to return the right hit-test view
            return [self.touchThroughSubview hitTest:pointForTargetView withEvent:event];
        }
    }

    return [super hitTest:point withEvent:event];
}

@end
