//
//  UseCAShapeLayerToShowViewWithTwoCornersViewController.m
//  HelloUIView
//
//  Created by wesley_chen on 28/10/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "UseCAShapeLayerToShowViewWithTwoCornersViewController.h"
#import "WCImageTool.h"

@interface UseCAShapeLayerToShowViewWithTwoCornersViewController ()
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;
@property (nonatomic, strong) UIView *view4;
@property (nonatomic, strong) UIButton *button;
@end

@implementation UseCAShapeLayerToShowViewWithTwoCornersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.view1];
    [self.view addSubview:self.view2];
    [self.view addSubview:self.view3];
    [self.view addSubview:self.view4];
    [self.view addSubview:self.button];
}


#pragma mark - Getters

- (UIView *)view1 {
    if (!_view1) {
        // @see https://stackoverflow.com/questions/10167266/how-to-set-cornerradius-for-only-top-left-and-top-right-corner-of-a-uiview
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 100, 100)];
        view.backgroundColor = [UIColor greenColor];
        
        // Step 1: create close rectangle path with two corners
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(30, 30)];
        
        // Step 2:
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = view.bounds;
        maskLayer.path = maskPath.CGPath;
        maskLayer.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2].CGColor;
        
        // Step 3: masking the view.layer
        view.layer.mask = maskLayer; // Note: `mask` property only use maskLayer's alpha
        
        [self.view addSubview:view];
        
        _view1 = view;
    }
    
    return _view1;
}

- (UIView *)view2 {
    if (!_view2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_view1.frame) + 20, 100, 100)];
        view.backgroundColor = [UIColor greenColor];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(30, 30)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        
        maskLayer.frame = CGRectMake(-10, -10, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds)) ;
        maskLayer.path = maskPath.CGPath;
        maskLayer.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2].CGColor;
        
        view.layer.mask = maskLayer; // Note: `mask` property only use maskLayer's alpha
        
        _view2 = view;
    }
    
    return _view2;
}

- (UIView *)view3 {
    if (!_view3) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_view2.frame) + 20, 100, 100)];
        view.backgroundColor = [UIColor greenColor];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(30, 30)];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = CGRectMake(-10, -10, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds)) ;
        maskLayer.path = maskPath.CGPath;
        maskLayer.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2].CGColor;
        
        [view.layer addSublayer:maskLayer];
        
        _view3 = view;
    }
    
    return _view3;
}

- (UIView *)view4 {
    if (!_view4) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_view3.frame) + 20, 100, 100)];
        view.backgroundColor = [UIColor greenColor];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(30, 30)];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = CGRectMake(-10, -10, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds)) ;
        maskLayer.path = maskPath.CGPath;
        maskLayer.fillColor = [UIColor yellowColor].CGColor;
        maskLayer.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2].CGColor;
        
        [view.layer addSublayer:maskLayer];
        
        _view4 = view;
    }
    
    return _view4;
}

- (UIButton *)button {
    if (!_button) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(CGRectGetMaxX(_view1.frame) + 20, CGRectGetMinY(_view1.frame), 100, 100);
        button.backgroundColor = [UIColor greenColor];
        [button setTitle:@"a button" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[WCImageTool imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[WCImageTool imageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        CAShapeLayer *buttonMaskLayer = [CAShapeLayer layer];
        buttonMaskLayer.frame = button.bounds;
        buttonMaskLayer.path = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(10, 10)].CGPath;
        button.layer.mask = buttonMaskLayer;
        
        _button = button;
    }
    
    return _button;
}

#pragma mark - Actions

- (void)buttonClicked:(id)sender {
}

@end
