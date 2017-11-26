//
//  CreateBitmapGraphicsContext2ViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2017/11/26.
//  Copyright © 2017年 wesley_chen. All rights reserved.
//

#import "CreateBitmapGraphicsContext2ViewController.h"

@interface MyDrawingView: UIView
@end

@implementation MyDrawingView
- (void)drawRect:(CGRect)rect {
    CGContextRef viewContext = UIGraphicsGetCurrentContext();
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    {
        CGContextRef bitmapContext = UIGraphicsGetCurrentContext();
        [self drawGraphicsInBitmapContext:bitmapContext viewContext:viewContext viewBoundingRect:rect];
    }
    UIGraphicsEndImageContext();
    
    // Note: 不知道为什么，画出来的图形，居然是按照Quartz 2D的坐标系，虽然viewContext和bitmapContext都使用UIKit的坐标系
}
- (void)drawGraphicsInBitmapContext:(CGContextRef)bitmapContext viewContext:(CGContextRef)viewContext viewBoundingRect:(CGRect)boundingRect {
    
    CGContextRef myBitmapContext = bitmapContext;
    
    CGContextSetRGBFillColor(myBitmapContext, 1, 0, 0, 1);
    CGContextFillRect(myBitmapContext, CGRectMake(0, 0, 200, 100));
    CGContextSetRGBFillColor(myBitmapContext, 0, 0, 1, 0.5);
    CGContextFillRect(myBitmapContext, CGRectMake(0, 0, 100, 200));
    
    CGImageRef myImage = CGBitmapContextCreateImage(myBitmapContext);
    CGContextDrawImage(viewContext, boundingRect, myImage);
    
    CGImageRelease(myImage);
}
@end

@interface CreateBitmapGraphicsContext2ViewController ()
@property (nonatomic, strong) MyDrawingView *drawingView1;
@end

@implementation CreateBitmapGraphicsContext2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.drawingView1];
}

#pragma mark - Getters

- (MyDrawingView *)drawingView1 {
    if (!_drawingView1) {
        MyDrawingView *view = [[MyDrawingView alloc] initWithFrame:CGRectMake(0, 64, 200, 300)];
        _drawingView1 = view;
    }
    return _drawingView1;
}

@end
