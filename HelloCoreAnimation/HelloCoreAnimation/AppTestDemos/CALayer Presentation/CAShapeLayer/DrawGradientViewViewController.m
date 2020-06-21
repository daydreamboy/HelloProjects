//
//  ViewController.m
//  HelloGradient
//
//  Created by wesley chen on 15/1/5.
//  Copyright (c) 2015年 wesley chen. All rights reserved.
//

#import "DrawGradientViewViewController.h"
#import "GradientView.h"

@interface DrawGradientViewViewController ()

@end

@implementation DrawGradientViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat navBarHeight = 64.0f;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGRect rect = CGRectMake(0, navBarHeight, screenSize.width, screenSize.height - navBarHeight);
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:[[GradientView alloc] initWithFrame:rect]];
}

@end
