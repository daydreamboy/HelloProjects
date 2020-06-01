//
//  UseCAShapeLayerViewController.m
//  HelloUIView
//
//  Created by wesley_chen on 2020/6/1.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseCAShapeLayerViewController.h"

#define LayerHeight 40
#define LayerSpace 20

#define TriangleHeight 80
#define TriangleWidth 120

#define DEBUG_SHOW_LAYER_BORDER 1

#if DEBUG_SHOW_LAYER_BORDER
#define SHOW_LAYER_BORDER(layer) \
(layer).borderWidth = 1.0; \
(layer).borderColor = [UIColor blueColor].CGColor;
#else
#define SHOW_LAYER_BORDER(layer)
#endif

@interface UseCAShapeLayerViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) CAShapeLayer *layerShape1;
@property (nonatomic, strong) CAShapeLayer *layerShape2;
@property (nonatomic, strong) CAShapeLayer *layerShape3;
@property (nonatomic, strong) CAShapeLayer *layerShape4;
@property (nonatomic, strong) CAShapeLayer *layerShape5;
@property (nonatomic, strong) CAShapeLayer *layerShape6;
@property (nonatomic, strong) CAShapeLayer *layerShape7;
@property (nonatomic, strong) CAShapeLayer *layerShape8;
@property (nonatomic, strong) CAShapeLayer *layerShape9;
@property (nonatomic, strong) CAShapeLayer *layerShape10;
@property (nonatomic, strong) CAShapeLayer *layerShape11;
@property (nonatomic, strong) CAShapeLayer *layerShape12;
@end

@implementation UseCAShapeLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    [self.contentView.layer addSublayer:self.layerShape1];
    [self.contentView.layer addSublayer:self.layerShape2];
    [self.contentView.layer addSublayer:self.layerShape3];
    [self.contentView.layer addSublayer:self.layerShape4];
    [self.contentView.layer addSublayer:self.layerShape5];
    [self.contentView.layer addSublayer:self.layerShape6];
    [self.contentView.layer addSublayer:self.layerShape7];
    [self.contentView.layer addSublayer:self.layerShape8];
    [self.contentView.layer addSublayer:self.layerShape9];
    [self.contentView.layer addSublayer:self.layerShape10];
    [self.contentView.layer addSublayer:self.layerShape11];
    [self.contentView.layer addSublayer:self.layerShape12];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.scrollView.frame = self.view.bounds;
}

#pragma mark - Getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 3 * screenSize.width)];
        [scrollView addSubview:_contentView];
        scrollView.contentSize = CGSizeMake(CGRectGetWidth(_contentView.bounds), CGRectGetHeight(_contentView.bounds));
        
        _scrollView = scrollView;
    }
    
    return _scrollView;
}

#pragma mark - CAShapeLayer

