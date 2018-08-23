//
//  YWVideoProgressLayer.m
//  VideoTest
//
//  Created by sidian on 16/2/26.
//  Copyright © 2016年 SiDian. All rights reserved.
//

#import "YWVideoProgressLayer.h"
#import <UIKit/UIKit.h>

#define kYWVideoStartAngle -M_PI/2

@interface YWVideoProgressLayer ()

@property (nonatomic, strong) CALayer *outLayer;
@property (nonatomic, strong) NSOperationQueue *serialQueue;

@property (nonatomic, weak) NSBlockOperation *lastOperation;
@property (nonatomic, assign) CGSize innerSize;

@property (nonatomic, assign) CGFloat time;

@end

@implementation YWVideoProgressLayer

- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.frame = frame;
        
        _outLayer = [[CALayer alloc] init];
        _outLayer.bounds = self.bounds;
        _outLayer.position = CGPointMake(frame.size.width/2, frame.size.width/2);
        _outLayer.contentsGravity = kCAGravityResizeAspect;
        
        _serialQueue = [[NSOperationQueue alloc] init];
        _serialQueue.maxConcurrentOperationCount = 1;
        _serialQueue.name = @"短视频进度绘制";
        
        _innerSize = CGSizeMake(frame.size.width - 4, frame.size.height - 4);
        
        self.contentsScale = [UIScreen mainScreen].scale;
    }
    return self;
}

- (void)startWaitRotating
{
    _isRotating = YES;
    [self configOutCircleWithImageName:@"video_loading"];
    
    CABasicAnimation* rotationAnimation =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.toValue = @(MAXFLOAT);
    rotationAnimation.duration = MAXFLOAT/2;
    [_outLayer removeAnimationForKey:@"rotation"];
    [_outLayer addAnimation:rotationAnimation forKey:@"rotation"];
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; //缓入缓出

    self.contents = nil;
}

- (void)stopWaitRotating
{
    _isRotating = NO;
    [_outLayer removeAnimationForKey:@"rotation"];
    [self configOutCircleWithImageName:@"video_record_out"];
}

- (void)configOutCircleWithImageName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    _outLayer.contents = (__bridge id)image.CGImage;
    if (_outLayer.superlayer != self) {
        [self addSublayer:_outLayer];
    }
}

- (void)setProgress:(CGFloat)progress
{
    if (_isRotating) {
        [self stopWaitRotating];
    } else {
        [self configOutCircleWithImageName:@"video_record_out"];
    }
    [self willChangeValueForKey:@"progress"];
    _progress = progress;
    [self didChangeValueForKey:@"progress"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

//- (void)display
//{
//    if (_isRotating) {
//        [self startWaitRotating];
//    } else {
//        [super display];
//    }
//}

- (void)drawInContext:(CGContextRef)ctx
{
    
    CGFloat endAngle = kYWVideoStartAngle + _progress * 2 * M_PI;
    
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
    
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    CGContextAddArc(ctx, CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds), CGRectGetWidth(self.bounds)/2 - 3, kYWVideoStartAngle, endAngle, NO);
    
    CGContextClosePath(ctx);
    
    CGContextFillPath(ctx);
}
@end


