//
//  DrawLineBezierPathViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2020/6/1.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "DrawLineBezierPathViewController.h"

@interface MyDrawingView1 : UIView

@end

@implementation MyDrawingView1

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

@interface DrawLineBezierPathViewController ()
@property (nonatomic, strong) MyDrawingView1 *drawingView;
@end

@implementation DrawLineBezierPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.view addSubview:self.drawingView];
}

#pragma mark - Getter

- (MyDrawingView1 *)drawingView {
    if (!_drawingView) {
        _drawingView = [[MyDrawingView1 alloc] initWithFrame:self.view.bounds];
    }
    
    return _drawingView;
}

@end
