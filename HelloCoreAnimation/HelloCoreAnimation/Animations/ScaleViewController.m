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
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *labelXPercent;
@property (nonatomic, strong) UILabel *labelYPercent;
@property (nonatomic, strong) UISlider *slideXPercent;
@property (nonatomic, strong) UISlider *slideYPercent;
@end

@implementation ScaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scaledView];
    [self.view addSubview:self.label];
    [self.view addSubview:self.labelXPercent];
    [self.view addSubview:self.labelYPercent];
    [self.view addSubview:self.slideXPercent];
    [self.view addSubview:self.slideYPercent];
    
    // Add UITapGestureRecognizer
    [self addTapGestureRecognizer:self.view action:@selector(viewTapped:)];
    [self addTapGestureRecognizer:self.scaledView action:@selector(viewTapped:)];
}

#pragma mark - Getters

- (UIImageView *)scaledView {
    if (!_scaledView) {
        UIImageView *scaledView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 256, 256)];
        scaledView.image = [UIImage imageNamed:@"Xcode"];
        scaledView.backgroundColor = [UIColor yellowColor];
        scaledView.userInteractionEnabled = YES;
        scaledView.center = self.view.center;
        scaledView.transform = CGAffineTransformMakeScale(1 / CGRectGetWidth(scaledView.frame), 1 / CGRectGetHeight(scaledView.frame));
        scaledView.hidden = YES; // Scale smallest, still one point there, so hide it
        
        _scaledView = scaledView;
    }
    
    return _scaledView;
}

- (UILabel *)label {
    if (!_label) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"Tap Me";
        label.textAlignment = NSTextAlignmentCenter;
        label.center = self.view.center;
        
        _label = label;
    }
    
    return _label;
}

#define SLIDER_W    240
#define SLIDER_H    40

- (UILabel *)labelXPercent {
    if (!_labelXPercent) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 84, 120, SLIDER_H)];
        label.text = @"anchorPoint.x";
        
        _labelXPercent = label;
    }
    
    return _labelXPercent;
}

- (UILabel *)labelYPercent {
    if (!_labelYPercent) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 144, 120, SLIDER_H)];
        label.text = @"anchorPoint.y";
        
        _labelYPercent = label;
    }
    
    return _labelYPercent;
}

- (UISlider *)slideXPercent {
    if (!_slideXPercent) {
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.labelXPercent.frame), CGRectGetMinY(self.labelXPercent.frame), SLIDER_W, SLIDER_H)];
        slider.minimumValue = 0;
        slider.maximumValue = 1;
        slider.value = self.scaledView.layer.anchorPoint.x;
        [slider addTarget:self action:@selector(slideValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        _slideXPercent = slider;
    }
    
    return _slideXPercent;
}

- (UISlider *)slideYPercent {
    if (!_slideYPercent) {
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.labelYPercent.frame), CGRectGetMinY(self.labelYPercent.frame), SLIDER_W, SLIDER_H)];
        slider.minimumValue = 0;
        slider.maximumValue = 1;
        slider.value = self.scaledView.layer.anchorPoint.y;
        [slider addTarget:self action:@selector(slideValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        _slideYPercent = slider;
    }
    
    return _slideYPercent;
}

- (void)addTapGestureRecognizer:(UIView *)tappedView action:(SEL)selector {
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    [tappedView addGestureRecognizer:tapRecognizer];
}

#pragma mark - Actions

- (void)slideValueChanged:(id)sender {
    if (sender == self.slideXPercent) {
        CGPoint anchorPoint = self.scaledView.layer.anchorPoint;
        anchorPoint.x = ((UISlider *)sender).value;
        self.scaledView.layer.anchorPoint = anchorPoint;
    }
    else if (sender == self.slideYPercent) {
        CGPoint anchorPoint = self.scaledView.layer.anchorPoint;
        anchorPoint.y = ((UISlider *)sender).value;
        self.scaledView.layer.anchorPoint = anchorPoint;
    }
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
