//
//  UseWCSegmentedSliderViewController.m
//  HelloUISlider
//
//  Created by wesley_chen on 2020/10/2.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseWCSegmentedSliderViewController.h"
#import "WCSegmentedSlider.h"
#import "UIView+Position.h"

#define kSpace 10

@interface UseWCSegmentedSliderViewController () <WCSegmentedSliderDelegate>
@property (nonatomic, strong) WCSegmentedSlider *sliderDefault;
@property (nonatomic, strong) WCSegmentedSlider *sliderDebugging;
@property (nonatomic, strong) WCSegmentedSlider *sliderProgressColor;
@property (nonatomic, strong) WCSegmentedSlider *sliderCustomizedColor;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *labelSmallest;
@property (nonatomic, strong) UILabel *labelBiggest;
@end

@implementation UseWCSegmentedSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.label];
    [self.view addSubview:self.sliderDefault];
    [self.view addSubview:self.sliderDebugging];
    [self.view addSubview:self.sliderProgressColor];
    [self.view addSubview:self.sliderCustomizedColor];
    [self.view addSubview:self.labelSmallest];
    [self.view addSubview:self.labelBiggest];
    
    UISwitch *switcher = [UISwitch new];
    switcher.on = YES;
    [switcher addTarget:self action:@selector(switcherToggled:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:switcher];
}

#pragma mark - Action

- (void)switcherToggled:(UISwitch *)sender {
    BOOL on = sender.on;
    
    self.sliderDefault.tapOnTrackLineEnabled = on;
    self.sliderDebugging.tapOnTrackLineEnabled = on;
    self.sliderProgressColor.tapOnTrackLineEnabled = on;
    self.sliderCustomizedColor.tapOnTrackLineEnabled = on;
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

- (WCSegmentedSlider *)sliderDefault {
    if (!_sliderDefault) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat paddingH = 30;
        WCSegmentedSlider *slider = [[WCSegmentedSlider alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(_label.frame) + kSpace, screenSize.width - 2 * paddingH, 80) numberOfSegments:6];
        slider.backgroundColor = [UIColor yellowColor];
        //slider.indexViewsBackgroundColor = [UIColor redColor];
        //slider.indexViewSize = CGSizeMake(6, 9);
        slider.delegate = self;
        
        _sliderDefault = slider;
    }
    
    return _sliderDefault;
}

- (WCSegmentedSlider *)sliderDebugging {
    if (!_sliderDebugging) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat paddingH = 30;
        WCSegmentedSlider *slider = [[WCSegmentedSlider alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(_sliderDefault.frame) + kSpace, screenSize.width - 2 * paddingH, 80) numberOfSegments:6];
        slider.backgroundColor = [UIColor yellowColor];
        slider.debugging = YES;
        slider.trackLineBackgroundColor = [UIColor redColor];
        slider.enableThumbOnEdgeIndex = YES;
        slider.delegate = self;
        
        _sliderDebugging = slider;
    }
    
    return _sliderDebugging;
}

- (WCSegmentedSlider *)sliderProgressColor {
    if (!_sliderProgressColor) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat paddingH = 30;
        WCSegmentedSlider *slider = [[WCSegmentedSlider alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(_sliderDebugging.frame) + kSpace, screenSize.width - 2 * paddingH, 80) numberOfSegments:6];
        slider.backgroundColor = [UIColor yellowColor];
        slider.trackLineBackgroundColor = [UIColor redColor];
        slider.trackLineProgressColor = [UIColor greenColor];
        slider.trackLinePaddings = UIEdgeInsetsMake(0, 20, 0, 20);
        slider.delegate = self;
        
        _sliderProgressColor = slider;
    }
    
    return _sliderProgressColor;
}

- (WCSegmentedSlider *)sliderCustomizedColor {
    if (!_sliderCustomizedColor) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat paddingH = 30;
        WCSegmentedSlider *slider = [[WCSegmentedSlider alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(_sliderProgressColor.frame) + kSpace, screenSize.width - 2 * paddingH, 40) numberOfSegments:6];
        slider.backgroundColor = [UIColor yellowColor];
        slider.trackLineBackgroundColor = [UIColor redColor];
        slider.trackLineProgressColor = [UIColor greenColor];
        slider.indexViewsBackgroundColor = [UIColor redColor];
        slider.indexViewSize = CGSizeMake(6, 9);
        slider.enableThumbOnEdgeIndex = YES;
        slider.trackLinePaddings = UIEdgeInsetsMake(0, slider.thumbSize.width / 2.0, 0, slider.thumbSize.width / 2.0);
        slider.delegate = self;
        slider.debugging = YES;
        
        _sliderCustomizedColor = slider;
    }
    
    return _sliderCustomizedColor;
}

- (UILabel *)labelSmallest {
    if (!_labelSmallest) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"标准";
        [label sizeToFit];
        label.cx = CGRectGetMinX(_sliderCustomizedColor.frame) + _sliderCustomizedColor.thumbSize.width / 2.0 + _sliderCustomizedColor.indexViewSize.width / 2.0;
        label.y = CGRectGetMaxY(_sliderCustomizedColor.frame);
        
        _labelSmallest = label;
    }
    
    return _labelSmallest;
}

- (UILabel *)labelBiggest {
    if (!_labelBiggest) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"大";
        [label sizeToFit];
        label.cx = CGRectGetMaxX(_sliderCustomizedColor.frame) - _sliderCustomizedColor.thumbSize.width / 2.0 - _sliderCustomizedColor.indexViewSize.width / 2.0;
        label.y = CGRectGetMaxY(_sliderCustomizedColor.frame);
        
        _labelBiggest = label;
    }
    
    return _labelBiggest;
}

#pragma mark - WCSegmentedSliderDelegate

- (void)segmentedSlider:(WCSegmentedSlider *)slider willChangeValueToIndex:(NSUInteger)toIndex fromIndex:(NSUInteger)fromIndex animated:(BOOL)animated {
    
}

- (void)segmentedSlider:(WCSegmentedSlider *)slider didChangeValueToIndex:(NSUInteger)toIndex fromIndex:(NSUInteger)fromIndex animated:(BOOL)animated {
    self.label.text = [NSString stringWithFormat:@"%f", slider.value];
}

@end
