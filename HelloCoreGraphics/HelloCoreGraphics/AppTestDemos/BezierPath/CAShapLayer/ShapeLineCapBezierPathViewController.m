//
//  ShapeLineCapBezierPathViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2020/6/14.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "ShapeLineCapBezierPathViewController.h"

#define LayerHeight 40
#define LayerSpace 20

@interface ShapeLineCapBezierPathViewController ()
@property (nonatomic, strong) CAShapeLayer *layerShape1;
@property (nonatomic, strong) CAShapeLayer *layerShape2;
@property (nonatomic, strong) CAShapeLayer *layerShape3;
@end

@implementation ShapeLineCapBezierPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.contentView.layer addSublayer:self.layerShape1];
    [self.contentView.layer addSublayer:self.layerShape2];
    [self.contentView.layer addSublayer:self.layerShape3];
}

#pragma mark - CAShapeLayer

- (CAShapeLayer *)layerShape1 {
    if (!_layerShape1) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, 0, screenSize.width, LayerHeight);
        layer.lineWidth = 10.0;
        layer.fillColor = [UIColor greenColor].CGColor;
        layer.strokeColor = [UIColor redColor].CGColor;
        SHOW_LAYER_BORDER(layer);
        
        CGFloat paddingH = 10;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(paddingH, CGRectGetHeight(layer.bounds) / 2.0)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(layer.bounds) - paddingH, CGRectGetHeight(layer.bounds) / 2.0)];
        
        layer.path = path.CGPath;
        
        _layerShape1 = layer;
    }
    
    return _layerShape1;
}

- (CAShapeLayer *)layerShape2 {
    if (!_layerShape2) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, CGRectGetMaxY(self.layerShape1.frame) + LayerSpace, screenSize.width, LayerHeight);
        layer.lineWidth = 10.0;
        layer.fillColor = [UIColor greenColor].CGColor;
        layer.strokeColor = [UIColor redColor].CGColor;
        layer.lineCap = kCALineCapRound;
        SHOW_LAYER_BORDER(layer);
        
        CGFloat paddingH = 10;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(paddingH, CGRectGetHeight(layer.bounds) / 2.0)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(layer.bounds) - paddingH, CGRectGetHeight(layer.bounds) / 2.0)];
        
        layer.path = path.CGPath;
        
        _layerShape2 = layer;
    }
    
    return _layerShape2;
}

- (CAShapeLayer *)layerShape3 {
    if (!_layerShape3) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, CGRectGetMaxY(self.layerShape2.frame) + LayerSpace, screenSize.width, LayerHeight);
        layer.lineWidth = 10.0;
        layer.fillColor = [UIColor greenColor].CGColor;
        layer.strokeColor = [UIColor redColor].CGColor;
        layer.lineCap = kCALineCapSquare;
        SHOW_LAYER_BORDER(layer);
        
        CGFloat paddingH = 10;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(paddingH, CGRectGetHeight(layer.bounds) / 2.0)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(layer.bounds) - paddingH, CGRectGetHeight(layer.bounds) / 2.0)];
        
        layer.path = path.CGPath;
        
        _layerShape3 = layer;
    }
    
    return _layerShape3;
}

@end
