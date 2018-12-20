//
//  TransparentNavBarViewController.m
//  HelloUINavigationBar
//
//  Created by wesley_chen on 13/04/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "TransparentNavBarViewController.h"
#import "WCNavigationBarTool.h"

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
    [WCNavigationBarTool setNavBar:navigationBar transparent:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [WCNavigationBarTool setNavBar:navigationBar transparent:NO];
}

@end
