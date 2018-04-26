//
//  RemoveHairLineOfNavBarViewController.m
//  HelloUINavigationBar
//
//  Created by wesley_chen on 2018/4/26.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "RemoveHairLineOfNavBarViewController.h"
#import "WCNavigationBarTool.h"

@interface RemoveHairLineOfNavBarViewController ()

@end

@implementation RemoveHairLineOfNavBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [WCNavigationBarTool setNavBar:navigationBar hairLineColor:[UIColor clearColor]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [WCNavigationBarTool setNavBar:navigationBar hairLineColor:nil];
}

@end
