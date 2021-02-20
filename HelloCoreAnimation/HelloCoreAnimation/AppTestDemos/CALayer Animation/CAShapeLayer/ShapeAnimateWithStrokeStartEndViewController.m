//
//  ShapeAnimateWithStrokeStartEndViewController.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 2020/6/21.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import "ShapeAnimateWithStrokeStartEndViewController.h"
#import "WCMacroTool.h"

#define SpaceV 20

@interface ShapeAnimateWithStrokeStartEndViewController ()
@property (nonatomic, strong) CAShapeLayer *layerShape1;
@property (nonatomic, strong) CAShapeLayer *layerShape2;
@end

@implementation ShapeAnimateWithStrokeStartEndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.contentView.layer addSublayer:self.layerShape1];
    [self.contentView.layer addSublayer:self.layerShape2];
}

#pragma mark - CAShapeLayer

- (CAShapeLayer *)layerShape1 {
    if (!_layerShape1) {
        CGFloat side = 120.0;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(10, 10, side, side);
        layer.lineWidth = 2.0;
        layer.fillColor = nil;
        layer.strokeColor = UICOLOR_RGB(0xD02FAE).CGColor;
        layer.strokeStart = 0.0;
        layer.strokeEnd = 0.0;
        //SHOW_LAYER_BORDER(layer);
        
        CGPoint arcCenter = CGPointMake(layer.bounds.size.width / 2.0, layer.bounds.size.height / 2.0);
        CGFloat radius = layer.bounds.size.width / 2.0;
        CGFloat startAngle = 0;
        CGFloat endAngle = M_PI * 2;
        BOOL clockwise = YES;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
        layer.path = path.CGPath;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.toValue = @1.0;
        animation.duration = 0.75;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.autoreverses = YES;
        animation.repeatCount = HUGE_VALF;
        
        [layer addAnimation:animation forKey:@"strokeEndAnimation"];
        
        _layerShape1 = layer;
    }
    
    return _layerShape1;
}

- (CAShapeLayer *)layerShape2 {
    if (!_layerShape2) {
        CGFloat side = 120.0;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(10, CGRectGetMaxY(_layerShape1.frame) + SpaceV, side, side);
        layer.lineWidth = 2.0;
        layer.fillColor = nil;
        layer.strokeColor = UICOLOR_RGB(0xD02FAE).CGColor;
        layer.strokeStart = 0.0;
        layer.strokeEnd = 1.0;
        //SHOW_LAYER_BORDER(layer);
        
        CGPoint arcCenter = CGPointMake(layer.bounds.size.width / 2.0, layer.bounds.size.height / 2.0);
        CGFloat radius = layer.bounds.size.width / 2.0;
        CGFloat startAngle = 0;
        CGFloat endAngle = M_PI * 2;
        BOOL clockwise = YES;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
        layer.path = path.CGPath;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        animation.toValue = @1.0;
        animation.duration = 0.75;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.autoreverses = YES;
        animation.repeatCount = HUGE_VALF;
        
        [layer addAnimation:animation forKey:@"strokeStartAnimation"];
        
        _layerShape2 = layer;
    }
    
    return _layerShape2;
}

@end
