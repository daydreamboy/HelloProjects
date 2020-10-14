//
//  Demo1StackViewController.m
//  UIViewController+Addition
//
//  Created by wesley chen on 16/7/12.
//
//

#import "Demo1StackViewController.h"

@implementation Demo1StackViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

- (void)dealloc {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

@end
