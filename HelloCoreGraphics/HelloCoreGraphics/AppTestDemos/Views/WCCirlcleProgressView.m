//
//  WCCirlcleProgressView.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2018/7/4.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCCirlcleProgressView.h"
#import "LayerWithProgress.h"

#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

@interface CircleView () <LayerWithProgressProtocol>

@property (nonatomic, strong) UIBezierPath *outerPath;
@property (nonatomic, strong) UIBezierPath *innerPath;
@property (nonatomic, strong) UILabel *lblProgress;

@end

@implementation CircleView
-(void)addProgressLabelForPath:(UIBezierPath *)path {
    NSString *lblProgressTxt = @"100%";
    UIFont *myFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:60.0];
    CGSize size = [lblProgressTxt sizeWithAttributes:@{NSFontAttributeName:myFont}];
    CGRect oldRect = path.bounds;
    self.lblProgress = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(oldRect)-size.width/2, CGRectGetMidY(oldRect)-size.height/2, size.width, size.height)];
    [self addSubview:self.lblProgress];
    self.lblProgress.text = lblProgressTxt;
    self.lblProgress.font =  myFont;
    self.lblProgress.backgroundColor = [UIColor clearColor];
    self.lblProgress.textAlignment = NSTextAlignmentCenter;
}

- (void)drawLineWithPath:(UIBezierPath *)path {
    
    [self drawOuterPathForPath:path];
    [self drawInnerPathForPath:path];
    [self addProgressLabelForPath:path];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = CGRectMake(path.bounds.origin.x-path.lineWidth/2-1, path.bounds.origin.y-path.lineWidth/2-1, path.bounds.size.width, path.bounds.size.height);
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [UIColor greenColor].CGColor;
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = path.lineWidth;
    pathLayer.lineJoin = kCALineJoinBevel;
    
    [self.layer addSublayer:pathLayer];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 10.0;
    pathAnimation.fromValue = @0;
    pathAnimation.toValue = @1;
    [pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    LayerWithProgress *progressLayer = [LayerWithProgress layer];
    progressLayer.frame = CGRectMake(0, -1, 1, 1);
    progressLayer.progressdelegate = self;
    [self.layer addSublayer:progressLayer];
    
    CABasicAnimation *progressAnimation = [CABasicAnimation animationWithKeyPath:@"progress"];
    progressAnimation.duration = 10.0;
    progressAnimation.beginTime = 0;
    progressAnimation.fromValue = @0;
    progressAnimation.toValue = @1;
    progressAnimation.fillMode = kCAFillModeForwards;
    progressAnimation.removedOnCompletion = NO;
    
    [progressLayer addAnimation:progressAnimation forKey:@"progress"];
    
    self.lblProgress.text = @"  0%";
    
}

-(void)progressUpdatedTo:(CGFloat)progress {
    NSLog(@"Progress: %f", progress);
    //[self bringSubviewToFront:self.lblProgress];
    NSString *padStr = @" ";
    NSInteger num = progress*100+1;
    if (num < 10) {
        padStr = @"  ";
    }
    if (num == 100) {
        padStr = @"";
    }
    
    self.lblProgress.text = [NSString stringWithFormat:@"%@%ld%%", padStr, (long)num];
}

-(void)drawOuterPathForPath:(UIBezierPath *)path {
    CGRect oldRect = path.bounds;
    CGFloat radius = CGRectGetWidth(oldRect)/2+path.lineWidth/2+1;
    CGPoint midPoint = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    self.outerPath = [UIBezierPath bezierPathWithArcCenter:midPoint radius:radius startAngle:degreesToRadians(270) endAngle:degreesToRadians(630) clockwise:YES];
    self.outerPath.lineWidth = 2.0f;
}

-(void)drawInnerPathForPath:(UIBezierPath *)path {
    CGRect oldRect = path.bounds;
    CGFloat radius = CGRectGetWidth(oldRect)/2-path.lineWidth/2-1;
    CGPoint midPoint = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    self.innerPath = [UIBezierPath bezierPathWithArcCenter:midPoint radius:radius startAngle:degreesToRadians(270) endAngle:degreesToRadians(630) clockwise:YES];
    self.innerPath.lineWidth = 2.0f;
}

- (void)drawRect:(CGRect)rect {
    [[UIColor blackColor] setStroke];
    [self.outerPath stroke];
    [self.innerPath stroke];
}

@end
