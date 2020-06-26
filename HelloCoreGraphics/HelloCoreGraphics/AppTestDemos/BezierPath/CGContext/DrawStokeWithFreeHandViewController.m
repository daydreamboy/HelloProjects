//
//  DrawStokeWithFreeHandViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2020/6/26.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "DrawStokeWithFreeHandViewController.h"
#import "WCMacroTool.h"
#import "WCViewTool.h"

// Tutorial: @see https://code.tutsplus.com/tutorials/smooth-freehand-drawing-on-ios--mobile-13164
#define MyDrawingView1  LinearInterpolationView
#define MyDrawingView2  CachedLinearInterpolationView
#define MyDrawingView3  CachedBezierInterpolationView
#define MyDrawingView4  CachedSmoothedInterpolationView

#pragma mark - MyDrawingView1

DRAWING_VIEW_CLASS_DECLARATION_BEGIN(MyDrawingView1)
@property (nonatomic, strong) UIBezierPath *path;
DRAWING_VIEW_CLASS_DECLARATION_END

DRAWING_VIEW_CLASS_IMPLEMENTATION_BEGIN(MyDrawingView1)

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.multipleTouchEnabled = NO;
        self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
        
        _path = [UIBezierPath bezierPath];
        _path.lineWidth = 2.0;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [[UIColor blackColor] setStroke];
    [self.path stroke];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [self.path moveToPoint:p];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [self.path addLineToPoint:p];
    [self setNeedsDisplay];
}
 
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesMoved:touches withEvent:event];
}
 
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

DRAWING_VIEW_CLASS_IMPLEMENTATION_END


#pragma mark - MyDrawingView2

DRAWING_VIEW_CLASS_DECLARATION_BEGIN(MyDrawingView2)
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) UIImage *incrementalImage;
DRAWING_VIEW_CLASS_DECLARATION_END

DRAWING_VIEW_CLASS_IMPLEMENTATION_BEGIN(MyDrawingView2)

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.multipleTouchEnabled = NO;
        self.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.4];
        
        _path = [UIBezierPath bezierPath];
        _path.lineWidth = 2.0;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self.incrementalImage drawInRect:rect];
    [self.path stroke];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [self.path moveToPoint:p];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [self.path addLineToPoint:p];
    [self setNeedsDisplay];
}
 
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [self.path addLineToPoint:p];
    [self drawBitmap];
    [self setNeedsDisplay];
    [self.path removeAllPoints];
}
 
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

- (void)drawBitmap {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    [[UIColor blackColor] setStroke];
    if (!self.incrementalImage) { // first draw; paint background white by ...
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds]; // enclosing bitmap by a rectangle defined by another UIBezierPath object
        [self.backgroundColor setFill];
        [rectpath fill];
    }
    [self.incrementalImage drawAtPoint:CGPointZero];
    [self.path stroke];
    self.incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

DRAWING_VIEW_CLASS_IMPLEMENTATION_END


#pragma mark - MyDrawingView3

DRAWING_VIEW_CLASS_DECLARATION_BEGIN(MyDrawingView3)
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) UIImage *incrementalImage;
DRAWING_VIEW_CLASS_DECLARATION_END

DRAWING_VIEW_CLASS_IMPLEMENTATION_BEGIN(MyDrawingView3) {
    CGPoint _points[4]; // to keep track of the four points of our Bezier segment
    uint _counter; // a counter variable to keep track of the point index
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.multipleTouchEnabled = NO;
        self.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.4];
        
        _path = [UIBezierPath bezierPath];
        _path.lineWidth = 2.0;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self.incrementalImage drawInRect:rect];
    [self.path stroke];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _counter = 0;
    UITouch *touch = [touches anyObject];
    _points[0] = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    _counter++;
    _points[_counter] = p;
    
    if (_counter == 3) { // 4th point
        [self.path moveToPoint:_points[0]];
        [self.path addCurveToPoint:_points[3] controlPoint1:_points[1] controlPoint2:_points[2]];
        [self setNeedsDisplay];
        
        _points[0] = [self.path currentPoint];
        _counter = 0;
    }
}
 
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self drawBitmap];
    [self setNeedsDisplay];
    _points[0] = [self.path currentPoint];
    [self.path removeAllPoints];
    _counter = 0;
}
 
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

- (void)drawBitmap {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    [[UIColor blackColor] setStroke];
    if (!self.incrementalImage) { // first draw; paint background white by ...
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds]; // enclosing bitmap by a rectangle defined by another UIBezierPath object
        [self.backgroundColor setFill];
        [rectpath fill];
    }
    [self.incrementalImage drawAtPoint:CGPointZero];
    [self.path stroke];
    self.incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

DRAWING_VIEW_CLASS_IMPLEMENTATION_END


#pragma mark - MyDrawingView4

DRAWING_VIEW_CLASS_DECLARATION_BEGIN(MyDrawingView4)
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) UIImage *incrementalImage;
DRAWING_VIEW_CLASS_DECLARATION_END

