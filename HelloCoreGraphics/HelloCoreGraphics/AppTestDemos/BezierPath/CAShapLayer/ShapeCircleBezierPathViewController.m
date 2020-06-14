//
//  ShapeCircleBezierPathViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2020/6/14.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "ShapeCircleBezierPathViewController.h"

@interface ShapeCircleBezierPathViewController ()
@property (nonatomic, strong) CAShapeLayer *layerShape1;
@end

@implementation ShapeCircleBezierPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.contentView.layer addSublayer:self.layerShape1];
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
        
        
        CGPoint arcCenter = layer.position;
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

@end
