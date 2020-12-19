//
//  ChildViewController.m
//  HelloUIViewController
//
//  Created by wesley_chen on 2020/12/17.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "ChildViewController.h"

@interface ChildViewController ()

@end

@implementation ChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Right" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        self.navigationItem.rightBarButtonItem = rightItem;
    });
}

@end
