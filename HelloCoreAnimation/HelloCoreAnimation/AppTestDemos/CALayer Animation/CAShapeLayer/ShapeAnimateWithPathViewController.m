//
//  ShapeAnimateWithPathViewController.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 2020/6/14.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import "ShapeAnimateWithPathViewController.h"
#import "WCMacroTool.h"

@interface ShapeAnimateWithPathViewController ()
@property (nonatomic, strong) CAShapeLayer *layerShape1;
@property (nonatomic, strong) CAShapeLayer *layerShape2;
@end

@implementation ShapeAnimateWithPathViewController

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
        //SHOW_LAYER_BORDER(layer);
        
        UIBezierPath *startPath = [UIBezierPath bezierPath];
        
        [startPath moveToPoint:CGPointMake(81.5, 7.0)];
        [startPath addLineToPoint:CGPointMake(101.07, 63.86)];
        [startPath addLineToPoint:CGPointMake(163.0, 64.29)];
        [startPath addLineToPoint:CGPointMake(113.16, 99.87)];
        [startPath addLineToPoint:CGPointMake(131.87, 157.0)];
        [startPath addLineToPoint:CGPointMake(81.5, 122.13)];
        [startPath addLineToPoint:CGPointMake(31.13, 157.0)];
        [startPath addLineToPoint:CGPointMake(49.84, 99.87)];
        [startPath addLineToPoint:CGPointMake(0.0, 64.29)];
        [startPath addLineToPoint:CGPointMake(61.93, 63.86)];
        [startPath addLineToPoint:CGPointMake(81.5, 7.0)];
        
        layer.path = startPath.CGPath;
        
        UIBezierPath *rectanglePath = [UIBezierPath bezierPath];
        [rectanglePath moveToPoint:CGPointMake(81.5, 7.0)];
        [rectanglePath addLineToPoint:CGPointMake(163.0, 7.0)];
        [rectanglePath addLineToPoint:CGPointMake(163.0, 82.0)];
        [rectanglePath addLineToPoint:CGPointMake(163.0, 157.0)];
        [rectanglePath addLineToPoint:CGPointMake(163.0, 157.0)];
        [rectanglePath addLineToPoint:CGPointMake(82.0, 157.0)];
        [rectanglePath addLineToPoint:CGPointMake(0.0, 157.0)];
        [rectanglePath addLineToPoint:CGPointMake(0.0, 157.0)];
        [rectanglePath addLineToPoint:CGPointMake(0.0, 82.0)];
        [rectanglePath addLineToPoint:CGPointMake(0.0, 7.0)];
        [rectanglePath addLineToPoint:CGPointMake(81.5, 7.0)];
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        
        // Note: use toValue = (id)rectanglePath.CGPath instead of toValue = rectanglePath
        pathAnimation.toValue = (id)rectanglePath.CGPath;
        pathAnimation.duration = 0.75;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.autoreverses = YES;
        pathAnimation.repeatCount = HUGE_VALF;

        [layer addAnimation:pathAnimation forKey:@"pathAnimation"];
        
        _layerShape1 = layer;
    }
    
    return _layerShape1;
}

- (CAShapeLayer *)layerShape2 {
    if (!_layerShape2) {
        CGFloat side = 120.0;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(10, CGRectGetMaxY(self.layerShape1.frame) + 50, side, side);
        layer.lineWidth = 2.0;
        layer.fillColor = nil;
        layer.strokeColor = UICOLOR_RGB(0xD02FAE).CGColor;
        //SHOW_LAYER_BORDER(layer);
        
        UIBezierPath *startPath = [UIBezierPath bezierPath];
        
        [startPath moveToPoint:CGPointMake(81.5, 7.0)];
        [startPath addLineToPoint:CGPointMake(101.07, 63.86)];
        [startPath addLineToPoint:CGPointMake(163.0, 64.29)];
        [startPath addLineToPoint:CGPointMake(113.16, 99.87)];
        [startPath addLineToPoint:CGPointMake(131.87, 157.0)];
        [startPath addLineToPoint:CGPointMake(81.5, 122.13)];
        [startPath addLineToPoint:CGPointMake(31.13, 157.0)];
        [startPath addLineToPoint:CGPointMake(49.84, 99.87)];
        [startPath addLineToPoint:CGPointMake(0.0, 64.29)];
        [startPath addLineToPoint:CGPointMake(61.93, 63.86)];
        [startPath addLineToPoint:CGPointMake(81.5, 7.0)];
        
        layer.path = startPath.CGPath;
        
        UIBezierPath *rectanglePath = [UIBezierPath bezierPath];
        [rectanglePath moveToPoint:CGPointMake(0.0, 7.0)];
        [rectanglePath addLineToPoint:CGPointMake(163.0, 7.0)];
        [rectanglePath addLineToPoint:CGPointMake(163.0, 157.0)];
        [rectanglePath addLineToPoint:CGPointMake(0.0, 157.0)];
        [rectanglePath addLineToPoint:CGPointMake(0.0, 7.0)];

        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        
        // Note: use toValue = (id)rectanglePath.CGPath instead of toValue = rectanglePath
        pathAnimation.toValue = (id)rectanglePath.CGPath;
        pathAnimation.duration = 0.75;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.autoreverses = YES;
        pathAnimation.repeatCount = HUGE_VALF;

        [layer addAnimation:pathAnimation forKey:@"pathAnimation"];
        
        _layerShape2 = layer;
    }
    
    return _layerShape2;
}

@end
