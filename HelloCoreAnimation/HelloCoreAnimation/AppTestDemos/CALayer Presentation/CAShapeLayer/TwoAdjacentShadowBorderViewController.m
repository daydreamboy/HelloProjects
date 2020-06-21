//
//  TwoAdjacentShadowBorderViewController.m
//  HelloUIView
//
//  Created by wesley_chen on 29/03/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "TwoAdjacentShadowBorderViewController.h"

@interface TwoAdjacentShadowBorderViewController ()

@end

@implementation TwoAdjacentShadowBorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // @see https://stackoverflow.com/questions/8484023/is-there-a-way-to-prevent-calayer-shadows-from-overlapping-adjacent-layers
    CALayer *containerLayer = [CALayer layer];
    containerLayer.frame = self.view.bounds;
    containerLayer.shadowRadius = 10;
    containerLayer.shadowOpacity = 1;
    [self.view.layer addSublayer:containerLayer];
    
    CAShapeLayer *layer1 = [CAShapeLayer layer];
    layer1.bounds = CGRectMake(0, 0, 200, 200);
    layer1.position = CGPointMake(130, 130);
    layer1.path = [UIBezierPath bezierPathWithOvalInRect:layer1.bounds].CGPath;
    layer1.fillColor = [UIColor redColor].CGColor;
    [containerLayer addSublayer:layer1];
    
    CAShapeLayer *layer2 = [CAShapeLayer layer];
    layer2.bounds = CGRectMake(0, 0, 200, 200);
    layer2.position = CGPointMake(170, 200);
    layer2.path = [UIBezierPath bezierPathWithOvalInRect:layer2.bounds].CGPath;
    layer2.fillColor = [UIColor blueColor].CGColor;
    [containerLayer addSublayer:layer2];
}

@end
