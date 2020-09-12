//
//  HideBackArrowViewController.m
//  HelloUINavigationBar
//
//  Created by wesley_chen on 2018/7/5.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "HideBackArrowViewController.h"

@interface HideBackArrowViewController ()
@property (nonatomic, strong) UIButton *buttonPop;
@end

@implementation HideBackArrowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.buttonPop];
    
    // @see https://stackoverflow.com/a/791938
    self.navigationItem.hidesBackButton = YES;
    
    // or
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Test" style:UIBarButtonItemStylePlain target:nil action:nil];
}

#pragma mark - Getter

- (UIButton *)buttonPop {
    if (!_buttonPop) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button addTarget:self action:@selector(buttonPopClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Pop" forState:UIControlStateNormal];
        [button sizeToFit];
        button.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
        
        _buttonPop = button;
    }
    
    return _buttonPop;
}

#pragma mark - Action

- (void)buttonPopClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
