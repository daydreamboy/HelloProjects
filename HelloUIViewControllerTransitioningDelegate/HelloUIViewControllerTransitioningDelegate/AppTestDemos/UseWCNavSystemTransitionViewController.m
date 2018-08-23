//
//  ViewController.m
//  HelloUIViewControllerTransitioningDelegate
//
//  Created by wesley chen on 16/7/13.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "UseWCNavSystemTransitionViewController.h"
#import "Demo1ModalViewController.h"
#import "Demo1StackViewController.h"

#import "ONESwipeBackInteractionController.h"
#import "WCNavSystemTransition.h"

@interface UseWCNavSystemTransitionViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UIButton *buttonPush;
@property (nonatomic, strong) UIButton *buttonPresent;
@property (nonatomic, strong) UIButton *buttonPresentNav;

@property (nonatomic, strong) WCNavSystemPopTransitionInteractor *interactiveAnimator;
//@property (nonatomic, strong) ONESwipeBackInteractionController *interactor;

@end

@implementation UseWCNavSystemTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.buttonPush];
    [self.view addSubview:self.buttonPresent];
    [self.view addSubview:self.buttonPresentNav];
    
    self.interactiveAnimator = [WCNavSystemPopTransitionInteractor new];
//    self.interactor = [ONESwipeBackInteractionController new];
}

#pragma mark - Getters

- (UIButton *)buttonPush {
    if (!_buttonPush) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat width = 140.0f;
        CGFloat height = 30.0f;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake((screenSize.width - width) / 2.0, 120, width, height);
        button.layer.cornerRadius = 4.0f;
        button.layer.borderColor = [UIColor darkGrayColor].CGColor;
        button.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        button.layer.masksToBounds = YES;
        [button setTitle:@"Push (System)" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPushClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonPush = button;
    }
    
    return _buttonPush;
}

- (UIButton *)buttonPresent {
    if (!_buttonPresent) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat width = 140.0f;
        CGFloat height = 30.0f;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake((screenSize.width - width) / 2.0, CGRectGetMaxY(self.buttonPush.frame) + 10, width, height);
        button.layer.cornerRadius = 4.0f;
        button.layer.borderColor = [UIColor darkGrayColor].CGColor;
        button.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        button.layer.masksToBounds = YES;
        [button setTitle:@"Present" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPresentClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonPresent = button;
    }
    
    return _buttonPresent;
}

- (UIButton *)buttonPresentNav {
    if (!_buttonPresentNav) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat width = 140.0f;
        CGFloat height = 30.0f;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake((screenSize.width - width) / 2.0, CGRectGetMaxY(self.buttonPresent.frame) + 10, width, height);
        button.layer.cornerRadius = 4.0f;
        button.layer.borderColor = [UIColor darkGrayColor].CGColor;
        button.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        button.layer.masksToBounds = YES;
        [button setTitle:@"Present Nav" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPresentNavClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonPresentNav = button;
    }
    
    return _buttonPresentNav;
}

#pragma mark - Actions

- (void)buttonPushClicked:(id)sender {
    Demo1StackViewController *vc = [Demo1StackViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"start");
}

- (void)buttonPresentClicked:(id)sender {
    Demo1ModalViewController *vc = [Demo1ModalViewController new];
    vc.transitioningDelegate = self;
    vc.interactor = self.interactiveAnimator;
//    [self.interactor wireToViewController:vc];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)buttonPresentNavClicked:(id)sender {
    Demo1ModalViewController *vc = [Demo1ModalViewController new];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    navController.transitioningDelegate = self;
    navController.interactor = self.interactiveAnimator;
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [WCNavSystemPushTransitionAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [WCNavSystemPopTransitionAnimator new];
//    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.interactiveAnimator.interactionInProgress ? self.interactiveAnimator : nil;
//    return self.interactor.interactionInProgress ? self.interactor : nil;
}

@end
