//
//  WCNavSystemAnimator.m
//  HelloUIViewControllerTransitioningDelegate
//
//  Created by wesley_chen on 2018/7/3.
//  Copyright © 2018 wesley chen. All rights reserved.
//

#import "WCNavSystemTransition.h"

// >= `13.0`
#ifndef IOS13_OR_LATER
#define IOS13_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"13.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@interface WCNavSystemPopTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@end

@implementation WCNavSystemPopTransitionAnimator

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

@interface WCNavSystemPushTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@end

// @sa http://stackoverflow.com/questions/29290313/in-ios-how-to-drag-down-to-dismiss-a-modal
@interface WCNavSystemPopTransitionInteractor ()
@property (nonatomic, assign) BOOL shouldCompleteTransition;
@property (nonatomic, weak) UIViewController *presentedViewController;
@end

@implementation WCNavSystemPopTransitionInteractor

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

// @sa https://developer.apple.com/library/ios/featuredarticles/ViewControllerPGforiPhoneOS/PresentingaViewController.html#//apple_ref/doc/uid/TP40007457-CH14-SW1
@implementation WCNavSystemPushTransitionAnimator

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

@implementation UIViewController (NavPopStyleInteractiveAnimator)

@dynamic navSystemPopInteractor;

- (void)setNavSystemPopInteractor:(WCNavSystemPopTransitionInteractor *)interactor {
    interactor.presentedViewController = self;
}

@end

@implementation WCNavSystemTransition

#pragma mark - In/Out Transition

+ (WCNavSystemPushTransitionAnimator *)navSystemPushTransitionAnimator {
    return [WCNavSystemPushTransitionAnimator new];
}

+ (WCNavSystemPopTransitionAnimator *)navSystemPopTransitionAnimator {
    return [WCNavSystemPopTransitionAnimator new];
}

#pragma mark - Out Interactor

+ (WCNavSystemPopTransitionInteractor *)navSystemPopTransitionInteractor {
    return [WCNavSystemPopTransitionInteractor new];
}

@end
