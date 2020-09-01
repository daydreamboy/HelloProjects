//
//  FrameVSConstraintViewController.m
//  HelloNSLayoutConstraint
//
//  Created by wesley_chen on 2018/8/6.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "FrameVSConstraintViewController.h"

@interface FrameVSConstraintViewController ()
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@end

@implementation FrameVSConstraintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.view1];
    [self.view addSubview:self.view2];
    
    [self setupContraints];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"contraints for view1-------------------------");
    NSLog(@"%@", self.view1.constraints);
    
    NSLog(@"contraints for view2-------------------------");
    NSLog(@"%@", self.view2.constraints);
    
    NSLog(@"contraints for self.view-------------------------");
    NSLog(@"%@", self.view.constraints);
}

#pragma mark -

- (void)setupContraints {
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.view1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    [self.view addConstraint:constraint1];
    
    // Warning: this layout constraint not confirm the frame when view2 initialized
    // REAMRK: change constant from 10 to 0, fix it temporarily
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:self.view2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:10];
    [self.view addConstraint:constraint2];
}

#pragma mark - Getters

- (UIView *)view1 {
    if (!_view1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
        view.backgroundColor = [UIColor redColor];
        
        _view1 = view;
    }
    
    return _view1;
}

- (UIView *)view2 {
    if (!_view2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 250, 100, 100)];
        view.backgroundColor = [UIColor greenColor];
        
        _view2 = view;
    }
    
    return _view2;
}

@end
