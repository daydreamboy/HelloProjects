//
//  AnimationGroupViewController.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 2020/6/21.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import "AnimationGroupViewController.h"

@interface AnimationGroupViewController ()
@property (nonatomic, strong) AnimationDemoView *demoAnimation1;
@property (nonatomic, assign) CGFloat zPosition;
@end

@implementation AnimationGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.zPosition = 1;
    
    [self.contentView addSubview:self.demoAnimation1];
}

#pragma mark - CAKeyframeAnimation

- (AnimationDemoView *)demoAnimation1 {
    if (!_demoAnimation1) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat height = 200;
        CGFloat paddingH = 10;
        
        AnimationDemoView *demoView = [[AnimationDemoView alloc] initWithFrame:CGRectMake(paddingH, 10, screenSize.width - 2 * paddingH, height)];
        
        CGFloat side = 128;
        UIImageView *animatedView1 = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(demoView.bounds) - side) / 2.0, (height - side) / 2.0, side, side)];
        animatedView1.image = [UIImage imageNamed:@"genre-music.jpg"];
        animatedView1.layer.borderColor = [UIColor greenColor].CGColor;
        animatedView1.layer.borderWidth = 2;
        [demoView addSubview:animatedView1];
        
        UIImageView *animatedView2 = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(demoView.bounds) - side) / 2.0, (height - side) / 2.0, side, side)];
        animatedView2.image = [UIImage imageNamed:@"genre-blues.jpg"];
        animatedView2.layer.borderColor = [UIColor magentaColor].CGColor;
        animatedView2.layer.borderWidth = 2;
        [demoView insertSubview:animatedView2 belowSubview:animatedView1];
        
        demoView.doAnimation = ^{
            // Animate 1
            CABasicAnimation *zPosition = [CABasicAnimation animation];
            zPosition.keyPath = @"zPosition";
            zPosition.fromValue = @(self.zPosition);
            zPosition.toValue = @(-self.zPosition);
            zPosition.duration = 1.2;

            CAKeyframeAnimation *rotation = [CAKeyframeAnimation animation];
            rotation.keyPath = @"transform.rotation";
            rotation.values = @[ @0, @0.14, @0 ];
            rotation.duration = 1.2;
            rotation.timingFunctions = @[
                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
            ];

            CAKeyframeAnimation *position = [CAKeyframeAnimation animation];
            position.keyPath = @"position";
            position.values = @[
                [NSValue valueWithCGPoint:CGPointZero],
                [NSValue valueWithCGPoint:CGPointMake(110, -20)],
                [NSValue valueWithCGPoint:CGPointZero]
            ];
            position.timingFunctions = @[
                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
            ];
            position.additive = YES;
            position.duration = 1.2;

            CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
            group.animations = @[ zPosition, rotation, position ];
            group.duration = 1.2;

            [animatedView1.layer addAnimation:group forKey:@"shuffle"];
            animatedView1.layer.zPosition = -self.zPosition;
            
            // Animate 2
            
            CABasicAnimation *zPosition2 = [CABasicAnimation animation];
            zPosition2.keyPath = @"zPosition";
            zPosition2.fromValue = @(-self.zPosition);;
            zPosition2.toValue = @(self.zPosition);;
            zPosition2.duration = 1.2;

            CAKeyframeAnimation *rotation2 = [CAKeyframeAnimation animation];
            rotation2.keyPath = @"transform.rotation";
            rotation2.values = @[ @0, @-0.14, @0 ];
            rotation2.duration = 1.2;
            rotation2.timingFunctions = @[
                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
            ];

            CAKeyframeAnimation *position2 = [CAKeyframeAnimation animation];
            position2.keyPath = @"position";
            position2.values = @[
                [NSValue valueWithCGPoint:CGPointZero],
                [NSValue valueWithCGPoint:CGPointMake(-110, -20)],
                [NSValue valueWithCGPoint:CGPointZero]
            ];
            position2.timingFunctions = @[
                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
            ];
            position2.additive = YES;
            position2.duration = 1.2;

            CAAnimationGroup *group2 = [[CAAnimationGroup alloc] init];
            group2.animations = @[ zPosition2, rotation2, position2 ];
            group2.duration = 1.2;

            [animatedView2.layer addAnimation:group2 forKey:@"shuffle"];
            animatedView2.layer.zPosition = self.zPosition;
            
            // Note: use dispatch_after is not proper here, just change self.zPosition after a while
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.zPosition = -self.zPosition;
            });
        };
        
        _demoAnimation1 = demoView;
    }
    
    return _demoAnimation1;
}

@end
