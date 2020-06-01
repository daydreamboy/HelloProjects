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

#define DEBUG_SHOW_LAYER_BORDER 1

#if DEBUG_SHOW_LAYER_BORDER
#define SHOW_LAYER_BORDER(layer) \
(layer).borderWidth = 1.0; \
(layer).borderColor = [UIColor blueColor].CGColor;
#else
#define SHOW_LAYER_BORDER(layer)
#endif


@interface ShapeLineBezierPathViewController ()
@property (nonatomic, strong) CAShapeLayer *layerLine1;
@property (nonatomic, strong) CAShapeLayer *layerLine2;
@property (nonatomic, strong) CAShapeLayer *layerLine3;
@property (nonatomic, strong) CAShapeLayer *layerLine4;
@property (nonatomic, strong) CAShapeLayer *layerLine5;
@end

@implementation ShapeLineBezierPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view.layer addSublayer:self.layerLine1];
    [self.view.layer addSublayer:self.layerLine2];
    [self.view.layer addSublayer:self.layerLine3];
    [self.view.layer addSublayer:self.layerLine4];
    [self.view.layer addSublayer:self.layerLine5];
}

#pragma mark - CAShapeLayer

- (CAShapeLayer *)layerLine1 {
    if (!_layerLine1) {
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
        
        _layerLine1 = layer;
    }
    
    return _layerLine1;
}

- (CAShapeLayer *)layerLine2 {
    if (!_layerLine2) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, CGRectGetMaxY(self.layerLine1.frame) + LayerSpace, screenSize.width, LayerHeight);
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
        
        _layerLine2 = layer;
    }
    
    return _layerLine2;
}

- (CAShapeLayer *)layerLine3 {
    if (!_layerLine3) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, CGRectGetMaxY(self.layerLine2.frame) + LayerSpace, screenSize.width, LayerHeight);
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
        
        _layerLine3 = layer;
    }
    
    return _layerLine3;
}

- (CAShapeLayer *)layerLine4 {
    if (!_layerLine4) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, CGRectGetMaxY(self.layerLine3.frame) + LayerSpace, screenSize.width, LayerHeight);
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
        
        _layerLine4 = layer;
    }
    
    return _layerLine4;
}

- (CAShapeLayer *)layerLine5 {
    if (!_layerLine5) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, CGRectGetMaxY(self.layerLine4.frame) + LayerSpace, screenSize.width, LayerHeight);
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
        
        _layerLine5 = layer;
    }
    
    return _layerLine5;
}

@end