- (CAShapeLayer *)layerShape1 {
    if (!_layerShape1) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, 0, screenSize.width, LayerHeight);
        layer.lineWidth = 10.0;
        layer.fillColor = [UIColor greenColor].CGColor;
        layer.strokeColor = [UIColor redColor].CGColor;
        SHOW_LAYER_BORDER(layer);
        
        CGFloat paddingH = 10;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(paddingH, CGRectGetHeight(layer.bounds) / 2.0)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(layer.bounds) - paddingH, CGRectGetHeight(layer.bounds) / 2.0)];
        
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
        layer.lineWidth = 10.0;
        layer.fillColor = [UIColor greenColor].CGColor;
        layer.strokeColor = [UIColor redColor].CGColor;
        layer.lineCap = kCALineCapRound;
        SHOW_LAYER_BORDER(layer);
        
        CGFloat paddingH = 10;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(paddingH, CGRectGetHeight(layer.bounds) / 2.0)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(layer.bounds) - paddingH, CGRectGetHeight(layer.bounds) / 2.0)];
        
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
        layer.lineWidth = 10.0;
        layer.fillColor = [UIColor greenColor].CGColor;
        layer.strokeColor = [UIColor redColor].CGColor;
        layer.lineCap = kCALineCapSquare;
        SHOW_LAYER_BORDER(layer);
        
        CGFloat paddingH = 10;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(paddingH, CGRectGetHeight(layer.bounds) / 2.0)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(layer.bounds) - paddingH, CGRectGetHeight(layer.bounds) / 2.0)];
        
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
        layer.lineWidth = 10.0;
        layer.fillColor = [UIColor greenColor].CGColor;
        //layer.strokeColor = [UIColor redColor].CGColor;
        SHOW_LAYER_BORDER(layer);
        
        CGFloat paddingH = 10;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(paddingH, CGRectGetHeight(layer.bounds) / 2.0)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(layer.bounds) - paddingH, CGRectGetHeight(layer.bounds) / 2.0)];
        
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
        layer.lineWidth = 10.0;
        layer.fillColor = [UIColor greenColor].CGColor;
        layer.strokeColor = [UIColor redColor].CGColor;
        layer.lineDashPattern = @[@2, @3];
        SHOW_LAYER_BORDER(layer);
        
        CGFloat paddingH = 10;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(paddingH, CGRectGetHeight(layer.bounds) / 2.0)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(layer.bounds) - paddingH, CGRectGetHeight(layer.bounds) / 2.0)];
        
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
        layer.strokeColor = [UIColor redColor].CGColor;
        layer.lineDashPattern = @[@10, @5, @5, @5];
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

- (CAShapeLayer *)layerShape7 {
    if (!_layerShape7) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, CGRectGetMaxY(self.layerShape6.frame) + LayerSpace, screenSize.width, LayerHeight);
        layer.lineWidth = 10.0;
        layer.fillColor = [UIColor greenColor].CGColor;
        layer.strokeColor = [UIColor redColor].CGColor;
        layer.lineDashPattern = @[@10, @5, @5, @5];
        layer.lineDashPhase = 10;
        SHOW_LAYER_BORDER(layer);
        
        CGFloat paddingH = 10;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(paddingH, CGRectGetHeight(layer.bounds) / 2.0)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(layer.bounds) - paddingH, CGRectGetHeight(layer.bounds) / 2.0)];
        
        layer.path = path.CGPath;
        
        _layerShape7 = layer;
    }
    
    return _layerShape7;
}

- (CAShapeLayer *)layerShape8 {
    if (!_layerShape8) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;

        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, CGRectGetMaxY(self.layerShape7.frame) + LayerSpace, screenSize.width, TriangleHeight);
        layer.lineWidth = 10.0;
        layer.fillColor = [UIColor greenColor].CGColor;
        layer.strokeColor = [UIColor redColor].CGColor;
        SHOW_LAYER_BORDER(layer);

        CGFloat paddingH = 10;

        // Note: path's coordinate is relative to the layer
        UIBezierPath *path = [UIBezierPath bezierPath];

        // Note: Create a triangle like `▽`
        CGPoint p1 = CGPointMake(paddingH, 0);
        CGPoint p2 = CGPointMake(paddingH + TriangleWidth, 0);
        CGPoint p3 = CGPointMake(paddingH + TriangleWidth / 2.0, CGRectGetHeight(layer.bounds));

        [path moveToPoint:p1];
        [path addLineToPoint:p2];
        [path addLineToPoint:p3];
        //[path closePath];

        layer.path = path.CGPath;

        _layerShape8 = layer;
    }

    return _layerShape8;
}

- (CAShapeLayer *)layerShape9 {
    if (!_layerShape9) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;

        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, CGRectGetMaxY(self.layerShape8.frame) + LayerSpace, screenSize.width, TriangleHeight);
        layer.lineWidth = 10.0;
        layer.fillColor = [UIColor greenColor].CGColor;
        layer.strokeColor = [UIColor redColor].CGColor;
        SHOW_LAYER_BORDER(layer);

        CGFloat paddingH = 10;

        // Note: path's coordinate is relative to the layer
        UIBezierPath *path = [UIBezierPath bezierPath];

        // Note: Create a triangle like `▽`
        CGPoint p1 = CGPointMake(paddingH, 0);
        CGPoint p2 = CGPointMake(paddingH + TriangleWidth, 0);
        CGPoint p3 = CGPointMake(paddingH + TriangleWidth / 2.0, CGRectGetHeight(layer.bounds));

        [path moveToPoint:p1];
        [path addLineToPoint:p2];
        [path addLineToPoint:p3];
        [path closePath];

        layer.path = path.CGPath;

        _layerShape9 = layer;
    }

    return _layerShape9;
}

