//
//  LayerAnimateWithPositionController.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 2020/6/20.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import "LayerAnimateWithPositionController.h"

#define SpaceV 20

@interface LayerAnimateWithPositionController ()
@property (nonatomic, strong) AnimationDemoView *demoAnimation1;
@end

@implementation LayerAnimateWithPositionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.contentView addSubview:self.demoAnimation1];
}

#pragma mark - Implicit Animation

- (AnimationDemoView *)demoAnimation1 {
    if (!_demoAnimation1) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat height = 60;
        CGFloat paddingH = 10;
        
        AnimationDemoView *demoView = [[AnimationDemoView alloc] initWithFrame:CGRectMake(paddingH, SpaceV, screenSize.width - 2 * paddingH, height)];
        
        CGFloat side = 40;
        CGFloat startX = 10;
        
        CALayer *animatedLayer = [CALayer layer];
        animatedLayer.frame = CGRectMake(startX, (height - side) / 2.0, side, side);
        animatedLayer.backgroundColor = [UIColor redColor].CGColor;
        
        NSLog(@"%@", animatedLayer);
        NSLog(@"%@", [animatedLayer modelLayer]);
        NSLog(@"%@", [animatedLayer presentationLayer]);
        
        [demoView.layer addSublayer:animatedLayer];
        
        CGFloat endPositionX = CGRectGetWidth(demoView.bounds) - paddingH - side / 2.0;
        
        demoView.doAnimation = ^{
            animatedLayer.position = CGPointMake(endPositionX, animatedLayer.position.y);
        };
        
        _demoAnimation1 = demoView;
    }
    
    return _demoAnimation1;
}

@end
