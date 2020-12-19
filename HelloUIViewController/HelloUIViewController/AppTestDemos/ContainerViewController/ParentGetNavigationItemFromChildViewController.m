//
//  ParentViewController.m
//  HelloUIViewController
//
//  Created by wesley_chen on 2020/12/17.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "ParentGetNavigationItemFromChildViewController.h"
#import "ChildViewController.h"

@interface ParentGetNavigationItemFromChildViewController ()

@end

@implementation ParentGetNavigationItemFromChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ChildViewController *child = [[ChildViewController alloc] init];
    
    [child willMoveToParentViewController:self];
    [self addChildViewController:child];
    [self.view addSubview:child.view];
    [child didMoveToParentViewController:self];
}

// Note: overrite the navigationItem method to get items from child view controller
// @see https://stackoverflow.com/questions/26772629/how-to-set-uibarbuttonitem-created-by-a-child-view-controller-to-a-parent-view-c
- (UINavigationItem *)navigationItem {
    return [self.childViewControllers firstObject].navigationItem;
}

@end
