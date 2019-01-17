//
//  TapGesturesBothOnParentChildViewViewController.m
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2018/11/22.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "TapGesturesBothOnParentChildViewViewController.h"
#import "WCAlertTool.h"

@interface TapGesturesBothOnParentChildViewViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, strong) UIView *childView;
@end

@implementation TapGesturesBothOnParentChildViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.parentView];
    [self.parentView addSubview:self.childView];
}

#pragma mark - Getters

- (UIView *)parentView {
    if (!_parentView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 200, 200)];
        view.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.4];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(parentViewTapped:)];
        [view addGestureRecognizer:tapGesture];
        _parentView = view;
    }
    
    return _parentView;
}

- (UIView *)childView {
    if (!_childView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        view.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.6];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(childViewTapped:)];
        [view addGestureRecognizer:tapGesture];
        _childView = view;
    }
    
    return _childView;
}

#pragma mark - Actions

- (void)parentViewTapped:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    NSString *msg = [NSString stringWithFormat:@"%@", tappedView];
    [WCAlertTool presentAlertWithTitle:@"parentView tapped" message:msg cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:nil];
}

- (void)childViewTapped:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    NSString *msg = [NSString stringWithFormat:@"%@", tappedView];
    [WCAlertTool presentAlertWithTitle:@"childView tapped" message:msg cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:nil];
}

@end
