//
//  GroupAnimationViewController.m
//  HelloCoreAnimation
//
//  Created by wesley chen on 16/6/8.
//  Copyright © 2016年 wesley_chen. All rights reserved.
//

#import "GroupAnimationViewController.h"

#define SIDE   50.0f
#define HEIGHT (SIDE * 4)
#define DURATION 0.6

@interface GroupAnimationViewController ()
@property (nonatomic, strong) UIView *containerView1;
@property (nonatomic, strong) UIView *childView1;
@property (nonatomic, strong) UIView *childView2;
@property (nonatomic, strong) UIView *childView3;
@property (nonatomic, strong) UIView *childView4;


@property (nonatomic, strong) UIView *containerView2;
@property (nonatomic, strong) UIView *childView11;
@property (nonatomic, strong) UIView *childView22;
@property (nonatomic, strong) UIView *childView33;
@property (nonatomic, strong) UIView *childView44;

@property (nonatomic, strong) UIButton *buttonComeIn;
@property (nonatomic, strong) UIButton *buttonComeOut;

@end

@implementation GroupAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.buttonComeIn];
    [self.view addSubview:self.buttonComeOut];
    
    [self.containerView1 addSubview:self.childView1];
    [self.containerView1 addSubview:self.childView2];
    [self.containerView1 addSubview:self.childView3];
    [self.containerView1 addSubview:self.childView4];
    
    [self.containerView2 addSubview:self.childView11];
    [self.containerView2 addSubview:self.childView22];
    [self.containerView2 addSubview:self.childView33];
    [self.containerView2 addSubview:self.childView44];
}

#pragma mark - Getters

- (UIView *)containerView1 {
    if (!_containerView1) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat height = HEIGHT;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, (screenSize.height - height) / 2.0, screenSize.width, height)];
        view.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.3];
        
        _containerView1 = view;
    }
    
    return _containerView1;
}

- (UIView *)containerView2 {
    if (!_containerView2) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat height = HEIGHT;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, (screenSize.height - height) / 2.0, screenSize.width, height)];
        view.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.3];
        
        _containerView2 = view;
    }
    
    return _containerView2;
}

- (UIView *)childView1 {
    if (!_childView1) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(screenSize.width, 0, SIDE, SIDE)];
        view.backgroundColor = [UIColor redColor];
        
        _childView1 = view;
    }
    
    return _childView1;
}

- (UIView *)childView2 {
    if (!_childView2) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(screenSize.width, SIDE, SIDE, SIDE)];
        view.backgroundColor = [UIColor greenColor];
        
        _childView2 = view;
    }
    
    return _childView2;
}

- (UIView *)childView3 {
    if (!_childView3) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(screenSize.width, 2 * SIDE, SIDE, SIDE)];
        view.backgroundColor = [UIColor magentaColor];
        
        _childView3 = view;
    }
    
    return _childView3;
}

- (UIView *)childView4 {
    if (!_childView4) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(screenSize.width, 3 * SIDE, SIDE, SIDE)];
        view.backgroundColor = [UIColor orangeColor];
        
        _childView4 = view;
    }
    
    return _childView4;
}

- (UIView *)childView11 {
    if (!_childView11) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(screenSize.width, 0, SIDE, SIDE)];
        view.backgroundColor = [UIColor redColor];
        
        _childView11 = view;
    }
    
    return _childView11;
}

- (UIView *)childView22 {
    if (!_childView22) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(screenSize.width, SIDE, SIDE, SIDE)];
        view.backgroundColor = [UIColor greenColor];
        
        _childView22 = view;
    }
    
    return _childView22;
}

- (UIView *)childView33 {
    if (!_childView33) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(screenSize.width, 2 * SIDE, SIDE, SIDE)];
        view.backgroundColor = [UIColor magentaColor];
        
        _childView33 = view;
    }
    
    return _childView33;
}

- (UIView *)childView44 {
    if (!_childView44) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(screenSize.width, 3 * SIDE, SIDE, SIDE)];
        view.backgroundColor = [UIColor orangeColor];
        
        _childView44 = view;
    }
    
    return _childView44;
}

