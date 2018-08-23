//
//  WCNavSystemAnimator.h
//  HelloUIViewControllerTransitioningDelegate
//
//  Created by wesley_chen on 2018/7/3.
//  Copyright © 2018 wesley chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCNavSystemPopTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@end

@interface WCNavSystemPushTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@end

@interface WCNavSystemPopTransitionInteractor : UIPercentDrivenInteractiveTransition
@property (nonatomic, assign) BOOL interactionInProgress;
@end

@class WCNavSystemPopTransitionInteractor;

@interface UIViewController (NavPopStyleInteractiveAnimator)
@property (nonatomic, strong) WCNavSystemPopTransitionInteractor *interactor;
@end



