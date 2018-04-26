//
//  SolidColoredNavBarViewController.m
//  HelloUINavigationBar
//
//  Created by wesley_chen on 13/04/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "SolidColoredNavBarViewController.h"

@interface SolidColoredNavBarViewController ()

@end

@implementation SolidColoredNavBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // @see https://stackoverflow.com/questions/19226965/how-to-hide-uinavigationbar-1px-bottom-line?page=1&tab=votes#tab-top
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    navigationBar.barTintColor = [UIColor redColor];
    navigationBar.tintColor = [UIColor yellowColor];
    navigationBar.translucent = NO;
    [navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    // Note: reset navigationBar to default
    navigationBar.barTintColor = nil;
    navigationBar.tintColor = nil;
    navigationBar.translucent = YES;
    [navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    navigationBar.shadowImage = nil;
}

@end
