//
//  ShapeCurveBezierPathViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2020/6/21.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "ShapeCurveBezierPathViewController.h"

#define SpaceV 10

@interface ShapeCurveBezierPathViewController ()
@property (nonatomic, strong) CAShapeLayer *layerShape1;
@property (nonatomic, strong) CAShapeLayer *layerShape2;
@property (nonatomic, strong) CAShapeLayer *layerShape3;
@property (nonatomic, strong) CAShapeLayer *layerShape4;
@end

@implementation ShapeCurveBezierPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.contentView.layer addSublayer:self.layerShape1];
    [self.contentView.layer addSublayer:self.layerShape2];
    [self.contentView.layer addSublayer:self.layerShape3];
    [self.contentView.layer addSublayer:self.layerShape4];
}

#pragma mark - CAShapeLayer

- (CAShapeLayer *)layerShape1 {
    if (!_layerShape1) {
        CGFloat side = 120.0;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(10, 10, side, side);
        layer.lineWidth = 2.0;
        layer.fillColor = nil;
        layer.strokeColor = [UIColor redColor].CGColor;
        SHOW_LAYER_BORDER(layer);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        [path moveToPoint:CGPointZero];
        [path addQuadCurveToPoint:CGPointMake(CGRectGetMaxX(layer.bounds), CGRectGetMaxY(layer.bounds)) controlPoint:CGPointMake(CGRectGetMaxX(layer.bounds), CGRectGetMinY(layer.bounds))];
        
        layer.path = path.CGPath;
        
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
        layer.strokeColor = [UIColor redColor].CGColor;
        SHOW_LAYER_BORDER(layer);
        
        CGFloat offsetX = 20;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        [path moveToPoint:CGPointZero];
        [path addQuadCurveToPoint:CGPointMake(CGRectGetMaxX(layer.bounds), CGRectGetMaxY(layer.bounds)) controlPoint:CGPointMake(CGRectGetMaxX(layer.bounds) + offsetX, CGRectGetMinY(layer.bounds))];
        
        layer.path = path.CGPath;
        
        _layerShape2 = layer;
    }
    
    return _layerShape2;
}

- (CAShapeLayer *)layerShape3 {
    if (!_layerShape3) {
        CGFloat side = 120.0;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(10, CGRectGetMaxY(_layerShape2.frame) + SpaceV, side, side);
        layer.lineWidth = 2.0;
        layer.fillColor = nil;
        layer.strokeColor = [UIColor redColor].CGColor;
        SHOW_LAYER_BORDER(layer);
        
        CGFloat offsetX = -20;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        [path moveToPoint:CGPointZero];
        [path addQuadCurveToPoint:CGPointMake(CGRectGetMaxX(layer.bounds), CGRectGetMaxY(layer.bounds)) controlPoint:CGPointMake(CGRectGetMaxX(layer.bounds) + offsetX, CGRectGetMinY(layer.bounds))];
        
        layer.path = path.CGPath;
        
        _layerShape3 = layer;
    }
    
    return _layerShape3;
}

- (CAShapeLayer *)layerShape4 {
    if (!_layerShape4) {
        CGFloat side = 120.0 * 2;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(10, CGRectGetMaxY(_layerShape3.frame) + SpaceV, side, side);
        layer.lineWidth = 2.0;
        layer.fillColor = nil;
        layer.strokeColor = [UIColor redColor].CGColor;
        SHOW_LAYER_BORDER(layer);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        [path moveToPoint:CGPointZero];
        
        CGPoint endPoint = CGPointMake(CGRectGetMaxX(layer.bounds), CGRectGetMaxY(layer.bounds));
        CGPoint controlPoint1 = CGPointMake(CGRectGetMidX(layer.bounds), CGRectGetMinY(layer.bounds));
        CGPoint controlPoint2 = CGPointMake(CGRectGetMidX(layer.bounds), CGRectGetMaxY(layer.bounds));
        
        [path addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
        
        layer.path = path.CGPath;
        
        _layerShape4 = layer;
    }
    
    return _layerShape4;
}

@end
