//
//  BasicAnimationViewController.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 2020/6/20.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import "BasicAnimationViewController.h"

#define SpaceV 20

@interface BasicAnimationViewController ()
@property (nonatomic, strong) AnimationDemoView *demoAnimation1;
@property (nonatomic, strong) AnimationDemoView *demoAnimation2;
@property (nonatomic, strong) AnimationDemoView *demoAnimation3;
@end

@implementation BasicAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.contentView addSubview:self.demoAnimation1];
    [self.contentView addSubview:self.demoAnimation2];
    [self.contentView addSubview:self.demoAnimation3];
}

#pragma mark -

- (AnimationDemoView *)demoAnimation1 {
    if (!_demoAnimation1) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat height = 60;
        CGFloat paddingH = 10;
        
        // Note: Demonstrate a simple linear animation
        AnimationDemoView *demoView = [[AnimationDemoView alloc] initWithFrame:CGRectMake(paddingH, 10, screenSize.width - 2 * paddingH, height)];
        
        CGFloat side = 40;
        CGFloat startX = 10;
        UIView *animatedView = [[UIView alloc] initWithFrame:CGRectMake(startX, (height - side) / 2.0, side, side)];
        animatedView.backgroundColor = [UIColor redColor];
        
        [demoView addSubview:animatedView];
        demoView.doAnimation = ^{
            CABasicAnimation *animation = [CABasicAnimation animation];
            animation.keyPath = @"position.x";
            animation.fromValue = @(startX + side / 2.0);
            animation.toValue = @(CGRectGetWidth(demoView.bounds) - paddingH - side / 2.0);
            animation.duration = 1;

            [animatedView.layer addAnimation:animation forKey:@"basic"];
        };
        
        _demoAnimation1 = demoView;
    }
    
    return _demoAnimation1;
}

- (AnimationDemoView *)demoAnimation2 {
    if (!_demoAnimation2) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat height = 60;
        CGFloat paddingH = 10;
        
        // Note: Demonstrate the first way to hold end state which set the end state of the CALayer
        AnimationDemoView *demoView = [[AnimationDemoView alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(_demoAnimation1.frame) + SpaceV, screenSize.width - 2 * paddingH, height)];
        
        CGFloat side = 40;
        CGFloat startX = 10;
        UIView *animatedView = [[UIView alloc] initWithFrame:CGRectMake(startX, (height - side) / 2.0, side, side)];
        animatedView.backgroundColor = [UIColor redColor];

        [demoView addSubview:animatedView];
        
        CGFloat endPositionX = CGRectGetWidth(demoView.bounds) - paddingH - side / 2.0;
        
        demoView.doAnimation = ^{
            CABasicAnimation *animation = [CABasicAnimation animation];
            animation.keyPath = @"position.x";
            animation.fromValue = @(startX + side / 2.0);
            animation.toValue = @(endPositionX);
            animation.duration = 1;

            [animatedView.layer addAnimation:animation forKey:@"basic"];
            
            animatedView.layer.position = CGPointMake(endPositionX, animatedView.layer.position.y);
        };
        
        _demoAnimation2 = demoView;
    }
    
    return _demoAnimation2;
}

- (AnimationDemoView *)demoAnimation3 {
    if (!_demoAnimation3) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat height = 60;
        CGFloat paddingH = 10;
        
        // Note: Demonstrate the second way to hold end state which use kCAFillModeForwards and removedOnCompletion = NO
        AnimationDemoView *demoView = [[AnimationDemoView alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(_demoAnimation2.frame) + SpaceV, screenSize.width - 2 * paddingH, height)];
        
        CGFloat side = 40;
        CGFloat startX = 10;
        UIView *animatedView = [[UIView alloc] initWithFrame:CGRectMake(startX, (height - side) / 2.0, side, side)];
        animatedView.backgroundColor = [UIColor redColor];
        
        [demoView addSubview:animatedView];
        
        CGFloat endPositionX = CGRectGetWidth(demoView.bounds) - paddingH - side / 2.0;
        
        demoView.doAnimation = ^{
            CABasicAnimation *animation = [CABasicAnimation animation];
            animation.keyPath = @"position.x";
            animation.fromValue = @(startX + side / 2.0);
            animation.toValue = @(endPositionX);
            animation.duration = 1;
            animation.fillMode = kCAFillModeForwards;
            animation.removedOnCompletion = NO;

            [animatedView.layer addAnimation:animation forKey:@"basic"];
        };
        
        _demoAnimation3 = demoView;
    }
    
    return _demoAnimation3;
}

@end
