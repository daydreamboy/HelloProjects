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

@end

@implementation UseCAGradientLayerWithTwoColorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat navBarHeight = 64.0f;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGRect rect = CGRectMake(0, navBarHeight, screenSize.width, screenSize.height - navBarHeight);
    
    // @sa http://stackoverflow.com/questions/25870101/gradient-in-corner
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = rect;
    gradient.colors = @[(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blackColor] CGColor]];
    gradient.startPoint = CGPointZero;
    [self.view.layer insertSublayer:gradient atIndex:0];
}

@end
