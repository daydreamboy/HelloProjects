//
//  ShapeOpenPathBezierPathViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2020/6/14.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "ShapeOpenPathBezierPathViewController.h"

@interface ShapeOpenPathBezierPathViewController ()
@property (nonatomic, strong) CAShapeLayer *layerShape1;
@property (nonatomic, strong) CAShapeLayer *layerShape2;
@property (nonatomic, strong) CAShapeLayer *layerShape3;
@end

@implementation ShapeOpenPathBezierPathViewController

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
        layer.lineWidth = 2.0;
        layer.fillColor = nil;
        layer.strokeColor = [UIColor redColor].CGColor;
        //SHOW_LAYER_BORDER(layer);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointZero];
        [path addLineToPoint:CGPointMake(0, CGRectGetMaxY(layer.bounds))];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(layer.bounds), CGRectGetMaxY(layer.bounds))];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(layer.bounds), 0)];
        
        layer.path = path.CGPath;
        
        _layerShape1 = layer;
    }
    
    return _layerShape1;
}

- (CAShapeLayer *)layerShape2 {
    if (!_layerShape2) {
        CGFloat side = 120.0;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(10, CGRectGetMaxY(self.layerShape1.frame) + 10, side, side);
        layer.lineWidth = 2.0;
        layer.fillColor = nil;
        layer.strokeColor = [UIColor redColor].CGColor;
        //SHOW_LAYER_BORDER(layer);
        
        CGPoint arcCenter = CGPointMake(layer.bounds.size.width / 2.0, layer.bounds.size.height / 2.0);
        CGFloat radius = layer.bounds.size.width / 2.0;
        CGFloat startAngle = 0;
        CGFloat endAngle = M_PI;
        BOOL clockwise = NO;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
        
        layer.path = path.CGPath;
        
        _layerShape2 = layer;
    }
    
    return _layerShape2;
}

- (CAShapeLayer *)layerShape3 {
    if (!_layerShape3) {
        CGFloat side = 120.0;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(10, CGRectGetMaxY(self.layerShape2.frame) + 30, side, side);
        layer.lineWidth = 2.0;
        layer.fillColor = nil;
        layer.strokeColor = [UIColor redColor].CGColor;
        SHOW_LAYER_BORDER(layer);
        
        __unused CGRect shapeBounds = layer.bounds;
        CGPoint center = CGPointMake(layer.bounds.size.width / 2.0, layer.bounds.size.height / 2.0);
        
        NSUInteger numberOfPoints = 5;
        NSUInteger numberOfLineSegments = numberOfPoints * 2;
        CGFloat theta = M_PI / numberOfPoints;
        
        CGFloat circumscribedRadius = center.x;
        CGFloat outterRadius = circumscribedRadius * 1.039;
        __unused CGFloat excessRadius = outterRadius - circumscribedRadius;
        CGFloat innerRadius = outterRadius * 0.382;
        
        CGFloat leftEdgePointX = center.x + cos(4.0 * theta) * outterRadius;
        CGFloat horizontalOffset = leftEdgePointX / 2.0;
        
        //
        CGPoint offsetCenter = CGPointMake(center.x - horizontalOffset, center.y);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        for (NSInteger i = 0; i < numberOfLineSegments - 1; ++i) {
            CGFloat radius = i % 2 == 0 ? outterRadius : innerRadius;
            
            CGFloat pointX = offsetCenter.x + cos(i * theta) *radius;
            CGFloat pointY = offsetCenter.y + sin(i * theta) *radius;
            CGPoint point = CGPointMake(pointX, pointY);
            
            if (i == 0) {
                [path moveToPoint:point];
            }
            else {
                [path addLineToPoint:point];
            }
        }
        
        //[path closePath];
        
        /*
        CGAffineTransform pathTransform = CGAffineTransformIdentity;
        pathTransform = CGAffineTransformTranslate(pathTransform, center.x, center.y);
        pathTransform = CGAffineTransformRotate(pathTransform, -M_PI / 2.0);
        pathTransform = CGAffineTransformTranslate(pathTransform, -center.x, -center.y);

        [path applyTransform:pathTransform];
         */
        
        layer.path = path.CGPath;
        
        _layerShape3 = layer;
    }
    
    return _layerShape3;
}

@end
