//
//  ShapeLineStrokeStartEndBezierPathViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2020/6/14.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "ShapeLineStrokeStartEndBezierPathViewController.h"
#import "WCMacroTool.h"

@interface ShapeLineStrokeStartEndBezierPathViewController ()
@property (nonatomic, strong) CAShapeLayer *layerShape1;
@property (nonatomic, strong) CAShapeLayer *layerShape2;
@property (nonatomic, strong) CAShapeLayer *layerShape3;
@end

@implementation ShapeLineStrokeStartEndBezierPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self.contentView.layer addSublayer:self.layerShape1];
    [self.contentView.layer addSublayer:self.layerShape2];
    [self.contentView.layer addSublayer:self.layerShape3];
}

#pragma mark - CAShapeLayer

- (CAShapeLayer *)layerShape1 {
    if (!_layerShape1) {
        CGFloat side = 120.0;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(10, 10, side, side);
        layer.lineWidth = 10.0;
        layer.fillColor = [UIColor greenColor].CGColor;
        layer.strokeColor = [UIColor redColor].CGColor;
        layer.strokeStart = 0.2;
        //layer.strokeEnd = 0.8;
        SHOW_LAYER_BORDER(layer);

        // Note: path's coordinate is relative to the layer
        UIBezierPath *path = [UIBezierPath bezierPath];

        // Note: Create a triangle like `▽`
        CGPoint p1 = CGPointZero;
        CGPoint p2 = CGPointMake(CGRectGetMaxX(layer.bounds), 0);
        CGPoint p3 = CGPointMake(CGRectGetMaxX(layer.bounds) / 2.0, CGRectGetMaxY(layer.bounds));

        [path moveToPoint:p1];
        [path addLineToPoint:p2];
        [path addLineToPoint:p3];
        [path closePath];

        layer.path = path.CGPath;

        _layerShape1 = layer;
    }

    return _layerShape1;
}

- (CAShapeLayer *)layerShape2 {
    if (!_layerShape2) {
        CGFloat side = 120.0;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(10, CGRectGetMaxY(self.layerShape1.frame) + 20, side, side);
        layer.lineWidth = 10.0;
        layer.fillColor = [UIColor greenColor].CGColor;
        layer.strokeColor = [UIColor redColor].CGColor;
        //layer.strokeStart = 0.2;
        layer.strokeEnd = 0.2;
        SHOW_LAYER_BORDER(layer);

        // Note: path's coordinate is relative to the layer
        UIBezierPath *path = [UIBezierPath bezierPath];

        // Note: Create a triangle like `▽`
        CGPoint p1 = CGPointZero;
        CGPoint p2 = CGPointMake(CGRectGetMaxX(layer.bounds), 0);
        CGPoint p3 = CGPointMake(CGRectGetMaxX(layer.bounds) / 2.0, CGRectGetMaxY(layer.bounds));

        [path moveToPoint:p1];
        [path addLineToPoint:p2];
        [path addLineToPoint:p3];
        [path closePath];

        layer.path = path.CGPath;

        _layerShape2 = layer;
    }

    return _layerShape2;
}

- (CAShapeLayer *)layerShape3 {
    if (!_layerShape3) {
        CGFloat side = 120.0;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(10, CGRectGetMaxY(self.layerShape2.frame) + 20, side, side);
        layer.lineWidth = 10.0;
        layer.fillColor = [UIColor greenColor].CGColor;
        layer.strokeColor = [UIColor redColor].CGColor;
        layer.strokeStart = 0.2;
        layer.strokeEnd = 0.8;
        SHOW_LAYER_BORDER(layer);

        // Note: path's coordinate is relative to the layer
        UIBezierPath *path = [UIBezierPath bezierPath];

        // Note: Create a triangle like `▽`
        CGPoint p1 = CGPointZero;
        CGPoint p2 = CGPointMake(CGRectGetMaxX(layer.bounds), 0);
        CGPoint p3 = CGPointMake(CGRectGetMaxX(layer.bounds) / 2.0, CGRectGetMaxY(layer.bounds));

        [path moveToPoint:p1];
        [path addLineToPoint:p2];
        [path addLineToPoint:p3];
        [path closePath];

        layer.path = path.CGPath;

        _layerShape3 = layer;
    }

    return _layerShape3;
}

@end
