//
//  Uberworks1ViewController.m
//  HelloCoreAnimation
//
//  Created by wesley chen on 16/10/23.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "Uberworks1ViewController.h"

@interface Uberworks1ViewController ()
@property (nonatomic, strong) CAShapeLayer *line;
@end

@implementation Uberworks1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    CGPoint fromPoint = (CGPoint){ 160, 550 };
    self.line = [self animatedLineFromPoint:fromPoint toPoint:self.view.center];
    [self.view.layer addSublayer:self.line];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.line.strokeEnd = 0.0f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.line.strokeEnd = 1.0;
    });
    
    /*
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        NSLog(@"%@", [NSDate date]);
        self.line.strokeEnd = 1.0;
    } completion:^(BOOL finished) {
        //self.line.strokeEnd = 1.0;
        NSLog(@"%@", [NSDate date]);
        
        [UIView animateWithDuration:0.75 delay:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
            NSLog(@"%@", [NSDate date]);
            self.line.strokeStart = 1.0f;
        } completion:^(BOOL finished) {
            NSLog(@"%@", [NSDate date]);
        }];
    }];
     */
}

- (CAShapeLayer *)animatedLineFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:fromPoint];
    [linePath addLineToPoint:toPoint];
    
    CAShapeLayer *line = [CAShapeLayer layer];
    line.path = linePath.CGPath;
    line.lineCap = kCALineCapRound;
    line.strokeColor = [UIColor cyanColor].CGColor;
    
    return line;
}

@end
