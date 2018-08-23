//
//  FadeViewController.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 15/1/24.
//  Copyright (c) 2015年 wesley_chen. All rights reserved.
//

#import "FadeViewController.h"
#import "DrawedImageView.h"

@interface FadeViewController ()
@property (nonatomic, strong) DrawedImageView *imageView;
@end

@implementation FadeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat heightForStatusBar = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat heightForNavBar = CGRectGetHeight(self.navigationController.navigationBar.frame);
    
    UIImage *image = [UIImage imageNamed:@"logo64X64"];
    DrawedImageView *imageView = [[DrawedImageView alloc] initWithImage:image];
    imageView.backgroundColor = [UIColor greenColor];
    imageView.frame = CGRectMake(0, 0, screenSize.width, screenSize.width);
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, heightForStatusBar + heightForNavBar, screenSize.width, 30);
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"Fade out" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.selected = NO;
    [self.view addSubview:button];
}

- (void)buttonClicked:(UIButton *)button {
    if (button.selected) {
        button.selected = NO;
        [button setTitle:@"Fade out" forState:UIControlStateNormal];
        [UIView animateWithDuration:5 animations:^{
            self.imageView.alpha = 1;
        }];
    }
    else {
        button.selected = YES;
        [button setTitle:@"Fade in" forState:UIControlStateNormal];
        [UIView animateWithDuration:5 animations:^{
            self.imageView.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    }
}




@end
