//
//  GetVisibleViewControllerFromWindowViewController.m
//  AppTest
//
//  Created by wesley_chen on 30/10/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "GetVisibleViewControllerFromWindowViewController.h"
#import "WCWindowTool.h"

@interface GetVisibleViewControllerFromWindowViewController ()

@end

@implementation GetVisibleViewControllerFromWindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIViewController *vc = [WCWindowTool visibleViewControllerWithWindow:[[UIApplication sharedApplication].delegate window]];
    if (vc) {
        NSLog(@"visible view controller: %@", vc);
    }
    else {
        NSLog(@"not found visible view controller");
    }
}

@end
