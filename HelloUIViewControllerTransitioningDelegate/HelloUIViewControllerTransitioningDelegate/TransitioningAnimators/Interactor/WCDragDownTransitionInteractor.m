//
//  WCDragDownTransitionInteractor.m
//  HelloUIViewControllerTransitioningDelegate
//
//  Created by wesley_chen on 2020/10/15.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import "WCDragDownTransitionInteractor.h"

// >= `13.0`
#ifndef IOS13_OR_LATER
#define IOS13_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"13.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@interface WCDragDownTransitionInteractor () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGFloat dragDownOffsetThrottle;
@property (nonatomic, assign) BOOL interactionInProgress;
@property (nonatomic, weak) UIViewController *presentedViewController;
@property (nonatomic, assign) BOOL shouldCompleteTransition;
@end

@implementation WCDragDownTransitionInteractor

- (instancetype)init {
    self = [super init];
    if (self) {
        _dragDownOffsetThrottle = 10;
    }
    return self;
}

#pragma mark - Getter

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
        panGesture.delegate = self;
        
        _panGesture = panGesture;
    }
    
    return _panGesture;
}

- (BOOL)enableInteractorOnView:(UIView *)view {
    view.userInteractionEnabled = YES;
    
    BOOL found = NO;
    for (UIGestureRecognizer *gesture in view.gestureRecognizers) {
        if (gesture == self.panGesture) {
            found = YES;
            break;
        }
    }
    
    if (!found) {
        [view addGestureRecognizer:self.panGesture];
    }
    
    return YES;
}


#pragma mark - Actions

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer {

    UIView *targetView = recognizer.view;
    
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:targetView.superview];
        CGPoint velocity = [recognizer velocityInView:targetView];
        
        // Note: drag down image
        targetView.center = CGPointMake(targetView.center.x + translation.x, targetView.center.y + translation.y);
        [recognizer setTranslation:CGPointZero inView:targetView.superview];
        
        // Note: scale image when drag down
        CGFloat centerYOffset = (targetView.center.y - recognizer.view.superview.bounds.size.height / 2.0);
        CGFloat scale = 1.0 - centerYOffset / (recognizer.view.superview.bounds.size.height / 2.0);
        
        scale = MIN(scale, 1);
        scale = MAX(scale, 0.5);
        
        recognizer.view.transform = CGAffineTransformMakeScale(scale, scale);
    
        // DEBUG: check velocity
        NSLog(@"velocity: %@", NSStringFromCGPoint(velocity));
        
        // @see https://stackoverflow.com/a/5187591
        if (velocity.x > 0) {
            NSLog(@"gesture went right");
        }
        else {
            NSLog(@"gesture went left");
        }
        
        if (velocity.y > 0) {
            NSLog(@"gesture went down");
        }
        else {
            NSLog(@"gesture went up");
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        // @see https://stackoverflow.com/a/13879971
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             recognizer.view.center = CGPointMake(recognizer.view.superview.bounds.size.width / 2.0, recognizer.view.superview.bounds.size.height / 2.0);
                             recognizer.view.transform = CGAffineTransformIdentity;
                         }
                         completion:nil];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    // @see https://stackoverflow.com/a/8603839
    CGPoint velocity = [panGestureRecognizer velocityInView:panGestureRecognizer.view];
    
    // Note: only allow to start to drag down (velocity.y > 0), and velocity angle is down which is < 90°
    return fabs(velocity.y) > fabs(velocity.x) && velocity.y > 0;
}

- (void)attachToPresentedViewController:(UIViewController *)presentedViewController {
    _presentedViewController = presentedViewController;
    
    if (IOS13_OR_LATER) {
        _presentedViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    
    [self prepareGestureRecognizerInView:presentedViewController.view];
}

- (nullable id<UIViewControllerInteractiveTransitioning>)handleInteractionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.interactionInProgress ? self : nil;
}

#pragma mark -

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
    if (speed > 1) {
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
