//
//  ShapeAnimateWithFillColorViewController.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 2020/6/14.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import "ShapeAnimateWithFillColorViewController.h"
#import "WCMacroTool.h"

@interface ShapeAnimateWithFillColorViewController ()
@property (nonatomic, strong) CAShapeLayer *layerShape1;
@end

@implementation ShapeAnimateWithFillColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.contentView.layer addSublayer:self.layerShape1];
}

#pragma mark - CAShapeLayer

- (CAShapeLayer *)layerShape1 {
    if (!_layerShape1) {
        CGFloat side = 120.0;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(10, 10, side, side);
        layer.lineWidth = 2.0;
        layer.fillColor = [UIColor redColor].CGColor;
        layer.strokeColor = nil;
        //SHOW_LAYER_BORDER(layer);
        
        CGPoint arcCenter = CGPointMake(layer.bounds.size.width / 2.0, layer.bounds.size.height / 2.0);
        CGFloat radius = layer.bounds.size.width / 2.0;
        CGFloat startAngle = 0;
        CGFloat endAngle = M_PI * 2;
        BOOL clockwise = YES;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
        layer.path = path.CGPath;
        
        CABasicAnimation *fillColorAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
        fillColorAnimation.toValue = (id)[UIColor cyanColor].CGColor;
        fillColorAnimation.duration = 0.75;
        fillColorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        fillColorAnimation.autoreverses = YES;
        fillColorAnimation.repeatCount = HUGE_VALF;
        
        [layer addAnimation:fillColorAnimation forKey:@"fillColorAnimation"];
        
        _layerShape1 = layer;
    }
    
    return _layerShape1;
}

@end
