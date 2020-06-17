//
//  ShrinkViewController.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 2020/6/15.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import "ShrinkViewController.h"

@interface ShrinkViewController ()
@property (nonatomic, strong) UIImageView *shrinkView;
@property (nonatomic, assign) BOOL shrinked;
@end

@implementation ShrinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.shrinkView];
    
    [self addTapGestureRecognizer:self.view action:@selector(viewTapped:)];
}

#pragma mark -

- (void)addTapGestureRecognizer:(UIView *)tappedView action:(SEL)selector {
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    [tappedView addGestureRecognizer:tapRecognizer];
}

#pragma mark - Getter

- (UIImageView *)shrinkView {
    if (!_shrinkView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 256, 256)];
        imageView.image = [UIImage imageNamed:@"Xcode"];
        imageView.backgroundColor = [UIColor yellowColor];
        imageView.userInteractionEnabled = YES;
        
        _shrinkView = imageView;
    }
    
    return _shrinkView;
}

- (void)viewTapped:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    if (tappedView == self.view) {
        self.shrinked = !self.shrinked;
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        if (self.shrinked) {
            CATransition *animation = [CATransition animation];
            animation.type = @"genieEffect";
            animation.duration = 2.0f;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            self.shrinkView.layer.opacity = 1.0f;
            [self.shrinkView.layer addAnimation:animation forKey:@"transitionViewAnimation"];
            
//            self.view.userInteractionEnabled = NO;
//            [UIView animateWithDuration:5 animations:^{
//                self.shrinkView.layer.transform = CATransform3DMakeScale(0.2, 0.2, 1);
//                self.shrinkView.layer.position = CGPointMake(screenSize.width - 100, screenSize.height - 200);
//                self.shrinkView.layer.opacity = 0.0f;
//            } completion:^(BOOL finished) {
//                self.view.userInteractionEnabled = YES;
//            }];
        }
        else {
            self.view.userInteractionEnabled = NO;
            [UIView animateWithDuration:0.5 animations:^{
                self.shrinkView.transform = CGAffineTransformIdentity;
                self.shrinkView.frame = CGRectMake(0, 0, 256, 256);
                self.shrinkView.alpha = 1.0f;
            } completion:^(BOOL finished) {
                self.view.userInteractionEnabled = YES;
            }];
        }
    }
}


@end
