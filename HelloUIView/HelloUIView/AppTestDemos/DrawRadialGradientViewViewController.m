//
//  DrawRadialGradientViewViewController.m
//  HelloGradient
//
//  Created by wesley chen on 16/6/1.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "DrawRadialGradientViewViewController.h"
#import "RadialGradientView.h"

@interface DrawRadialGradientViewViewController ()

@end

@implementation DrawRadialGradientViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGFloat navBarHeight = 64.0f;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGRect rect = CGRectMake(0, navBarHeight, screenSize.width, screenSize.height - navBarHeight);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    RadialGradientView *radialView = [[RadialGradientView alloc] initWithFrame:CGRectMake(0, navBarHeight, 100, 100)];
    radialView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:radialView];
}

@end
