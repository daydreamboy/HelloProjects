//
//  ShapeFillRuleBezierPathViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2020/6/14.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "ShapeFillRuleBezierPathViewController.h"
#import "WCMacroTool.h"

@interface ShapeFillRuleBezierPathViewController ()
@property (nonatomic, strong) CAShapeLayer *layerShape1;
@property (nonatomic, strong) CAShapeLayer *layerShape2;
@end

@implementation ShapeFillRuleBezierPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.contentView.layer addSublayer:self.layerShape1];
    [self.contentView.layer addSublayer:self.layerShape2];
}

#pragma mark - CAShapeLayer

- (CAShapeLayer *)layerShape1 {
    if (!_layerShape1) {
        CGFloat side = 150.0;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(10, 10, side, side);
        layer.lineWidth = 2.0;
        layer.fillColor = UICOLOR_RGB(0xEEC3E5).CGColor;
        layer.fillRule = kCAFillRuleNonZero;
        layer.strokeColor = [UIColor redColor].CGColor;
        //SHOW_LAYER_BORDER(layer);
        
        UIBezierPath *outerPath = [UIBezierPath bezierPathWithRect:CGRectInset(layer.bounds, 20, 20)];
        UIBezierPath *innerPath = [UIBezierPath bezierPathWithRect:CGRectInset(layer.bounds, 50, 50)];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path appendPath:outerPath];
        [path appendPath:innerPath];
        
        layer.path = path.CGPath;
        
        _layerShape1 = layer;
    }
    
    return _layerShape1;
}

- (CAShapeLayer *)layerShape2 {
    if (!_layerShape2) {
        CGFloat side = 150.0;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(10, CGRectGetMaxY(self.layerShape1.frame) + 10, side, side);
        layer.lineWidth = 2.0;
        layer.fillColor = UICOLOR_RGB(0xEEC3E5).CGColor;
        layer.fillRule = kCAFillRuleEvenOdd;
        layer.strokeColor = [UIColor redColor].CGColor;
        //SHOW_LAYER_BORDER(layer);
        
        UIBezierPath *outerPath = [UIBezierPath bezierPathWithRect:CGRectInset(layer.bounds, 20, 20)];
        UIBezierPath *innerPath = [UIBezierPath bezierPathWithRect:CGRectInset(layer.bounds, 50, 50)];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path appendPath:outerPath];
        [path appendPath:innerPath];
        
        layer.path = path.CGPath;
        
        _layerShape2 = layer;
    }
    
    return _layerShape2;
}

@end
