//
//  HideBackArrowViewController.m
//  HelloUINavigationBar
//
//  Created by wesley_chen on 2018/7/5.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "HideBackArrowViewController.h"

@interface HideBackArrowViewController ()

@end

@implementation HideBackArrowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // @see https://stackoverflow.com/a/791938
    self.navigationItem.hidesBackButton = YES;
    
    // or
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Test" style:UIBarButtonItemStylePlain target:nil action:nil];
}

@end