DRAWING_VIEW_CLASS_IMPLEMENTATION_BEGIN(MyDrawingView4) {
    CGPoint _points[5]; // we now need to keep track of the four points of a Bezier segment and the first control point of the next segment
    uint _counter; // a counter variable to keep track of the point index
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.multipleTouchEnabled = NO;
        self.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.4];
        
        _path = [UIBezierPath bezierPath];
        _path.lineWidth = 2.0;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self.incrementalImage drawInRect:rect];
    [self.path stroke];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _counter = 0;
    UITouch *touch = [touches anyObject];
    _points[0] = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    _counter++;
    _points[_counter] = p;
    
    if (_counter == 4) {
        // move the endpoint to the middle of the line joining the second control point of the first Bezier segment and the first control point of the second Bezier segment
        _points[3] = CGPointMake((_points[2].x + _points[4].x) / 2.0, (_points[2].y + _points[4].y) / 2.0);
        
        [self.path moveToPoint:_points[0]];
        // add a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]
        [self.path addCurveToPoint:_points[3] controlPoint1:_points[1] controlPoint2:_points[2]];
        [self setNeedsDisplay];
        
        // replace points and get ready to handle the next segment
        _points[0] = _points[3];
        _points[1] = _points[4];
        _counter = 1;
    }
}
 
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self drawBitmap];
    [self setNeedsDisplay];
    [self.path removeAllPoints];
    _counter = 0;
}
 
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

- (void)drawBitmap {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    [[UIColor blackColor] setStroke];
    if (!self.incrementalImage) { // first draw; paint background white by ...
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds]; // enclosing bitmap by a rectangle defined by another UIBezierPath object
        [self.backgroundColor setFill];
        [rectpath fill];
    }
    [self.incrementalImage drawAtPoint:CGPointZero];
    [self.path stroke];
    self.incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

DRAWING_VIEW_CLASS_IMPLEMENTATION_END

#pragma mark -

@interface DrawStokeWithFreeHandViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIView *drawingView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, assign) BOOL pickerViewShown;
@property (nonatomic, strong) NSArray<NSString *> *canvasList;
@property (nonatomic, copy) NSString *currentCanvasName;
@end

@implementation DrawStokeWithFreeHandViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _canvasList = @[
            STR_OF_LITERAL(MyDrawingView1),
            STR_OF_LITERAL(MyDrawingView2),
            STR_OF_LITERAL(MyDrawingView3),
            STR_OF_LITERAL(MyDrawingView4),
        ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.pickerView];
    
    UIBarButtonItem *chooseItem = [[UIBarButtonItem alloc] initWithTitle:@"Choose canvas" style:UIBarButtonItemStylePlain target:self action:@selector(chooseItemClicked:)];
    UIBarButtonItem *toggleItem = [[UIBarButtonItem alloc] initWithTitle:@"Hide picker" style:UIBarButtonItemStylePlain target:self action:@selector(toggleItemClicked:)];
    
    self.navigationItem.rightBarButtonItems = @[ chooseItem, toggleItem];
    
    self.currentCanvasName = [self.canvasList firstObject];
    self.pickerViewShown = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat y = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(_pickerView.bounds) - [WCViewTool safeAreaInsetsWithView:self.view].bottom;
    self.pickerView.frame = FrameSetOrigin(self.pickerView.frame, NAN, y);
}

#pragma mark - Getter

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - CGRectGetHeight(_pickerView.bounds) - CGRectGetHeight(self.navigationController.navigationBar.bounds), screenSize.width, CGRectGetHeight(_pickerView.bounds));
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    }
    
    return _pickerView;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.canvasList[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *canvasName = self.canvasList[row];
    self.currentCanvasName = canvasName;
    
    NSLog(@"selected: %@", self.currentCanvasName);
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.canvasList count];
}

#pragma mark - Action

- (void)chooseItemClicked:(id)sender {
    if (self.currentCanvasName.length) {
        [self.drawingView removeFromSuperview];
        
        NSString *className = [NSString stringWithFormat:@"%@%@", DRAWING_VIEW_CLASS_PREFIX, self.currentCanvasName];
        UIView *view = [[NSClassFromString(className) alloc] initWithFrame:self.view.bounds];
        [self.view insertSubview:view belowSubview:self.pickerView];
        
        self.drawingView = view;
    }
}

- (void)toggleItemClicked:(id)sender {
    
    CGFloat y;
    if (self.pickerViewShown) {
        y = CGRectGetHeight(self.view.bounds);
    }
    else {
        y = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(_pickerView.bounds) - [WCViewTool safeAreaInsetsWithView:self.view].bottom;
    }
    
    CGRect toFrame = FrameSetOrigin(self.pickerView.frame, NAN, y);
    [UIView animateWithDuration:0.25 animations:^{
        self.pickerView.frame = toFrame;
    } completion:^(BOOL finished) {
        self.pickerViewShown = !self.pickerViewShown;
    }];
}

@end
