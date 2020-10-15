//
//  WCViewControllerTransitioningTool.h
//  HelloUIViewControllerTransitioningDelegate
//
//  Created by wesley_chen on 2020/10/15.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCViewControllerTransitioningTool : NSObject

+ (BOOL)isPresentingWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext;

+ (UIViewController *)toViewControllerWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext;
+ (UIViewController *)fromViewControllerWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext;

@end

NS_ASSUME_NONNULL_END
