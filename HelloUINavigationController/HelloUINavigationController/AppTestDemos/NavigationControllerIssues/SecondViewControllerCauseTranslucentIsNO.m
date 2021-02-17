//
//  SecondViewControllerCauseTranslucentIsNO.m
//  HelloUINavigationBar
//
//  Created by wesley_chen on 2020/9/10.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "SecondViewControllerCauseTranslucentIsNO.h"

@interface SecondViewControllerCauseTranslucentIsNO ()

@end

@implementation SecondViewControllerCauseTranslucentIsNO

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.translucent = NO;
}

@end
