//
//  BorderColorViewController.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 15/4/2.
//  Copyright (c) 2015年 wesley_chen. All rights reserved.
//

#import "BorderColorViewController.h"

@implementation BorderColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    view.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
    view.backgroundColor = [UIColor greenColor];
    view.layer.borderColor = [UIColor redColor].CGColor;
    view.layer.borderWidth = 10;
    [self.view addSubview:view];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    animation.fromValue = (id)[[UIColor redColor] CGColor];
    animation.toValue = (id)[[UIColor greenColor] CGColor];
    animation.duration = 3.0f;
    animation.repeatCount = HUGE_VALF;
    [view.layer addAnimation:animation forKey:@"borderColor"];
}


@end
