//
//  ViewController.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 15/1/24.
//  Copyright (c) 2015年 wesley_chen. All rights reserved.
//

#import "ScaleViewController.h"

@interface ScaleViewController ()
@property (nonatomic, strong) UIImageView *scaledView;
@end

@implementation ScaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UIImageView *scaledView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 256, 256)];
    scaledView.image = [UIImage imageNamed:@"Xcode"];
    scaledView.backgroundColor = [UIColor yellowColor];
    scaledView.userInteractionEnabled = YES;
    scaledView.center = self.view.center;
    scaledView.transform = CGAffineTransformMakeScale(1 / CGRectGetWidth(scaledView.frame), 1 / CGRectGetHeight(scaledView.frame));
    scaledView.hidden = YES; // Scale smallest, still one point there, so hide it
    [self.view addSubview:scaledView];
    self.scaledView = scaledView;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"Tap Me";
    label.textAlignment = NSTextAlignmentCenter;
    label.center = self.view.center;
    [self.view addSubview:label];
    
    // Add UITapGestureRecognizer
    [self addTapGestureRecognizer:self.view action:@selector(viewTapped:)];
    [self addTapGestureRecognizer:self.scaledView action:@selector(viewTapped:)];
}

- (void)addTapGestureRecognizer:(UIView *)tappedView action:(SEL)selector {
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    [tappedView addGestureRecognizer:tapRecognizer];
}

- (void)viewTapped:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    if (tappedView == self.view) {
        // Avoid self.view being tapped again during animation
        self.view.userInteractionEnabled = NO;
        self.scaledView.layer.shouldRasterize = YES;
        self.scaledView.hidden = NO;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.scaledView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.view.userInteractionEnabled = YES;
            self.scaledView.layer.shouldRasterize = NO;
        }];
    }
    else if (tappedView == self.scaledView) {
        self.view.userInteractionEnabled = NO;
        self.scaledView.layer.shouldRasterize = YES;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.scaledView.transform = CGAffineTransformMakeScale(1 / CGRectGetWidth(self.scaledView.frame), 1 / CGRectGetHeight(self.scaledView.frame));
        } completion:^(BOOL finished) {
            self.view.userInteractionEnabled = YES;
            self.scaledView.layer.shouldRasterize = NO;
            self.scaledView.hidden = YES;
        }];
    }
}

@end
