//
//  UseUIPanGestureRecognizer3ViewController.m
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2020/7/25.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseUIPanGestureRecognizer3ViewController.h"
#import "WCViewTool.h"

@interface UseUIPanGestureRecognizer3ViewController ()
@property (nonatomic, strong) UIView *viewCircle;
@property (nonatomic, strong) UIView *viewRestricted;
@property (nonatomic, assign) CGPoint center;
@end

@implementation UseUIPanGestureRecognizer3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.viewRestricted];
    [self.viewRestricted addSubview:self.viewCircle];
}

#pragma mark - Getter

- (UIView *)viewRestricted {
    if (!_viewRestricted) {
        CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        
        CGSize size = CGRectInset(self.view.bounds, 20, 30).size;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, startY + 30, size.width, size.height - startY)];
        view.layer.borderColor = [UIColor redColor].CGColor;
        view.layer.borderWidth = 1;
        view.clipsToBounds = YES;
        
        _viewRestricted = view;
    }
    
    return _viewRestricted;
}

- (UIView *)viewCircle {
    if (!_viewCircle) {
        CGFloat side = 50.0;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, side, side)];
        view.layer.cornerRadius = side / 2.0;
        view.center = CGPointMake(CGRectGetWidth(_viewRestricted.bounds) / 2.0, CGRectGetHeight(_viewRestricted.bounds) / 2.0);
        view.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.8];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewPanned:)];
        [view addGestureRecognizer:panGesture];
        
        _viewCircle = view;
    }
    
    return _viewCircle;
}

#pragma mark - Actions

- (void)viewPanned:(UIPanGestureRecognizer *)recognizer {
    UIView *targetView = recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:targetView];
        CGPoint translation2 = [recognizer translationInView:targetView.superview];
        CGPoint translation3 = [recognizer translationInView:self.view];
        NSLog(@"translation1: %@", NSStringFromCGPoint(translation));
        NSLog(@"translation2: %@", NSStringFromCGPoint(translation2));
        NSLog(@"translation3: %@", NSStringFromCGPoint(translation3));
        targetView.center = CGPointMake(targetView.center.x + translation.x, targetView.center.y + translation.y);
        [recognizer setTranslation:CGPointZero inView:self.view];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        NSLog(@"start");
        UIView *clippingView = [WCViewTool clippingParentViewWithView:self.viewCircle];
        
        NSLog(@"over");
        CGRect clippingFrame = [clippingView convertRect:clippingView.bounds toView:self.viewCircle.superview];
        if (CGRectContainsRect(clippingFrame, self.viewCircle.frame)) {
            NSLog(@"YES1: %@", NSStringFromCGRect(clippingFrame));
            NSLog(@"YES2: %@", NSStringFromCGRect(self.viewCircle.frame));
        }
        else {
            NSLog(@"NO1: %@", NSStringFromCGRect(clippingFrame));
            NSLog(@"NO2: %@", NSStringFromCGRect(self.viewCircle.frame));
            
            CGFloat x = self.viewCircle.frame.origin.x;
            CGFloat y = self.viewCircle.frame.origin.y;
            CGRect frame = self.viewCircle.frame;
            
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
                self.viewCircle.frame = newFrame;
            } completion:^(BOOL finished) {
            }];
        }
    }
}

@end
