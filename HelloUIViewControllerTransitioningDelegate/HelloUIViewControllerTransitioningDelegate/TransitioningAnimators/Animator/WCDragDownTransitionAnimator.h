//
//  WCDragDownTransitionAnimator.h
//  HelloUIViewControllerTransitioningDelegate
//
//  Created by wesley_chen on 2020/10/14.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCDragDownTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning>

@property (nonatomic, assign, readonly) CGRect fromRect;

@property (nonatomic, assign) NSTimeInterval transitionInDuration;
@property (nonatomic, assign) NSTimeInterval transitionOutDuration;

- (instancetype)initWithFromRect:(CGRect)fromRect presentedViewController:(UIViewController *)presentedViewController;

- (BOOL)enableInteractorOnView:(UIView *)view;

- (id<UIViewControllerInteractiveTransitioning>)handleInteractionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator;

@end

NS_ASSUME_NONNULL_END
