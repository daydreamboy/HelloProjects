//
//  DrawArcBezierPathViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2020/5/26.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "DrawArcBezierPathViewController.h"

@interface MyDrawingView2 : UIView

@end

@implementation MyDrawingView2

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, (CGRect){CGPointZero, rect.size});
    
    // @see https://stackoverflow.com/questions/26662415/draw-a-line-with-uibezierpath
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    //bezierPath.lineWidth = 1.0;
    [bezierPath moveToPoint:CGPointMake(10, 10)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect) - 50, CGRectGetHeight(rect) - 50)];
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    [bezierPath stroke];
}

@end

@interface DrawArcBezierPathViewController ()
@property (nonatomic, strong) MyDrawingView2 *drawingView;
@end

@implementation DrawArcBezierPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.view addSubview:self.drawingView];
}

#pragma mark - Getter

- (MyDrawingView2 *)drawingView {
    if (!_drawingView) {
        _drawingView = [[MyDrawingView2 alloc] initWithFrame:self.view.bounds];
    }
    
    return _drawingView;
}

@end
