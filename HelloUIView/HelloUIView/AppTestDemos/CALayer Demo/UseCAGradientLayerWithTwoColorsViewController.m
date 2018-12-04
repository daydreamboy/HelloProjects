//
//  TestCAGradientLayerViewController.m
//  HelloGradient
//
//  Created by wesley chen on 16/6/1.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "UseCAGradientLayerWithTwoColorsViewController.h"

#ifndef UICOLOR_RGB
#define UICOLOR_RGB(color)       [UIColor colorWithRed: (((color) >> 16) & 0xFF) / 255.0 green: (((color) >> 8) & 0xFF) / 255.0 blue: ((color) & 0xFF) / 255.0 alpha: 1.0]
#endif

@interface UseCAGradientLayerWithTwoColorsViewController ()
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@end

@implementation UseCAGradientLayerWithTwoColorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.view1];
    [self.view addSubview:self.view2];
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
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = view.bounds;
        gradientLayer.colors = @[(id)[[UIColor clearColor] CGColor], (id)[[[UIColor blackColor] colorWithAlphaComponent:0.5] CGColor]];
        //gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1);
//        view.layer.mask = gradientLayer;
        [view.layer addSublayer:gradientLayer];
//        [view.layer insertSublayer:gradientLayer atIndex:0];
        
        _view2 = view;
    }
    
    return _view2;
}

@end
