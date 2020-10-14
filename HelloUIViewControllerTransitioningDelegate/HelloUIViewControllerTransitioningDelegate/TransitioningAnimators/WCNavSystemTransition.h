//
//  WCNavSystemAnimator.h
//  HelloUIViewControllerTransitioningDelegate
//
//  Created by wesley_chen on 2018/7/3.
//  Copyright © 2018 wesley chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCNavSystemPopTransitionInteractor : UIPercentDrivenInteractiveTransition
@property (nonatomic, assign) BOOL interactionInProgress;

- (void)attachToPresentedViewController:(UIViewController *)presentedViewController;
- (nullable id<UIViewControllerInteractiveTransitioning>)handleInteractionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator;

@end

@class WCNavSystemPopTransitionInteractor;

@interface UIViewController (NavPopStyleInteractiveAnimator)
@property (nonatomic, strong) WCNavSystemPopTransitionInteractor *navSystemPopInteractor;
@end

@interface WCNavSystemTransition : NSObject

#pragma mark - In/Out Transition

+ (id<UIViewControllerAnimatedTransitioning>)navSystemPushTransitionAnimator;
+ (id<UIViewControllerAnimatedTransitioning>)navSystemPopTransitionAnimator;

#pragma mark - Out Interactor

+ (WCNavSystemPopTransitionInteractor *)navSystemPopTransitionInteractor;

@end

NS_ASSUME_NONNULL_END

