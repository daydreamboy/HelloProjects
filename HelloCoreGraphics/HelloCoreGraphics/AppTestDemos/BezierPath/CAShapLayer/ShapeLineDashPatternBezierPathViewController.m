//
//  ShapeLineDashPatternBezierPathViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2020/6/17.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "ShapeLineDashPatternBezierPathViewController.h"
#import <CoreGraphics/CoreGraphics.h>

#define LayerHeight 30
#define LayerSpace 10

@interface ShapeLineDashPatternBezierPathViewController ()
@property (nonatomic, strong) CAShapeLayer *layerShape1;
@property (nonatomic, strong) CAShapeLayer *layerShape2;
@property (nonatomic, strong) CAShapeLayer *layerShape3;
@property (nonatomic, strong) CAShapeLayer *layerShape4;
@end

@implementation ShapeLineDashPatternBezierPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.contentView.layer addSublayer:self.layerShape1];
    [self.contentView.layer addSublayer:self.layerShape2];
    [self.contentView.layer addSublayer:self.layerShape3];
    [self.contentView.layer addSublayer:self.layerShape4];
    
    [self addLayersAfterLayer:self.layerShape4];
}

#pragma mark -

- (void)addLayersAfterLayer:(CALayer *)frontLayer {
    CGFloat startY = CGRectGetMaxY(frontLayer.frame);
    CGFloat lineDashPhase = 5;
    for (NSUInteger i = 0; i <= 10; ++i) {
        CALayer *layer = [self createLineDashPhasedLayerWithStartY:startY lineDashPhase:lineDashPhase];
        [self.contentView.layer addSublayer:layer];
        
        startY = CGRectGetMaxY(layer.frame);
        lineDashPhase += i;
    }
}

- (CALayer *)createLineDashPhasedLayerWithStartY:(CGFloat)startY lineDashPhase:(CGFloat)lineDashPhase {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(0, startY + LayerSpace, screenSize.width, LayerHeight);
    layer.lineWidth = 5.0;
    layer.lineDashPattern = @[@5];
    layer.lineDashPhase = lineDashPhase;
    layer.strokeColor = [UIColor orangeColor].CGColor;
    SHOW_LAYER_BORDER(layer);
    
    CGFloat paddingH = 10;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(paddingH, CGRectGetHeight(layer.frame) / 2.0)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(layer.frame) - paddingH, CGRectGetHeight(layer.frame) / 2.0)];
    
    layer.path = path.CGPath;
    
    return layer;
}

#pragma mark - CAShapeLayer

- (CAShapeLayer *)layerShape1 {
    if (!_layerShape1) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, 0, screenSize.width, LayerHeight);
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
        
        _layerShape1 = layer;
    }
    
    return _layerShape1;
}

- (CAShapeLayer *)layerShape2 {
    if (!_layerShape2) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, CGRectGetMaxY(self.layerShape1.frame) + LayerSpace, screenSize.width, LayerHeight);
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
        layer.lineDashPattern = @[@10, @5, @5, @5];
        layer.lineDashPhase = 10;
        layer.strokeColor = [UIColor redColor].CGColor;
        SHOW_LAYER_BORDER(layer);
        
        CGFloat paddingH = 10;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
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
        layer.lineDashPattern = @[@5];
        layer.strokeColor = [UIColor redColor].CGColor;
        SHOW_LAYER_BORDER(layer);
        
        CGFloat paddingH = 10;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        [path moveToPoint:CGPointMake(paddingH, CGRectGetHeight(layer.frame) / 2.0)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(layer.frame) - paddingH, CGRectGetHeight(layer.frame) / 2.0)];
        
        layer.path = path.CGPath;
        
        _layerShape4 = layer;
    }
    
    return _layerShape4;
}

@end
