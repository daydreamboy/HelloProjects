//
//  DrawVariableWidthStrokeWithFreeHandViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2020/6/26.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "DrawVariableWidthStrokeWithFreeHandViewController.h"
#import "WCMacroTool.h"
#import "WCViewTool.h"

// Tutorial: @see https://code.tutsplus.com/tutorials/ios-sdk-advanced-freehand-drawing-techniques--mobile-15602
#define MyDrawingView1  NaiveVariableWidthView
#define MyDrawingView2  NaiveVariableWidthBackgroundRenderingView


#pragma mark - MyDrawingView1

DRAWING_VIEW_CLASS_DECLARATION_BEGIN(MyDrawingView1)
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) UIImage *incrementalImage;
DRAWING_VIEW_CLASS_DECLARATION_END

DRAWING_VIEW_CLASS_IMPLEMENTATION_BEGIN(MyDrawingView1) {
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
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
        if (!self.incrementalImage) {
            UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
            [self.backgroundColor setFill];
            [rectpath fill];
        }
        [self.incrementalImage drawAtPoint:CGPointZero];
        [[UIColor blackColor] setStroke];
        
        float speed = 0.0;
        
        for (int i = 0; i < 3; ++i) {
            float dx = _points[i + 1].x - _points[i].x;
            float dy = _points[i + 1].y - _points[i].y;
            speed += sqrtf(dx * dx + dy * dy);
        }
#define FUDGE_FACTOR 50 // empirically determined
        float width = 2.0;
        
        // Note: Only when speed is not too slow (e.g. speed = 0), to use FUDGE_FACTOR / speed
        if (speed > 1) {
            width = FUDGE_FACTOR / speed;
        }
        
        self.path.lineWidth = width;
        NSLog(@"speed: %f, lineWidth: %f", speed, width);
        [self.path stroke];
        
        self.incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self setNeedsDisplay];
        
        [self.path removeAllPoints];
        
        // replace points and get ready to handle the next segment
        _points[0] = _points[3];
        _points[1] = _points[4];
        _counter = 1;
    }
}
 
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setNeedsDisplay];
}
 
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

DRAWING_VIEW_CLASS_IMPLEMENTATION_END


#pragma mark - MyDrawingView2

#define CAPACITY 100 // buffer capacity

DRAWING_VIEW_CLASS_DECLARATION_BEGIN(MyDrawingView2)
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) UIImage *incrementalImage;
DRAWING_VIEW_CLASS_DECLARATION_END

DRAWING_VIEW_CLASS_IMPLEMENTATION_BEGIN(MyDrawingView2) {
    CGPoint _points[5]; // we now need to keep track of the four points of a Bezier segment and the first control point of the next segment
    uint _counter; // a counter variable to keep track of the point index
    CGPoint _pointsBuffer[CAPACITY];
    uint _bufferIndex;
    dispatch_queue_t _drawingQueue;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.multipleTouchEnabled = NO;
        self.backgroundColor = [[UIColor magentaColor] colorWithAlphaComponent:0.4];
        
        _drawingQueue = dispatch_queue_create("drawingQueue", NULL);
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self.incrementalImage drawInRect:rect];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _counter = 0;
    _bufferIndex = 0;
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
        _pointsBuffer[_bufferIndex] = _points[0];
        _pointsBuffer[_bufferIndex + 1] = _points[1];
        _pointsBuffer[_bufferIndex + 2] = _points[2];
        _pointsBuffer[_bufferIndex + 3] = _points[3];
        
        _bufferIndex += 4;
        
        CGRect bounds = self.bounds;
        UIColor *fillColor = self.backgroundColor;
        dispatch_async(_drawingQueue, ^{
            if (self->_bufferIndex == 0) {
                return;
            }
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            for (int i = 0; i < self->_bufferIndex; i += 4) {
                [path moveToPoint:self->_pointsBuffer[i]];
                [path addCurveToPoint:self->_pointsBuffer[i + 3] controlPoint1:self->_pointsBuffer[i + 1] controlPoint2:self->_pointsBuffer[i + 2]];
            }
            
            UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 0.0);
            if (!self.incrementalImage) {
                UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:bounds];
                [fillColor setFill];
                [rectpath fill];
            }
            
            [self.incrementalImage drawAtPoint:CGPointZero];
            [[UIColor blackColor] setStroke];
            
            float speed = 0.0;
                    
            for (int i = 0; i < 3; ++i) {
                float dx = self->_points[i + 1].x - self->_points[i].x;
                float dy = self->_points[i + 1].y - self->_points[i].y;
                speed += sqrtf(dx * dx + dy * dy);
            }
    #define FUDGE_FACTOR 50 // empirically determined
            float width = 2.0;
            
            // Note: Only when speed is not too slow (e.g. speed = 0), to use FUDGE_FACTOR / speed
            if (speed > 1) {
                width = FUDGE_FACTOR / speed;
            }
            
            NSLog(@"speed: %f, lineWidth: %f", speed, width);
            path.lineWidth = width;
            [path stroke];
            
            self.incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_bufferIndex = 0;
                [self setNeedsDisplay];
            });
        });
        
        // replace points and get ready to handle the next segment
        _points[0] = _points[3];
        _points[1] = _points[4];
        _counter = 1;
    }
}
 
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setNeedsDisplay];
}
 
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

DRAWING_VIEW_CLASS_IMPLEMENTATION_END

#pragma mark -

@interface DrawVariableWidthStrokeWithFreeHandViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIView *drawingView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, assign) BOOL pickerViewShown;
@property (nonatomic, strong) NSArray<NSString *> *canvasList;
@property (nonatomic, copy) NSString *currentCanvasName;
@end

@implementation DrawVariableWidthStrokeWithFreeHandViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _canvasList = @[
            STR_OF_LITERAL(MyDrawingView1),
            STR_OF_LITERAL(MyDrawingView2),
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
