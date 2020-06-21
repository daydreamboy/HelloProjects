//
//  KeyframeAnimationViewController.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 2020/6/20.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import "KeyframeAnimationViewController.h"

#define SpaceV 20

@interface KeyframeAnimationViewController ()
@property (nonatomic, strong) AnimationDemoView *demoAnimation1;
@property (nonatomic, strong) AnimationDemoView *demoAnimation2;
@property (nonatomic, strong) AnimationDemoView *demoAnimation3;
@end

@implementation KeyframeAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.contentView addSubview:self.demoAnimation1];
    [self.contentView addSubview:self.demoAnimation2];
    [self.contentView addSubview:self.demoAnimation3];
}

#pragma mark - CAKeyframeAnimation

- (AnimationDemoView *)demoAnimation1 {
    if (!_demoAnimation1) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat height = 60;
        CGFloat paddingH = 10;
        
        // Note: Demonstrate a simple keyframe animation
        AnimationDemoView *demoView = [[AnimationDemoView alloc] initWithFrame:CGRectMake(paddingH, 10, screenSize.width - 2 * paddingH, height)];
        
        CGFloat side = 30;
        CGFloat startX = 10;
        UITextField *animatedView = [[UITextField alloc] initWithFrame:CGRectMake(startX, (height - side) / 2.0, CGRectGetWidth(demoView.bounds) - 2 * startX, side)];
        animatedView.borderStyle = UITextBorderStyleRoundedRect;
        animatedView.secureTextEntry = YES;
        animatedView.text = @"123456";
        animatedView.enabled = NO;
        
        [demoView addSubview:animatedView];
        demoView.doAnimation = ^{
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"position.x";
            animation.values = @[ @0, @10, @-10, @10, @0 ];
            animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
            animation.duration = 0.4;
            //animation.duration = 10;

            animation.additive = YES;

            [animatedView.layer addAnimation:animation forKey:@"shake"];
        };
        
        _demoAnimation1 = demoView;
    }
    
    return _demoAnimation1;
}

- (AnimationDemoView *)demoAnimation2 {
    if (!_demoAnimation2) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat height = 150;
        CGFloat paddingH = 10;
        
        // @see https://stackoverflow.com/a/38418410
        AnimationDemoView *demoView = [[AnimationDemoView alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(_demoAnimation1.frame) + SpaceV, screenSize.width - 2 * paddingH, height)];
        
        CGFloat side1 = 100;
        UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(demoView.bounds) - side1) / 2.0, (CGRectGetHeight(demoView.bounds) - side1) / 2.0, side1, side1)];
        circleView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        circleView.layer.cornerRadius = side1 / 2.0;
        circleView.layer.borderColor = [UIColor greenColor].CGColor;
        circleView.layer.borderWidth = 1;
        [demoView addSubview:circleView];
        
        CGFloat side2 = 30;
        UIView *animatedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, side2, side2)];
        // Note: because the path start point at left X, middle Y, so set the start state of the position,
        // see the below the CGPathCreateWithEllipseInRect or UIBezierPath
        animatedView.center = CGPointMake(CGRectGetMaxX(circleView.frame), CGRectGetMidY(circleView.frame));
        animatedView.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.9];
        [demoView addSubview:animatedView];
        
        __unused UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:circleView.center radius:side1 / 2.0 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        
        demoView.doAnimation = ^{
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"position";
            animation.path = CFAutorelease(CGPathCreateWithEllipseInRect(circleView.frame, NULL));
            // or use UIBezierPath to create path
            //animation.path = path.CGPath;
            animation.duration = 4;
            animation.repeatCount = HUGE_VALF;
            animation.calculationMode = kCAAnimationPaced;
            animation.rotationMode = kCAAnimationRotateAuto;

            [animatedView.layer addAnimation:animation forKey:@"orbit"];
        };
        
        _demoAnimation2 = demoView;
    }
    
    return _demoAnimation2;
}

- (AnimationDemoView *)demoAnimation3 {
    if (!_demoAnimation3) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat height = 150;
        CGFloat paddingH = 10;
        
        // @see https://stackoverflow.com/a/38418410
        AnimationDemoView *demoView = [[AnimationDemoView alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(_demoAnimation2.frame) + SpaceV, screenSize.width - 2 * paddingH, height)];
        
        CGFloat side1 = 100;
        UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(demoView.bounds) - side1) / 2.0, (CGRectGetHeight(demoView.bounds) - side1) / 2.0, side1, side1)];
        circleView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        circleView.layer.cornerRadius = side1 / 2.0;
        circleView.layer.borderColor = [UIColor greenColor].CGColor;
        circleView.layer.borderWidth = 1;
        [demoView addSubview:circleView];
        
        CGFloat side2 = 30;
        UIView *animatedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, side2, side2)];
        // Note: because the path start point at left X, middle Y, so set the start state of the position,
        // see the below the CGPathCreateWithEllipseInRect or UIBezierPath
        animatedView.center = CGPointMake(CGRectGetMaxX(circleView.frame), CGRectGetMidY(circleView.frame));
        animatedView.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.9];
        [demoView addSubview:animatedView];
        
        __unused UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:circleView.center radius:side1 / 2.0 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        
        demoView.doAnimation = ^{
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"position";
            animation.path = CFAutorelease(CGPathCreateWithEllipseInRect(circleView.frame, NULL));
            // or use UIBezierPath to create path
            //animation.path = path.CGPath;
            animation.duration = 4;
            animation.repeatCount = HUGE_VALF;
            animation.calculationMode = kCAAnimationPaced;
            animation.rotationMode = nil;//kCAAnimationRotateAuto;

            [animatedView.layer addAnimation:animation forKey:@"orbit"];
        };
        
        _demoAnimation3 = demoView;
    }
    
    return _demoAnimation3;
}

@end
