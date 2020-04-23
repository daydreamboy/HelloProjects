//
//  TestCAGradientLayerViewController.m
//  HelloGradient
//
//  Created by wesley chen on 16/6/1.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "UseCAGradientLayerWithTwoColorsViewController.h"
#import "WCViewTool.h"

#ifndef UICOLOR_RGB
#define UICOLOR_RGB(color)       [UIColor colorWithRed: (((color) >> 16) & 0xFF) / 255.0 green: (((color) >> 8) & 0xFF) / 255.0 blue: ((color) & 0xFF) / 255.0 alpha: 1.0]
#endif

@interface UseCAGradientLayerWithTwoColorsViewController ()
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;
@end

@implementation UseCAGradientLayerWithTwoColorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.view1];
    [self.view addSubview:self.view2];
    [self.view addSubview:self.view3];
}

- (UIView *)view1 {
    if (!_view1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 20, 200, 100)];
        
        // @sa http://stackoverflow.com/questions/25870101/gradient-in-corner
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = view.bounds;
        gradient.colors = @[(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blackColor] CGColor]];
        gradient.startPoint = CGPointZero;
        gradient.endPoint = CGPointMake(1, 1);
        [view.layer insertSublayer:gradient atIndex:0];
        
        _view1 = view;
    }
    
    return _view1;
}

- (UIView *)view2 {
    if (!_view2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view1.frame) + 10, 200, 100)];
        UIView *backgroundView = [[UIView alloc] initWithFrame:view.bounds];
        backgroundView.backgroundColor = [UIColor orangeColor];
        [view addSubview:backgroundView];
        
        [WCViewTool addGradientLayerWithView:view startColor:[UIColor clearColor] endColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] startPoint:CGPointMake(0.5, 0) endPoint:CGPointMake(0.5, 1) shouldAddToTop:YES];
        
        _view2 = view;
    }
    
    return _view2;
}

- (UIView *)view3 {
    if (!_view3) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view2.frame) + 10, 31, 31)];
        view.layer.cornerRadius = CGRectGetWidth(view.bounds) / 2.0;
        view.layer.masksToBounds = YES;
        
        [WCViewTool addGradientLayerWithView:view startColor:UICOLOR_RGB(0xFD9426) endColor:UICOLOR_RGB(0xFC6323) startPoint:CGPointMake(0, 1) endPoint:CGPointMake(1, 0) shouldAddToTop:NO];
        
        _view3 = view;
    }
    
    return _view3;
}

@end
