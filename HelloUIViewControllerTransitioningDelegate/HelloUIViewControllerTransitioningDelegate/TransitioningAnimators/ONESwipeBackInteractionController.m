//
//  MLSSwipeBackInteractionController.m
//  Meilishuo
//
//  Created by wanghai on 14-9-23.
//  Copyright (c) 2014年 Meilishuo, Inc. All rights reserved.
//

#import "ONESwipeBackInteractionController.h"

@interface ONESwipeBackInteractionController ()<UIGestureRecognizerDelegate>

@end

@implementation ONESwipeBackInteractionController{
    BOOL _shouldCompleteTransition;
    BOOL _gestureChanged;
    UIViewController *_parentViewController;
//    UIPanGestureRecognizer *_gesture;
    __weak id<ONEGestureBackInteractionDelegate> _gestureBackInteractionDelegate;
    __weak UINavigationController *_currentNavigationController;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        _forNavivationController = NO;
        _gestureChanged = NO;
    }
    return self;
}

-(void)setGestureBackInteractionDelegate:(id<ONEGestureBackInteractionDelegate>) gestureBackInteractionDelegate{
    _gestureBackInteractionDelegate = gestureBackInteractionDelegate;
}

- (void)wireToViewController:(UIViewController *)viewController {
    _parentViewController = viewController;
    
    [self prepareGestureRecognizerInView:viewController.view];
}


- (void)prepareGestureRecognizerInView:(UIView*)view {
    UIScreenEdgePanGestureRecognizer* gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    gesture.edges = UIRectEdgeLeft;
//    gesture.forNavigationController = _forNavivationController;
    [view addGestureRecognizer:gesture];
//    gesture.delegate = self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (CGFloat)completionSpeed
{
    double speed = 1 - self.percentComplete;
    if (speed>1) {
        speed = 1;
    }
    return speed;
}

- (void)handleGesture:(UIPanGestureRecognizer*)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.interactionInProgress = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_parentViewController dismissViewControllerAnimated:YES completion:nil];
            });
            
            break;
        }
        case UIGestureRecognizerStateChanged: {
            _gestureChanged = YES;
            CGFloat fraction = (translation.x / [UIScreen mainScreen].bounds.size.width);
            fraction = fminf(fmaxf(fraction, 0.0), 1.0);
            
            _shouldCompleteTransition = (fraction > 0.5);
           
            [self updateInteractiveTransition:fraction];
//            NSLog(@"pan gesture going %f",fraction);
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:{
            self.interactionInProgress = NO;
            
            if([gestureRecognizer velocityInView:gestureRecognizer.view.superview].x>100){//手势速度大于阀值则判断为手势成功，目前阀值设置为100
                _shouldCompleteTransition = YES;
            }
            if (!_shouldCompleteTransition || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];

                _gestureChanged = NO;
//                NSLog(@"pan gesture cancelled");
                
            }
            else {
//                UIViewController* parentViewController = [gestureRecognizer.view firstAvailableUIViewController];
                //如果设置了delegate，则回调之；否则自动查找并调用backButtonPressed方法
                [self finishInteractiveTransition];
                
//                NSLog(@"pan gesture finished");
            }
            break;
        }
        default:
            break;
    }
}
@end
