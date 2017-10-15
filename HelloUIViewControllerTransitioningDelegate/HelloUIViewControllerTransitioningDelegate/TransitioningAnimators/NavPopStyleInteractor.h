//
//  NavPopStyleInteractiveAnimator.h
//  HelloUIViewControllerTransitioningDelegate
//
//  Created by wesley chen on 16/7/13.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NavPopStyleInteractor;

@interface UIViewController (NavPopStyleInteractiveAnimator)
@property (nonatomic, strong) NavPopStyleInteractor *interactor;
@end

@interface NavPopStyleInteractor : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL interactionInProgress;

@end
