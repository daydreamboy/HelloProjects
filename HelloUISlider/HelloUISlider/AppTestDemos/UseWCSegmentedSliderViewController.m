//
//  UseWCSegmentedSliderViewController.m
//  HelloUISlider
//
//  Created by wesley_chen on 2020/10/2.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseWCSegmentedSliderViewController.h"
#import "WCSegmentedSlider.h"

#define kSpace 10

@interface UseWCSegmentedSliderViewController () <WCSegmentedSliderDelegate>
@property (nonatomic, strong) WCSegmentedSlider *sliderDefault;
@property (nonatomic, strong) WCSegmentedSlider *sliderDebugging;
@property (nonatomic, strong) WCSegmentedSlider *sliderProgressColor;
@property (nonatomic, strong) WCSegmentedSlider *sliderCustomizedColor;
@property (nonatomic, strong) UILabel *label;
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
        WCSegmentedSlider *slider = [[WCSegmentedSlider alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(_sliderProgressColor.frame) + kSpace, screenSize.width - 2 * paddingH, 80) numberOfSegments:6];
        slider.backgroundColor = [UIColor yellowColor];
        slider.trackLineBackgroundColor = [UIColor redColor];
        slider.trackLineProgressColor = [UIColor greenColor];
        slider.indexViewsBackgroundColor = [UIColor redColor];
        slider.indexViewSize = CGSizeMake(6, 9);
        slider.delegate = self;
        
        _sliderCustomizedColor = slider;
    }
    
    return _sliderCustomizedColor;
}

#pragma mark - WCSegmentedSliderDelegate

- (void)segmentedSlider:(WCSegmentedSlider *)slider willChangeValueToIndex:(NSUInteger)toIndex fromIndex:(NSUInteger)fromIndex animated:(BOOL)animated {
    
}

- (void)segmentedSlider:(WCSegmentedSlider *)slider didChangeValueToIndex:(NSUInteger)toIndex fromIndex:(NSUInteger)fromIndex animated:(BOOL)animated {
    self.label.text = [NSString stringWithFormat:@"%f", slider.value];
}

@end
