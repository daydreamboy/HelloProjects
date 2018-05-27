//
//  DelegateProxyViewController.m
//  HelloNSProxy
//
//  Created by wesley_chen on 2018/5/16.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "DelegateProxyViewController.h"
#import "MyView.h"

@interface DelegateProxyViewController () <MyViewLifeCycle>
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) MyView *myView;
@end

@implementation DelegateProxyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.button];
    [self.view addSubview:self.myView];
}

#pragma mark - Getters
- (UIButton *)button {
    if (!_button) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat paddingH = 20;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(paddingH, 80, screenSize.width - 2 * paddingH, 30);
        button.selected = YES;
        [button setTitle:@"Add View" forState:UIControlStateNormal];
        [button setTitle:@"Remove View" forState:UIControlStateSelected];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _button = button;
    }
    
    return _button;
}

- (MyView *)myView {
    if (!_myView) {
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat paddingH = 20;
        
        MyView *view = [[MyView alloc] initWithFrame:CGRectMake(paddingH, 120, screenSize.width - 2 * paddingH, 200)];
        view.delegate = self;
        view.backgroundColor = [UIColor greenColor];
        
        _myView = view;
    }
    
    return _myView;
}

#pragma mark - Actions

- (void)buttonClicked:(UIButton *)sender {
    if (sender == self.button) {
        sender.selected = !sender.selected;
        
        if (sender.selected) {
            [self.view addSubview:self.myView];
        }
        else {
            [self.myView removeFromSuperview];
        }
    }
}

#pragma mark - MyViewLifeCycle

- (void)myViewWillAppear:(MyView *)myView {
    NSLog(@"myViewWillAppear");
}

@end
