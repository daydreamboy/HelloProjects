//
//  WCViewControllerTransitioningTool.m
//  HelloUIViewControllerTransitioningDelegate
//
//  Created by wesley_chen on 2020/10/15.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import "WCViewControllerTransitioningTool.h"

@implementation WCViewControllerTransitioningTool

+ (BOOL)isPresentingWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    // get from/to viewController and containerView
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    const BOOL isUnwinding = [toViewController presentedViewController] == fromViewController;
    const BOOL isPresenting = !isUnwinding;
    
    return isPresenting;
}

+ (UIViewController *)toViewControllerWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    return toViewController;
}

+ (UIViewController *)fromViewControllerWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    return fromViewController;
}

@end
