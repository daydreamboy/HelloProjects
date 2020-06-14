//
//  ShapeLineBezierPathViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2020/6/1.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "ShapeLineBezierPathViewController.h"
#import <CoreGraphics/CoreGraphics.h>

#define LayerHeight 30
#define LayerSpace 10

@interface ShapeLineBezierPathViewController ()
@property (nonatomic, strong) CAShapeLayer *layerShape1;
@property (nonatomic, strong) CAShapeLayer *layerShape2;
@property (nonatomic, strong) CAShapeLayer *layerShape3;
@property (nonatomic, strong) CAShapeLayer *layerShape4;
@property (nonatomic, strong) CAShapeLayer *layerShape5;
@property (nonatomic, strong) CAShapeLayer *layerShape6;
@end

@implementation ShapeLineBezierPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.contentView.layer addSublayer:self.layerShape1];
    [self.contentView.layer addSublayer:self.layerShape2];
    [self.contentView.layer addSublayer:self.layerShape3];
    [self.contentView.layer addSublayer:self.layerShape4];
    [self.contentView.layer addSublayer:self.layerShape5];
    [self.contentView.layer addSublayer:self.layerShape6];
}

#pragma mark - CAShapeLayer

- (CAShapeLayer *)layerShape1 {
    if (!_layerShape1) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        // @see https://stackoverflow.com/a/26663083
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, 0, screenSize.width, LayerHeight);
        layer.lineWidth = 1.0;
        layer.strokeColor = [UIColor redColor].CGColor;
        SHOW_LAYER_BORDER(layer);
        
        CGFloat paddingH = 10;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(paddingH, CGRectGetHeight(layer.frame) / 2.0)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(layer.frame) - paddingH, CGRectGetHeight(layer.frame) / 2.0)];
        
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
        layer.lineWidth = 3.0;
        layer.strokeColor = [UIColor redColor].CGColor;
        SHOW_LAYER_BORDER(layer);
        
        CGFloat paddingH = 10;
        
        // Note: path's coordinate is relative to the layer
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        // Note: not use CGRectGetMidY(layer.frame) instead of CGRectGetHeight(layer.frame) / 2.0
        [path moveToPoint:CGPointMake(paddingH, CGRectGetHeight(layer.frame) / 2.0)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(layer.frame) - paddingH, CGRectGetHeight(layer.frame) / 2.0)];
        
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
        layer.lineWidth = 5.0;
        layer.lineDashPattern = @[@2, @3];
        layer.strokeColor = [UIColor redColor].CGColor;
        SHOW_LAYER_BORDER(layer);
        
        CGFloat paddingH = 10;
        
        // Note: path's coordinate is relative to the layer
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        // Note: not use CGRectGetMidY(layer.frame) instead of CGRectGetHeight(layer.frame) / 2.0
        [path moveToPoint:CGPointMake(paddingH, CGRectGetHeight(layer.frame) / 2.0)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(layer.frame) - paddingH, CGRectGetHeight(layer.frame) / 2.0)];
        
        layer.path = path.CGPath;
        
        _layerShape3 = layer;
    }
    
    return _layerShape3;
}

- (CAShapeLayer *)layerShape4 {
    if (!_layerShape4) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, CGRectGetMaxY(self.layerShape3.frame) + LayerSpace, screenSize.width, LayerHeight);
        layer.lineWidth = 5.0;
        layer.lineDashPattern = @[@10, @5, @5, @5];
        layer.strokeColor = [UIColor redColor].CGColor;
        SHOW_LAYER_BORDER(layer);
        
        CGFloat paddingH = 10;
        
        // Note: path's coordinate is relative to the layer
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        // Note: not use CGRectGetMidY(layer.frame) instead of CGRectGetHeight(layer.frame) / 2.0
        [path moveToPoint:CGPointMake(paddingH, CGRectGetHeight(layer.frame) / 2.0)];
        //CGPathMoveToPoint(path.CGPath, NULL, paddingH, CGRectGetHeight(layer.frame) / 2.0);
        [path addLineToPoint:CGPointMake(CGRectGetWidth(layer.frame) - paddingH, CGRectGetHeight(layer.frame) / 2.0)];
        
        layer.path = path.CGPath;
        
        _layerShape4 = layer;
    }
    
    return _layerShape4;
}

- (CAShapeLayer *)layerShape5 {
    if (!_layerShape5) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, CGRectGetMaxY(self.layerShape4.frame) + LayerSpace, screenSize.width, LayerHeight);
        layer.lineWidth = 5.0;
        layer.lineDashPattern = @[@10, @5, @5, @5];
        layer.lineDashPhase = 10;
        layer.strokeColor = [UIColor redColor].CGColor;
        SHOW_LAYER_BORDER(layer);
        
        CGFloat paddingH = 10;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        [path moveToPoint:CGPointMake(paddingH, CGRectGetHeight(layer.frame) / 2.0)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(layer.frame) - paddingH, CGRectGetHeight(layer.frame) / 2.0)];
        
        layer.path = path.CGPath;
        
        _layerShape5 = layer;
    }
    
    return _layerShape5;
}

- (CAShapeLayer *)layerShape6 {
    if (!_layerShape6) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;

        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, CGRectGetMaxY(self.layerShape5.frame) + LayerSpace, screenSize.width, LayerHeight);
        layer.lineWidth = 10.0;
        layer.fillColor = [UIColor greenColor].CGColor;
        //layer.strokeColor = [UIColor redColor].CGColor;
        SHOW_LAYER_BORDER(layer);

        CGFloat paddingH = 10;

        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(paddingH, CGRectGetHeight(layer.bounds) / 2.0)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(layer.bounds) - paddingH, CGRectGetHeight(layer.bounds) / 2.0)];

        layer.path = path.CGPath;

        _layerShape6 = layer;
    }

    return _layerShape6;
}

@end
