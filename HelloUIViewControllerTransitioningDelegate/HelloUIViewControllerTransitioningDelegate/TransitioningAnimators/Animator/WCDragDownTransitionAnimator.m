//
//  WCDragDownTransitionAnimator.m
//  HelloUIViewControllerTransitioningDelegate
//
//  Created by wesley_chen on 2020/10/14.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import "WCDragDownTransitionAnimator.h"
#import "WCViewControllerTransitioningTool.h"

// >= `13.0`
#ifndef IOS13_OR_LATER
#define IOS13_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"13.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@interface WCDragDownTransitionAnimator () <UIGestureRecognizerDelegate>
@property (nonatomic, assign, readwrite) CGRect fromRect;
@property (nonatomic, weak) UIViewController *presentedViewController;
@end

@implementation WCDragDownTransitionAnimator

- (instancetype)initWithFromRect:(CGRect)fromRect presentedViewController:(UIViewController *)presentedViewController {
    self = [super init];
    if (self) {
        _fromRect = fromRect;
        _presentedViewController = presentedViewController;
        
        if (IOS13_OR_LATER) {
            _presentedViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        }
        
        // Default
        _transitionInDuration = 0.2;
        _transitionOutDuration = 0.2;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    BOOL isPresenting = [WCViewControllerTransitioningTool isPresentingWithTransitionContext:transitionContext];
    
    return isPresenting ? self.transitionInDuration : self.transitionOutDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // get from/to viewController and containerView
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    const BOOL isUnwinding = [toViewController presentedViewController] == fromViewController;
    const BOOL isPresenting = !isUnwinding;
    
    UIViewController *presentingController = isPresenting ? fromViewController : toViewController;
    UIViewController *presentedController = isPresenting ? toViewController : fromViewController;
    
    UIView *containerView = [transitionContext containerView];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    CGFloat scale = CGRectGetWidth(self.fromRect) / (CGFloat)screenSize.width;
    
    if (isPresenting) {
        // Note: to show
        
        presentedController.view.center = CGPointMake(CGRectGetMidX(self.fromRect),CGRectGetMidY(self.fromRect));
        presentedController.view.transform = CGAffineTransformMakeScale(scale, scale);
        presentedController.view.backgroundColor = [UIColor clearColor];
        [containerView addSubview:presentedController.view];
        
        // execute animation
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             presentingController.view.alpha = 0;
                             
                             presentedController.view.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
                             presentedController.view.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             NSLog(@"Show completion");
                             
                             presentingController.view.alpha = 1.0f;
                             presentedController.view.backgroundColor = [UIColor blackColor];
                             
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         }];
    }
    else {
        // Note: to dimiss
        
        presentedController.view.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
        presentedController.view.transform = CGAffineTransformIdentity;
        presentedController.view.backgroundColor = [UIColor clearColor];
        
        [containerView addSubview:presentingController.view];
        [containerView bringSubviewToFront:presentedController.view];
        presentingController.view.alpha = 0;
        
        // execute animation
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             presentedController.view.center = CGPointMake(CGRectGetMidX(self.fromRect),CGRectGetMidY(self.fromRect));
                             presentedController.view.transform = CGAffineTransformMakeScale(scale, scale);
                             
                             presentingController.view.alpha = 1;
                         }
                         completion:^(BOOL finished) {
                             NSLog(@"Dismiss completion");
                             
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         }];
    }
}

#pragma mark - UIViewControllerInteractiveTransitioning

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
}

- (BOOL)wantsInteractiveStart {
    return YES;
}

- (UIViewAnimationCurve)completionCurve {
    return UIViewAnimationCurveEaseInOut;
}

- (CGFloat)completionSpeed {
    return 1.0;
}

@end
