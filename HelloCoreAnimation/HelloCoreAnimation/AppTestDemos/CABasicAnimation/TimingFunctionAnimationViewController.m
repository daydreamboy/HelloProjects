//
//  TimingFunctionAnimationViewController.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 2020/6/21.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import "TimingFunctionAnimationViewController.h"

#define SpaceV 20

@interface TimingFunctionAnimationViewController ()
@property (nonatomic, strong) AnimationDemoView *demoAnimation1;
@end

@implementation TimingFunctionAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.contentView addSubview:self.demoAnimation1];
}

#pragma mark - CABasicAnimation

- (AnimationDemoView *)demoAnimation1 {
    if (!_demoAnimation1) {
        NSUInteger numberOfAnimatedView = 6;
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat side = 40;
        CGFloat spaceV = 10;
        CGFloat height = side * numberOfAnimatedView + spaceV * (numberOfAnimatedView + 1);
        CGFloat paddingH = 10;
        
        AnimationDemoView *demoView = [[AnimationDemoView alloc] initWithFrame:CGRectMake(paddingH, 10, screenSize.width - 2 * paddingH, height)];
        
        CGFloat startX = 10;
        UIView *animatedView1 = [[UIView alloc] initWithFrame:CGRectMake(startX, spaceV, side, side)];
        animatedView1.backgroundColor = [UIColor redColor];
        [demoView addSubview:animatedView1];
        
        UIView *animatedView2 = [[UIView alloc] initWithFrame:CGRectMake(startX, CGRectGetMaxY(animatedView1.frame) + spaceV, side, side)];
        animatedView2.backgroundColor = [UIColor redColor];
        [demoView addSubview:animatedView2];
        
        UIView *animatedView3 = [[UIView alloc] initWithFrame:CGRectMake(startX, CGRectGetMaxY(animatedView2.frame) + spaceV, side, side)];
        animatedView3.backgroundColor = [UIColor redColor];
        [demoView addSubview:animatedView3];
        
        UIView *animatedView4 = [[UIView alloc] initWithFrame:CGRectMake(startX, CGRectGetMaxY(animatedView3.frame) + spaceV, side, side)];
        animatedView4.backgroundColor = [UIColor redColor];
        [demoView addSubview:animatedView4];
        
        UIView *animatedView5 = [[UIView alloc] initWithFrame:CGRectMake(startX, CGRectGetMaxY(animatedView4.frame) + spaceV, side, side)];
        animatedView5.backgroundColor = [UIColor redColor];
        [demoView addSubview:animatedView5];
        
        UIView *animatedView6 = [[UIView alloc] initWithFrame:CGRectMake(startX, CGRectGetMaxY(animatedView5.frame) + spaceV, side, side)];
        animatedView6.backgroundColor = [UIColor orangeColor];
        [demoView addSubview:animatedView6];
        
        CGFloat startPositionX = startX + side / 2.0;
        CGFloat endPositionX = CGRectGetWidth(demoView.bounds) - paddingH - side / 2.0;
        
        demoView.doAnimation = ^{
            CABasicAnimation *animation = [CABasicAnimation animation];
            animation.keyPath = @"position.x";
            animation.fromValue = @(startPositionX);
            animation.byValue = @(endPositionX - startPositionX);
            animation.duration = 1;
            
            // Animate 1
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            [animatedView1.layer addAnimation:animation forKey:@"basic"];
            
            // Animate 2
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            [animatedView2.layer addAnimation:animation forKey:@"basic"];
            
            // Animate 3
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            [animatedView3.layer addAnimation:animation forKey:@"basic"];
            
            // Animate 4
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [animatedView4.layer addAnimation:animation forKey:@"basic"];
            
            // Animate 5
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            [animatedView5.layer addAnimation:animation forKey:@"basic"];
            
            // Animate 6
            animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5:0:0.9:0.7];
            [animatedView6.layer addAnimation:animation forKey:@"basic"];
            
            animatedView1.layer.position = CGPointMake(endPositionX, animatedView1.layer.position.y);
            animatedView2.layer.position = CGPointMake(endPositionX, animatedView2.layer.position.y);
            animatedView3.layer.position = CGPointMake(endPositionX, animatedView3.layer.position.y);
            animatedView4.layer.position = CGPointMake(endPositionX, animatedView4.layer.position.y);
            animatedView5.layer.position = CGPointMake(endPositionX, animatedView5.layer.position.y);
            animatedView6.layer.position = CGPointMake(endPositionX, animatedView6.layer.position.y);
        };
        
        _demoAnimation1 = demoView;
    }
    
    return _demoAnimation1;
}

@end
