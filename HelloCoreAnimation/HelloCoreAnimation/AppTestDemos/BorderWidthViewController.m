//
//  BorderWidthViewController.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 15/4/1.
//  Copyright (c) 2015年 wesley_chen. All rights reserved.
//

#import "BorderWidthViewController.h"

@implementation BorderWidthViewController


- (void)viewDidLoad {
	[super viewDidLoad];

	self.view.backgroundColor = [UIColor whiteColor];

	CGSize screenSize = [[UIScreen mainScreen] bounds].size;

	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
	view.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
	view.backgroundColor = [UIColor greenColor];
    view.layer.borderColor = [UIColor redColor].CGColor;
	[self.view addSubview:view];

	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
	animation.fromValue = @(0.0);
	animation.toValue = @(10.0);
	animation.duration = 5.0f;
    animation.repeatCount = HUGE_VALF;

	[view.layer addAnimation:animation forKey:@"borderWidth"];
}

@end
