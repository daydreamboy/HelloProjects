//
//  ContentsViewController.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 15/4/2.
//  Copyright (c) 2015年 wesley_chen. All rights reserved.
//

#import "ContentsViewController.h"

@implementation ContentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageView.image = [UIImage imageNamed:@"Xcode"];
    imageView.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
    [self.view addSubview:imageView];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"contents"];
    animation.fromValue = (id)[[UIImage imageNamed:@"Xcode"] CGImage];
    animation.toValue = (id)[[UIImage imageNamed:@"logo64X64"] CGImage];
    animation.duration = 3.0f;
    animation.repeatCount = HUGE_VALF;
    [imageView.layer addAnimation:animation forKey:@"contents"];
}

@end