- (CAShapeLayer *)layerShape10 {
    if (!_layerShape10) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;

        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, CGRectGetMaxY(self.layerShape9.frame) + LayerSpace, screenSize.width, TriangleHeight);
        layer.lineWidth = 10.0;
        layer.fillColor = [UIColor greenColor].CGColor;
        layer.strokeColor = [UIColor redColor].CGColor;
        layer.lineJoin = kCALineJoinMiter;
        layer.miterLimit = 2; // TODO: I don't know miterLimit usage
        SHOW_LAYER_BORDER(layer);

        CGFloat paddingH = 10;

        // Note: path's coordinate is relative to the layer
        UIBezierPath *path = [UIBezierPath bezierPath];

        // Note: Create a triangle like `▽`
        CGPoint p1 = CGPointMake(paddingH, 0);
        CGPoint p2 = CGPointMake(paddingH + TriangleWidth, 0);
        CGPoint p3 = CGPointMake(paddingH + TriangleWidth / 2.0, CGRectGetHeight(layer.bounds));

        [path moveToPoint:p1];
        [path addLineToPoint:p2];
        [path addLineToPoint:p3];
        [path closePath];

        layer.path = path.CGPath;

        _layerShape10 = layer;
    }

    return _layerShape10;
}

- (CAShapeLayer *)layerShape11 {
    if (!_layerShape11) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;

        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, CGRectGetMaxY(self.layerShape10.frame) + LayerSpace, screenSize.width, TriangleHeight);
        layer.lineWidth = 10.0;
        layer.fillColor = [UIColor greenColor].CGColor;
        layer.strokeColor = [UIColor redColor].CGColor;
        layer.lineJoin = kCALineJoinBevel;
        SHOW_LAYER_BORDER(layer);

        CGFloat paddingH = 10;

        // Note: path's coordinate is relative to the layer
        UIBezierPath *path = [UIBezierPath bezierPath];

        // Note: Create a triangle like `▽`
        CGPoint p1 = CGPointMake(paddingH, 0);
        CGPoint p2 = CGPointMake(paddingH + TriangleWidth, 0);
        CGPoint p3 = CGPointMake(paddingH + TriangleWidth / 2.0, CGRectGetHeight(layer.bounds));

        [path moveToPoint:p1];
        [path addLineToPoint:p2];
        [path addLineToPoint:p3];
        [path closePath];

        layer.path = path.CGPath;

        _layerShape11 = layer;
    }

    return _layerShape11;
}

- (CAShapeLayer *)layerShape12 {
    if (!_layerShape12) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;

        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, CGRectGetMaxY(self.layerShape11.frame) + LayerSpace, screenSize.width, TriangleHeight);
        layer.lineWidth = 10.0;
        layer.fillColor = [UIColor greenColor].CGColor;
        layer.strokeColor = [UIColor redColor].CGColor;
        layer.lineJoin = kCALineJoinRound;
        SHOW_LAYER_BORDER(layer);

        CGFloat paddingH = 10;

        // Note: path's coordinate is relative to the layer
        UIBezierPath *path = [UIBezierPath bezierPath];

        // Note: Create a triangle like `▽`
        CGPoint p1 = CGPointMake(paddingH, 0);
        CGPoint p2 = CGPointMake(paddingH + TriangleWidth, 0);
        CGPoint p3 = CGPointMake(paddingH + TriangleWidth / 2.0, CGRectGetHeight(layer.bounds));

        [path moveToPoint:p1];
        [path addLineToPoint:p2];
        [path addLineToPoint:p3];
        [path closePath];

        layer.path = path.CGPath;

        _layerShape12 = layer;
    }

    return _layerShape12;
}

@end
