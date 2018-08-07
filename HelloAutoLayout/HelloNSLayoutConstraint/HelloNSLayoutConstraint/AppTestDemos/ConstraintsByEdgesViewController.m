//
//  ConstraintsByEdgesViewController.m
//  HelloNSLayoutConstraint
//
//  Created by wesley_chen on 2018/8/6.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "ConstraintsByEdgesViewController.h"

@interface ConstraintsByEdgesViewController ()
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;
@property (nonatomic, strong) UIView *view4;
@end

@implementation ConstraintsByEdgesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.view1];
    [self.view addSubview:self.view2];
    [self.view addSubview:self.view3];
    [self.view addSubview:self.view4];
    
    [self setupContraints];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setupContraints {
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.view1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self.view addConstraint:constraint1];
}

#pragma mark - Getters

- (UIView *)view1 {
    if (!_view1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//        view.translatesAutoresizingMaskIntoConstraints = NO;
        view.backgroundColor = [UIColor redColor];
        
        _view1 = view;
    }
    
    return _view1;
}

- (UIView *)view2 {
    if (!_view2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        view.backgroundColor = [UIColor greenColor];
        
        _view2 = view;
    }
    
    return _view2;
}

- (UIView *)view3 {
    if (!_view3) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        view.backgroundColor = [UIColor blueColor];
        
        _view3 = view;
    }
    
    return _view3;
}

- (UIView *)view4 {
    if (!_view4) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        view.backgroundColor = [UIColor yellowColor];
        
        _view4 = view;
    }
    
    return _view4;
}

@end
