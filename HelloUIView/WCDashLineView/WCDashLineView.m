//
//  WCDashLineView.m
//  HelloUIView
//
//  Created by wesley_chen on 2019/7/1.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCDashLineView.h"

@interface WCDashLineView ()
@property (nonatomic, strong) CAShapeLayer *layerLine;
@end

@implementation WCDashLineView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self.layer addSublayer:layer];
        
        _layerLine = layer;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
 
    CGPoint startPoint = self.isHorizontal ? CGPointMake(0, self.bounds.size.height / 2.0) : CGPointMake(self.bounds.size.width / 2.0, 0);
    CGPoint endPoint = self.isHorizontal ? CGPointMake(self.bounds.size.width, self.bounds.size.height / 2.0) : CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    
    _layerLine.strokeColor = [self.lineColor CGColor];
    _layerLine.lineWidth = self.lineThickness;
    _layerLine.lineCap = self.isDotRounded ? kCALineCapRound : kCALineCapButt;
    _layerLine.lineDashPattern = self.isDotRounded ? @[ @(0.001), @(self.lineThickness + self.roundDotGap) ] : self.dashPattern;
    _layerLine.lineDashPhase = self.dashPatternOffset;
    _layerLine.path = path.CGPath;
}

@end
