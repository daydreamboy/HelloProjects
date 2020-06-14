//
//  ShapeFillPatternImageBezierPathViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2020/6/14.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "ShapeFillPatternImageBezierPathViewController.h"

@interface ShapeFillPatternImageBezierPathViewController ()
@property (nonatomic, strong) CAShapeLayer *layerShape1;
@property (nonatomic, strong) CAShapeLayer *layerShape2;
@property (nonatomic, strong) CAShapeLayer *layerShape3;
@end

@implementation ShapeFillPatternImageBezierPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.contentView.layer addSublayer:self.layerShape1];
    [self.contentView.layer addSublayer:self.layerShape2];
    //[self.contentView.layer addSublayer:self.layerShape3];
}

#pragma mark - CAShapeLayer

- (CAShapeLayer *)layerShape1 {
    if (!_layerShape1) {
        CGFloat side = 120.0;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(10, 10, side, side);
        layer.lineWidth = 2.0;
        // Note: pattern1.png from https://ddeville.me/2010/12/uicolor-with-pattern-image/
        layer.fillColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern1"]].CGColor;
        layer.strokeColor = [UIColor redColor].CGColor;
        //SHOW_LAYER_BORDER(layer);
        
        CGPoint arcCenter = CGPointMake(layer.bounds.size.width / 2.0, layer.bounds.size.height / 2.0);
        CGFloat radius = layer.bounds.size.width / 2.0;
        CGFloat startAngle = 0;
        CGFloat endAngle = M_PI * 2;
        BOOL clockwise = YES;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
        
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
        layer.fillColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern2"]].CGColor;
        layer.strokeColor = [UIColor redColor].CGColor;
        //SHOW_LAYER_BORDER(layer);
        
        CGPoint arcCenter = CGPointMake(layer.bounds.size.width / 2.0, layer.bounds.size.height / 2.0);
        CGFloat radius = layer.bounds.size.width / 2.0;
        CGFloat startAngle = 0;
        CGFloat endAngle = M_PI * 2;
        BOOL clockwise = YES;
        
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
        layer.frame = CGRectMake(10, CGRectGetMaxY(self.layerShape2.frame) + 10, side, side);
        layer.lineWidth = 2.0;
        layer.fillColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern1"]].CGColor;
        layer.strokeColor = [UIColor redColor].CGColor;
        //SHOW_LAYER_BORDER(layer);
        
        CGPoint arcCenter = CGPointMake(layer.bounds.size.width / 2.0, layer.bounds.size.height / 2.0);
        CGFloat radius = layer.bounds.size.width / 2.0;
        CGFloat startAngle = 0;
        CGFloat endAngle = M_PI * 2;
        BOOL clockwise = YES;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
        
        layer.path = path.CGPath;
        
        _layerShape3 = layer;
    }
    
    return _layerShape3;
}

@end
