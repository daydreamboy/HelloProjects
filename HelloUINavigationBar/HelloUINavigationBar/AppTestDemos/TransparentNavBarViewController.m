//
//  TransparentNavBarViewController.m
//  HelloUINavigationBar
//
//  Created by wesley_chen on 13/04/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "TransparentNavBarViewController.h"

@interface TransparentNavBarViewController ()

@end

@implementation TransparentNavBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    navigationBar.barTintColor = [UIColor redColor];
//    navigationBar.translucent = NO;
    [navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    navigationBar.barTintColor = nil;
//    navigationBar.translucent = YES;
    [navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    navigationBar.shadowImage = nil;
}

@end
