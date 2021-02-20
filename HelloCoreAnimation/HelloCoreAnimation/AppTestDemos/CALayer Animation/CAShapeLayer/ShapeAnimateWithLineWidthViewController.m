//
//  ShapeAnimateWithLineWidthViewController.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 2020/6/21.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import "ShapeAnimateWithLineWidthViewController.h"
#import "WCMacroTool.h"

@interface ShapeAnimateWithLineWidthViewController ()
@property (nonatomic, strong) CAShapeLayer *layerShape1;
@end

@implementation ShapeAnimateWithLineWidthViewController

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
        layer.lineWidth = 0.0;
        layer.fillColor = nil;
        layer.strokeColor = UICOLOR_RGB(0xD02FAE).CGColor;
        //layer.lineDashPattern = @[ @5 ];
        //SHOW_LAYER_BORDER(layer);
        
        CGPoint arcCenter = CGPointMake(layer.bounds.size.width / 2.0, layer.bounds.size.height / 2.0);
        CGFloat radius = layer.bounds.size.width / 2.0;
        CGFloat startAngle = 0;
        CGFloat endAngle = M_PI * 2;
        BOOL clockwise = YES;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
        layer.path = path.CGPath;
        
        // Animate
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
        animation.toValue = @(10.0);
        animation.duration = 1.5;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.autoreverses = YES;
        animation.repeatCount = HUGE_VALF;

        [layer addAnimation:animation forKey:@"lineWidthAnimation"];
        
        _layerShape1 = layer;
    }
    
    return _layerShape1;
}

@end
