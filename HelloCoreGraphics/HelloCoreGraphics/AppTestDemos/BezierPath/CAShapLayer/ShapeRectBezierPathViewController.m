//
//  ShapeRectBezierPathViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2020/6/14.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "ShapeRectBezierPathViewController.h"
#import "WCMacroTool.h"

#define LayerHeight 40
#define LayerSpace 20

@interface ShapeRectBezierPathViewController ()
@property (nonatomic, strong) CAShapeLayer *layerShape1;
@end

@implementation ShapeRectBezierPathViewController

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
        //SHOW_LAYER_BORDER(layer);
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:layer.bounds];
        layer.path = path.CGPath;
        
        _layerShape1 = layer;
    }
    
    return _layerShape1;
}

@end
