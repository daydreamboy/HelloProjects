//
//  NavPushStyleAnimator.m
//  HelloUIViewControllerTransitioningDelegate
//
//  Created by wesley chen on 16/7/13.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "NavPushStyleAnimator.h"

// @sa https://developer.apple.com/library/ios/featuredarticles/ViewControllerPGforiPhoneOS/PresentingaViewController.html#//apple_ref/doc/uid/TP40007457-CH14-SW1
@implementation NavPushStyleAnimator

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    // @sa http://stackoverflow.com/questions/7609072/how-long-is-the-animation-of-the-transition-between-views-on-a-uinavigationcontr
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
    CGRect toViewControllerBeginFrame = CGRectOffset(toViewControllerEndFrame, screenSize.width, 0);
    
    CGRect fromViewControllerBeginFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect fromViewControllerEndFrame = CGRectOffset(fromViewControllerBeginFrame, -fromViewControllerBeginFrame.size.width / 4.0, 0);

    // add toViewController's view
    toViewController.view.frame = toViewControllerBeginFrame;
    [containerView addSubview:toViewController.view];

    // execute animation
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        fromViewController.view.alpha = 0.8f;
        fromViewController.view.frame = fromViewControllerEndFrame;

        toViewController.view.frame = toViewControllerEndFrame;
    }
                     completion:^(BOOL finished) {
        NSLog(@"Push completion");
        // restore original status of the removing view controller
        fromViewController.view.alpha = 1.0f;
        fromViewController.view.frame = fromViewControllerBeginFrame;

        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
