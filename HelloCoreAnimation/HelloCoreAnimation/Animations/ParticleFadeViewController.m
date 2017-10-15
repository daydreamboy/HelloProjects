//
//  ParticleFadeViewController.m
//  HelloCoreAnimation
//
//  Created by wesley chen on 16/8/16.
//  Copyright © 2016年 wesley_chen. All rights reserved.
//

#import "ParticleFadeViewController.h"

@interface ParticleFadeViewController ()
@property (nonatomic, strong) UILabel *labelAngle;
@property (nonatomic, strong) CAEmitterLayer *emitterLayer;

@property (nonatomic, strong) UISlider *sliderScale;

@end

@implementation ParticleFadeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.sliderScale];
    
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    emitterLayer.emitterPosition = self.view.center;
    self.emitterLayer = emitterLayer;
    [self.view.layer addSublayer:emitterLayer];
    
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    emitterCell.contents = (id)[UIImage imageNamed:@"logo64X64"].CGImage;
    emitterCell.birthRate = 1.0f;
    emitterCell.velocity = 10.0f;
    emitterCell.lifetime = 1.0f;
    emitterCell.scale = 1.0f;
    emitterCell.name = @"emitterCell";
    emitterLayer.emitterCells = [NSArray arrayWithObject:emitterCell];
    
    UILabel *angleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20 + 64, 100, 30)];
    angleLabel.backgroundColor = [UIColor clearColor];
    angleLabel.textColor = [UIColor blackColor];
    [self.view addSubview:angleLabel];
    self.labelAngle = angleLabel;
    
    [self bumpAngle];
}

- (void)bumpAngle {
    NSNumber *emissionLongitude = [self.emitterLayer valueForKeyPath:@"emitterCells.emitterCell.emissionLongitude"];
    NSNumber *nextLongtitude = [NSNumber numberWithFloat:[emissionLongitude floatValue] + 0.02];
    [self.emitterLayer setValue:nextLongtitude forKeyPath:@"emitterCells.emitterCell.emissionLongitude"];
    
    self.labelAngle.text = [NSString stringWithFormat:@"%.0f degrees", [nextLongtitude floatValue] * 180 / M_PI];
    
//    [self performSelector:@selector(bumpAngle) withObject:nil afterDelay:0.1];
}

#pragma mark - Getters

- (UISlider *)sliderScale {
    if (!_sliderScale) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 64 + 10, screenSize.width, 10)];
        slider.maximumValue = 1.0f;
        slider.minimumValue = 0.1f;
        [slider addTarget:self action:@selector(silderScaleValueChanged:) forControlEvents:UIControlEventValueChanged];
//        [slider sizeToFit];
        
        _sliderScale = slider;
    }
    
    return _sliderScale;
}

#pragma mark - Actions

- (void)silderScaleValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    CGFloat value = slider.value;
    
    [self.emitterLayer setValue:@(value) forKeyPath:@"emitterCells.emitterCell.scale"];
}

@end