- (UIButton *)buttonComeIn {
    if (!_buttonComeIn) {
        CGFloat height = 30.0f;
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, screenSize.height - height, screenSize.width / 2.0, height);
        button.exclusiveTouch = YES;
        [button setTitle:@"Coming In !" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(stageIn:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonComeIn = button;
    }
    
    return _buttonComeIn;
}

- (UIButton *)buttonComeOut {
    if (!_buttonComeOut) {
        CGFloat height = 30.0f;
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(screenSize.width / 2.0, screenSize.height - height, screenSize.width / 2.0, height);
        button.exclusiveTouch = YES;
        [button setTitle:@"Coming Out !" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(stageOut:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonComeOut = button;
    }
    
    return _buttonComeOut;
}

#pragma mark - Actions

- (void)stageIn:(id)sender {
    
    [self.view addSubview:self.containerView1];
    
    [self translateViewRightBySide:self.childView1 delayed:0 animated:NO completion:nil];
    [self translateViewRightBySide:self.childView2 delayed:0.05 animated:NO completion:nil];
    [self translateViewRightBySide:self.childView3 delayed:2 * 0.05 animated:NO completion:nil];
    [self translateViewRightBySide:self.childView4 delayed:3 * 0.05 animated:NO completion:nil];
    
    // Begin animation
    [self translateViewToCenter:self.childView1 delayed:0 animated:YES completion:nil];
    [self translateViewToCenter:self.childView2 delayed:0.05 animated:YES completion:nil];
    [self translateViewToCenter:self.childView3 delayed:2 * 0.05 animated:YES completion:nil];
    [self translateViewToCenter:self.childView4 delayed:3 * 0.05 animated:YES completion:nil];
}

- (void)stageOut:(id)sender {
    
    [self translateViewLeftBySide:self.childView1 delayed:0 animated:YES completion:nil];
    [self translateViewLeftBySide:self.childView2 delayed:0.05 animated:YES completion:nil];
    [self translateViewLeftBySide:self.childView3 delayed:2 * 0.05 animated:YES completion:nil];
    [self translateViewLeftBySide:self.childView4 delayed:3 * 0.05 animated:YES completion:^{
        [self.containerView1 removeFromSuperview];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * 0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view addSubview:self.containerView2];
        
        [self translateViewRightBySide:self.childView11 delayed:0 animated:NO completion:nil];
        [self translateViewRightBySide:self.childView22 delayed:0.05 animated:NO completion:nil];
        [self translateViewRightBySide:self.childView33 delayed:2 * 0.05 animated:NO completion:nil];
        [self translateViewRightBySide:self.childView44 delayed:3 * 0.05 animated:NO completion:nil];
        
        // Begin animation
        [self translateViewToCenter:self.childView11 delayed:0 animated:YES completion:nil];
        [self translateViewToCenter:self.childView22 delayed:0.05 animated:YES completion:nil];
        [self translateViewToCenter:self.childView33 delayed:2 * 0.05 animated:YES completion:nil];
        [self translateViewToCenter:self.childView44 delayed:3 * 0.05 animated:YES completion:nil];
    });
}

#pragma mark - Move subview related to superview

- (void)translateViewLeftBySide:(UIView *)view delayed:(NSTimeInterval)delayedInSeconds animated:(BOOL)animated completion:(void (^)(void))completion {
    CGSize superViewSize = view.superview.bounds.size;
    CGSize selfViewSize = view.bounds.size;

    CGFloat velocity = 1.0 / (superViewSize.width / 2.0 + selfViewSize.width / 2.0);

    if (animated) {
        [UIView animateWithDuration:DURATION
                              delay:delayedInSeconds
             usingSpringWithDamping:0.7
              initialSpringVelocity:velocity
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
            view.center = CGPointMake(-selfViewSize.width / 2.0, view.center.y);
        }
                         completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
    }
    else {
        view.center = CGPointMake(-selfViewSize.width / 2.0, view.center.y);
    }
}

- (void)translateViewRightBySide:(UIView *)view delayed:(NSTimeInterval)delayedInSeconds animated:(BOOL)animated completion:(void (^)(void))completion {
    CGSize superViewSize = view.superview.bounds.size;
    CGSize selfViewSize = view.bounds.size;

    CGFloat velocity = 1.0 / (superViewSize.width / 2.0 + selfViewSize.width / 2.0);

    if (animated) {
        [UIView animateWithDuration:DURATION
                              delay:delayedInSeconds
             usingSpringWithDamping:0.7
              initialSpringVelocity:velocity
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
            view.center = CGPointMake(superViewSize.width + selfViewSize.width / 2.0, view.center.y);
        }
                         completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
    }
    else {
        view.center = CGPointMake(superViewSize.width + selfViewSize.width / 2.0, view.center.y);
    }
}

- (void)translateViewToCenter:(UIView *)view delayed:(NSTimeInterval)delayedInSeconds animated:(BOOL)animated completion:(void (^)(void))completion {
    CGSize superViewSize = view.superview.bounds.size;
    CGSize selfViewSize = view.bounds.size;

    CGFloat velocity = 1.0 / (superViewSize.width / 2.0 + selfViewSize.width / 2.0);

    if (animated) {
        [UIView animateWithDuration:DURATION
                              delay:delayedInSeconds
             usingSpringWithDamping:0.7
              initialSpringVelocity:velocity
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
            view.center = CGPointMake(superViewSize.width / 2.0, view.center.y);
        }
                         completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
    }
    else {
        view.center = CGPointMake(superViewSize.width / 2.0, view.center.y);
    }
}

- (void)translateView:(UIView *)view toCenterX:(CGFloat)centerX delayed:(NSTimeInterval)delayedInSeconds animated:(BOOL)animated completion:(void (^)(void))completion {
    CGSize superViewSize = view.superview.bounds.size;
    CGSize selfViewSize = view.bounds.size;

    CGFloat velocity = 1.0 / (superViewSize.width / 2.0 + selfViewSize.width / 2.0);

    if (animated) {
        [UIView animateWithDuration:DURATION
                              delay:delayedInSeconds
             usingSpringWithDamping:0.7
              initialSpringVelocity:velocity
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
            view.center = CGPointMake(centerX, view.center.y);
        }
                         completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
    }
    else {
        view.center = CGPointMake(centerX, view.center.y);
    }
}

@end
