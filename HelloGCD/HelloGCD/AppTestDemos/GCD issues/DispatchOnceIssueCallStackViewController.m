//
//  DispatchOnceIssueCallStackViewController.m
//  HelloGCD
//
//  Created by wesley_chen on 23/03/2018.
//  Copyright © 2018 wesley chen. All rights reserved.
//

#import "DispatchOnceIssueCallStackViewController.h"

@interface DispatchOnceIssueCallStackViewController ()
@property (nonatomic, strong) UIButton *button;
@end

@implementation DispatchOnceIssueCallStackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.button];
}

#pragma mark - Getters

- (UIButton *)button {
    if (!_button) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, 200, 30);
        [button setTitle:@"make crash" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
        
        _button = button;
    }
    
    return _button;
}

#pragma mark - Actions

- (void)buttonClicked:(UIButton *)sender {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self doSomeCrash];
    });
}

- (void)doSomeCrash {
    id nilValue = nil;
    [[NSMutableArray array] addObject:nilValue];
}

@end
