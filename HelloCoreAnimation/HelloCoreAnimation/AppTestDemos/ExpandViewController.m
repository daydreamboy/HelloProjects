//
//  ExpandViewController.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 15/2/6.
//  Copyright (c) 2015年 wesley_chen. All rights reserved.
//

#import "ExpandViewController.h"

@interface ExpandViewController ()
@property (nonatomic, strong) UIView *animatedView;
@end

@implementation ExpandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 30, CGRectGetWidth(self.view.frame), 30);
    [button setTitle:@"Expand" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 400, CGRectGetWidth(self.view.frame), 0)];
    view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view];
    self.animatedView = view;
}

- (void)buttonClicked:(id)sender {
    
//    self.animatedView.frame = CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 0);
    self.animatedView.layer.anchorPoint = CGPointMake(0.5, 1);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
    animation.fromValue = [NSValue valueWithCGSize:CGSizeMake(CGRectGetWidth(self.view.frame), 0)];
    animation.toValue = [NSValue valueWithCGSize:CGSizeMake(CGRectGetWidth(self.view.frame), 300)];
    animation.duration = 5;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
//        self.animatedView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    }];
//    self.animatedView.layer.anchorPoint = CGPointMake(0.5, 1);
    [self.animatedView.layer addAnimation:animation forKey:@"change height"];
    [CATransaction commit];
    
//    self.animatedView.layer.frame = CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 300);
}

@end
