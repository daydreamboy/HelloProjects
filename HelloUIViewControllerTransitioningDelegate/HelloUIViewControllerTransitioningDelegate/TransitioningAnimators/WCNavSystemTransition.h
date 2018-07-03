//
//  WCNavSystemAnimator.h
//  HelloUIViewControllerTransitioningDelegate
//
//  Created by wesley_chen on 2018/7/3.
//  Copyright © 2018 wesley chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCNavSystemTransitionPopAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@end

@interface WCNavSystemTransitionPushAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@end

@interface WCNavSystemTransitionPopInteractor : UIPercentDrivenInteractiveTransition
@property (nonatomic, assign) BOOL interactionInProgress;
@end

@class WCNavSystemTransitionPopInteractor;

@interface UIViewController (NavPopStyleInteractiveAnimator)
@property (nonatomic, strong) WCNavSystemTransitionPopInteractor *interactor;
@end



