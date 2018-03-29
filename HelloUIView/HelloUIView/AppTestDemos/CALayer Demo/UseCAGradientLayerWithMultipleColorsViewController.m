//
//  TestCAGradientLayer2ViewController.m
//  HelloGradient
//
//  Created by wesley chen on 16/6/1.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "UseCAGradientLayerWithMultipleColorsViewController.h"

@interface UseCAGradientLayerWithMultipleColorsViewController ()

@end

@implementation UseCAGradientLayerWithMultipleColorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat navBarHeight = 64.0f;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGRect rect = CGRectMake(0, navBarHeight, screenSize.width, screenSize.height - navBarHeight);
    
    // @sa http://stackoverflow.com/questions/25870101/gradient-in-corner
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = rect;
    
    //Pink color to set with your needs
    UIColor *pinkColor = [UIColor colorWithRed:1 green:105/255.0 blue:180/255.0 alpha:1];
    gradient.colors = @[(id)[pinkColor CGColor],
                        (id)[[UIColor whiteColor] CGColor],
                        (id)[[UIColor whiteColor] CGColor],
                        (id)[pinkColor CGColor]];
    
    //You may have to change these values to your needs.
    gradient.locations = @[@(0.0), @(0.5), @(0.5), @(1.0)];
    
    //From Upper Right to Bottom Left
    gradient.startPoint = CGPointMake(1, 0);
    gradient.endPoint = CGPointMake(0, 1);
    
    //Apply
    [self.view.layer insertSublayer:gradient atIndex:0];
}

@end
