//
//  NavPopStyleInteractiveAnimator.m
//  HelloUIViewControllerTransitioningDelegate
//
//  Created by wesley chen on 16/7/13.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "NavPopStyleInteractor.h"

// @sa http://stackoverflow.com/questions/29290313/in-ios-how-to-drag-down-to-dismiss-a-modal
@interface NavPopStyleInteractor ()
@property (nonatomic, assign) BOOL shouldCompleteTransition;
@property (nonatomic, strong) UIViewController *presentedViewController;
@end

@implementation NavPopStyleInteractor

- (void)setPresentedViewController:(UIViewController *)presentedViewController {
    _presentedViewController = presentedViewController;
    [self prepareGestureRecognizerInView:presentedViewController.view];
}

- (void)prepareGestureRecognizerInView:(UIView *)view {
    UIScreenEdgePanGestureRecognizer *gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    gesture.edges = UIRectEdgeLeft; // 20 points at left
    [view addGestureRecognizer:gesture];
}

#pragma mark

- (UIViewAnimationCurve)completionCurve {
    return UIViewAnimationCurveLinear;
}

- (CGFloat)completionSpeed {
    NSLog(@"percentComplete: %f", self.percentComplete);
    double speed = 1 - self.percentComplete;
    if (speed>1) {
        speed = 1;
    }
    return speed;
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    CGPoint location = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    NSLog(@"translation: %@", NSStringFromCGPoint(translation));
    NSLog(@"location: %@", NSStringFromCGPoint(location));
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"UIGestureRecognizerStateBegan");
            // 1. Start an interactive transition!
            self.interactionInProgress = YES;
            [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
            break;
            
        case UIGestureRecognizerStateChanged: {
            // 2. compute the current position
            
            CGSize screenSize = [[UIScreen mainScreen] bounds].size;
            NSLog(@"screenSize: %@", NSStringFromCGSize(screenSize));
            
//            CGFloat fraction = (translation.x / screenSize.width);
            NSLog(@"x: %f", translation.x);
            CGFloat fraction = (translation.x / screenSize.width);
            NSLog(@"fraction1: %f", (location.x / screenSize.width));
            NSLog(@"fraction2: %f", (translation.x / screenSize.width));
            fraction = fminf(fmaxf(fraction, 0.0), 1.0);
            
            // 3. should we complete?
            self.shouldCompleteTransition = (fraction > 0.5);
            
            // 4. update the animation
            [self updateInteractiveTransition:fraction];
            
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            // 5. finish or cancel
            self.interactionInProgress = NO;
            if (!self.shouldCompleteTransition || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            }
            else {
                [self finishInteractiveTransition];
            }
            break;
            
        default:
            break;
    }
}

@end

@implementation UIViewController (NavPopStyleInteractiveAnimator)

@dynamic interactor;

- (void)setInteractor:(NavPopStyleInteractor *)interactor {
    interactor.presentedViewController = self;
}

@end
