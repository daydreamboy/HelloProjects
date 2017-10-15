//
//  CornerRadiusViewController.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 15/4/2.
//  Copyright (c) 2015年 wesley_chen. All rights reserved.
//

#import "CornerRadiusViewController.h"

@implementation CornerRadiusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageView.image = [UIImage imageNamed:@"Xcode"];
    imageView.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
    imageView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:imageView];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.fromValue = @(0.0);
    animation.toValue = @(30.0);
    animation.duration = 3.0f;
    animation.repeatCount = HUGE_VALF;
    [imageView.layer addAnimation:animation forKey:@"cornerRadius"];
}

@end
