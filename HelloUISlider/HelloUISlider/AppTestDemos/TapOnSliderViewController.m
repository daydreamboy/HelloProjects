//
//  TapOnSliderViewController.m
//  HelloUISlider
//
//  Created by wesley_chen on 2020/10/2.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "TapOnSliderViewController.h"

@interface TapOnSliderViewController ()
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSArray *fontSizeList;
@end

@implementation TapOnSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _fontSizeList = @[@(-3), @(0), @(2), @(4), @(7), @(10), @(12)];
    
    [self.view addSubview:self.label];
    [self.view addSubview:self.slider];
    
}

#pragma mark - Getter

- (UILabel *)label {
    if (!_label) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        
        _label = label;
    }
    
    return _label;
}

- (UISlider *)slider {
    if (!_slider) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat paddingH = 30;
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(paddingH, 90, screenSize.width - 2 * paddingH, 80)];
        slider.backgroundColor = [UIColor yellowColor];
        [slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        
        NSInteger numberOfSteps = ((float)[_fontSizeList count] - 1);
        slider.maximumValue = numberOfSteps;
        slider.minimumValue = 0;

        // As the slider moves it will continously call the -valueChanged:
        slider.continuous = YES; // NO makes it call only once you let go
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)];
        [slider addGestureRecognizer:tapGesture];
        
        _slider = slider;
    }
    
    return _slider;
}

#pragma mark - Action

- (void)sliderTapped:(UITapGestureRecognizer *)recognizer {
    UISlider *slider = (UISlider *)recognizer.view;
    
    CGPoint point = [recognizer locationInView:slider];
    CGFloat percentage = point.x / slider.bounds.size.width;
    CGFloat delta = percentage * (slider.maximumValue - slider.minimumValue);
    CGFloat value = slider.minimumValue + delta;
    NSLog(@"value: %f", value);
    
    [self changeSliderToNearestIndexWithValue:value animated:YES];
}

- (void)valueChanged:(UISlider *)sender {
    UISlider *slider = (UISlider *)sender;
    
    [self changeSliderToNearestIndexWithValue:slider.value animated:NO];
}

- (void)changeSliderToNearestIndexWithValue:(CGFloat)value animated:(BOOL)animated {
    // @see https://stackoverflow.com/questions/8219056/uislider-that-snaps-to-a-fixed-number-of-steps-like-text-size-in-the-ios-7-sett
    // Note: round the slider position to the nearest index
    NSUInteger index = (NSUInteger)(value + 0.5);
    [self.slider setValue:index animated:animated];
    
    NSNumber *number = self.fontSizeList[index]; // <-- This numeric value you want
    NSLog(@"sliderIndex: %i", (int)index);
    NSLog(@"number: %@", number);
    
    self.label.text = [NSString stringWithFormat:@"%f", self.slider.value];
}

@end
