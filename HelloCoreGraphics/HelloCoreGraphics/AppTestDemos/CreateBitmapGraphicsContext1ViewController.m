//
//  CreateBitmapGraphicsContext1ViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2017/11/26.
//  Copyright © 2017年 wesley_chen. All rights reserved.
//

#import "CreateBitmapGraphicsContext1ViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import <CoreFoundation/CoreFoundation.h>

CGContextRef MyBitmapContextCreate(int widthInPixel, int heightInPixel)
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData;
    int bitmapByteCount;
    int bitmapBytesPerRow;
    
    bitmapBytesPerRow = widthInPixel * 4;
    bitmapByteCount = bitmapBytesPerRow * heightInPixel;
    
    colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    bitmapData = calloc(bitmapByteCount, sizeof(uint8_t));
    
    if (bitmapData == NULL) {
        fprintf(stderr, "memory not allocated");
        return NULL;
    }
    
    context = CGBitmapContextCreate(bitmapData, widthInPixel, heightInPixel, 8, bitmapBytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
    if (context == NULL) {
        free(bitmapData);
        fprintf(stderr, "context not created");
        return NULL;
    }
    CGColorSpaceRelease(colorSpace);
    
    return context;
}

@interface MyDrawingViewWithoutScale : UIView
@end
@implementation MyDrawingViewWithoutScale
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Note: convert UIKit coordinate system into Quartz 2D coordinate system
    // and move origin to view's bottom-left corner
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    [self drawGraphicsInBitmapContextWithViewContext:context viewBoundingRect:rect];
}
- (void)drawGraphicsInBitmapContextWithViewContext:(CGContextRef)viewContext viewBoundingRect:(CGRect)boundingRect {
    
    CGFloat widthOfBitmapContext = boundingRect.size.width;
    CGFloat heightOfBitmapContext = boundingRect.size.height;
    
    CGContextRef myBitmapContext = MyBitmapContextCreate(widthOfBitmapContext, heightOfBitmapContext);
    
    CGContextSetRGBFillColor(myBitmapContext, 1, 0, 0, 1);
    CGContextFillRect(myBitmapContext, CGRectMake(0, 0, 200, 100));
    CGContextSetRGBFillColor(myBitmapContext, 0, 0, 1, 0.5);
    CGContextFillRect(myBitmapContext, CGRectMake(0, 0, 100, 200));
    
    CGImageRef myImage = CGBitmapContextCreateImage(myBitmapContext);
    CGContextDrawImage(viewContext, boundingRect, myImage);
    
    // do clean up
    char *bitmapData = CGBitmapContextGetData(myBitmapContext);
    CGContextRelease(myBitmapContext);
    if (bitmapData) {
        free(bitmapData);
    }
    CGImageRelease(myImage);
}
@end

@interface MyDrawingViewWithScale : UIView
@end
@implementation MyDrawingViewWithScale
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Note: convert UIKit coordinate system into Quartz 2D coordinate system
    // and move origin to view's bottom-left corner
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    CGFloat scaleFactor = 0.5;
    [self drawGraphicsInBitmapContextWithViewContext:context viewBoundingRect:rect scaleFactor:scaleFactor];
}

/// viewContext - the context provided by UIView which used to render the UIView
/// boundingRect - the bound of UIView, but not the size of viewContext
/// scaleFactor - (0, 1], which define how to map from CGImageRef's size to viewContext
- (void)drawGraphicsInBitmapContextWithViewContext:(CGContextRef)viewContext viewBoundingRect:(CGRect)boundingRect scaleFactor:(CGFloat)scaleFactor {
    
    CGFloat widthOfBitmapContext = boundingRect.size.width / scaleFactor;
    CGFloat heightOfBitmapContext = boundingRect.size.height / scaleFactor;
    
    CGContextRef myBitmapContext = MyBitmapContextCreate(widthOfBitmapContext, heightOfBitmapContext);
    
    CGContextSetRGBFillColor(myBitmapContext, 1, 0, 0, 1);
    CGContextFillRect(myBitmapContext, CGRectMake(0, 0, 200, 100));
    CGContextSetRGBFillColor(myBitmapContext, 0, 0, 1, 0.5);
    CGContextFillRect(myBitmapContext, CGRectMake(0, 0, 100, 200));
    
    CGImageRef myImage = CGBitmapContextCreateImage(myBitmapContext);
    // Note: if myImage's size (also bitmap context's size) is larger than boundingRect, myImage's size will be scaled automactically
    CGContextDrawImage(viewContext, boundingRect, myImage);
    char *bitmapData = CGBitmapContextGetData(myBitmapContext);
    CGContextRelease(myBitmapContext);
    if (bitmapData) {
        free(bitmapData);
    }
    CGImageRelease(myImage);
}
@end

@interface CreateBitmapGraphicsContext1ViewController ()
@property (nonatomic, strong) MyDrawingViewWithoutScale *drawingView1;
@property (nonatomic, strong) MyDrawingViewWithScale *drawingView2;
@end

@implementation CreateBitmapGraphicsContext1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.drawingView1];
    [self.view addSubview:self.drawingView2];
}

#pragma mark - Getters

- (MyDrawingViewWithoutScale *)drawingView1 {
    if (!_drawingView1) {
        MyDrawingViewWithoutScale *view = [[MyDrawingViewWithoutScale alloc] initWithFrame:CGRectMake(0, 64, 200, 300)];
        _drawingView1 = view;
    }
    return _drawingView1;
}

- (MyDrawingViewWithScale *)drawingView2 {
    if (!_drawingView2) {
        MyDrawingViewWithScale *view = [[MyDrawingViewWithScale alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.drawingView1.frame) + 5, 64, 200, 300)];
        _drawingView2 = view;
    }
    return _drawingView2;
}

@end
