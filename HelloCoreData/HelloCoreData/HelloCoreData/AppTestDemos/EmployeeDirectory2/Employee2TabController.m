//
//  Employee2TabController.m
//  HelloCoreData
//
//  Created by wesley_chen on 07/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "Employee2TabController.h"
#import "Employee2ListViewController.h"
#import "Department2ListViewController.h"

@interface Employee2TabController () <UINavigationControllerDelegate>
@property (nonatomic, strong) UINavigationController *tabNav1;
@property (nonatomic, strong) UINavigationController *tabNav2;
@end

@implementation Employee2TabController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItems = @[
                                               [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil],
                                               [[UIBarButtonItem alloc] initWithTitle:@"< Back" style:UIBarButtonItemStyleDone target:self action:@selector(navBackItemClicked:)]
    ];
    
    NSMutableArray *viewControllers = [NSMutableArray array];
    
    // Tab 1
    Employee2ListViewController *employeeVC = [Employee2ListViewController new];
    [employeeVC prepareContextAndCoreData];
    employeeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Employees" image:[UIImage imageNamed:@"employees"] tag:1];
    
    UINavigationController *navController1 = [[UINavigationController alloc] initWithRootViewController:employeeVC];
    [viewControllers addObject:navController1];
    self.tabNav1 = navController1;
    
    // Tab 2
    Department2ListViewController *departmentVC = [[Department2ListViewController alloc] initWithCoreDataStack:employeeVC.coreDataStack];
    departmentVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Departments" image:[UIImage imageNamed:@"departments"] tag:2];
    
    UINavigationController *navController2 = [[UINavigationController alloc] initWithRootViewController:departmentVC];
    [viewControllers addObject:navController2];
    self.tabNav2 = navController2;
    
    [self setViewControllers:viewControllers animated:NO];
}

#pragma mark - Actions

- (void)navBackItemClicked:(id)sender {
    UINavigationController *currentTab = self.selectedViewController;
    
    if (currentTab == self.tabNav1) {
        if (self.tabNav1.viewControllers.count == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self.tabNav1 popViewControllerAnimated:YES];
        }
    }
    else if (currentTab == self.tabNav2) {
        if (self.tabNav2.viewControllers.count == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self.tabNav2 popViewControllerAnimated:YES];
        }
    }
}

@end
