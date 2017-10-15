//
//  NavPopStyleAnimator.m
//  HelloUIViewControllerTransitioningDelegate
//
//  Created by wesley chen on 16/7/13.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "NavPopStyleAnimator.h"

@implementation NavPopStyleAnimator

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.35f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // get from/to viewController and containerView
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    // prepare frame before animation
    CGRect toViewControllerEndFrame = [transitionContext finalFrameForViewController:toViewController];
    CGRect toViewControllerBeginFrame = CGRectOffset(toViewControllerEndFrame, -toViewControllerEndFrame.size.width / 4.0, 0);
    
    CGRect fromViewControllerBeginFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect fromViewControllerEndFrame = CGRectOffset(fromViewControllerBeginFrame, screenSize.width, 0);
    
    // add toViewController's view
    toViewController.view.frame = toViewControllerBeginFrame;
    toViewController.view.alpha = 0.8f;
    [containerView addSubview:toViewController.view];
    [containerView bringSubviewToFront:fromViewController.view];
    
    // determine animation curve by `isInteractive`
    UIViewAnimationOptions options = [transitionContext isInteractive] ? UIViewAnimationOptionCurveLinear : UIViewAnimationOptionCurveEaseOut;
    
    // execute animation
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                          delay:0
                        options:options | UIViewAnimationOptionOverrideInheritedOptions | UIViewAnimationOptionTransitionNone
                     animations:^{
        toViewController.view.alpha = 1.0f;
        toViewController.view.frame = toViewControllerEndFrame;

        fromViewController.view.frame = fromViewControllerEndFrame;
    }
                     completion:^(BOOL finished) {
        NSLog(@"Pop completion: %@", ![transitionContext transitionWasCancelled] ? @"YES" : @"NO");
        // restore original status of the removing view controller
        fromViewController.view.frame = fromViewControllerBeginFrame;

        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
