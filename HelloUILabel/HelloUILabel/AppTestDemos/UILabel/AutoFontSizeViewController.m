//
//  AutoFontSizeViewController.m
//  HelloUILabel
//
//  Created by wesley_chen on 2020/9/27.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "AutoFontSizeViewController.h"
#import "WCFontTool.h"

@interface AutoFontSizeViewController ()
@property (nonatomic, strong) UILabel *labelAutoFontSizeSingleLine;
@property (nonatomic, strong) UILabel *labelAutoFontSizeMultipleLine;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *sliderValue;
@end

@implementation AutoFontSizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.labelAutoFontSizeSingleLine];
    [self.view addSubview:self.labelAutoFontSizeMultipleLine];
    
    [self.view addSubview:self.slider];
    [self.view addSubview:self.sliderValue];
    
    [self sliderValueChanged:self.slider];
}

#pragma mark - Getters

- (UILabel *)labelAutoFontSizeSingleLine {
    if (!_labelAutoFontSizeSingleLine) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat marginH = 60;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(marginH, 20, screenSize.width - 2 * marginH, 30)];
        label.text = @"a long long long text";
        label.backgroundColor = [UIColor yellowColor];
        
        _labelAutoFontSizeSingleLine = label;
    }
    
    return _labelAutoFontSizeSingleLine;
}

- (UILabel *)labelAutoFontSizeMultipleLine {
    if (!_labelAutoFontSizeMultipleLine) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat marginH = 60;
        CGFloat space = 10;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(marginH, CGRectGetMaxY(_labelAutoFontSizeSingleLine.frame) + space, screenSize.width - 2 * marginH, 80)];
        label.text = @"a long long long text";
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor yellowColor];
        
        _labelAutoFontSizeMultipleLine = label;
    }
    
    return _labelAutoFontSizeMultipleLine;
}

- (UISlider *)slider {
    if (!_slider) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat marginH = 10;
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(marginH, 300, screenSize.width - 2 * marginH, 30)];
        slider.backgroundColor = [UIColor greenColor];
        slider.minimumValue = 0;
        slider.maximumValue = 100;
        slider.value = 50;//17;
        [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        _slider = slider;
    }
    
    return _slider;
}

- (UILabel *)sliderValue {
    if (!_sliderValue) {
        CGFloat height = 30;
        CGFloat space = 10;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_slider.frame), CGRectGetMinY(_slider.frame) - height - space, CGRectGetWidth(_slider.frame), height)];
        label.textAlignment = NSTextAlignmentCenter;
        
        _sliderValue = label;
    }
    
    return _sliderValue;
}

#pragma mark - Action

- (void)sliderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    self.sliderValue.text = [NSString stringWithFormat:@"fontSize: %f", slider.value];
    
    UIFont *font = [UIFont systemFontOfSize:slider.value];
    
    self.labelAutoFontSizeSingleLine.font = ({
        UIFont *adaptiveFont = [WCFontTool adaptiveFontWithInitialFont:font minimumFontSize:10 contrainedSize:self.labelAutoFontSizeSingleLine.bounds.size mutilpleLines:NO textString:self.labelAutoFontSizeSingleLine.text];
        adaptiveFont;
    });
    
    self.labelAutoFontSizeMultipleLine.font = ({
        UIFont *adaptiveFont = [WCFontTool adaptiveFontWithInitialFont:font minimumFontSize:10 contrainedSize:self.labelAutoFontSizeMultipleLine.bounds.size mutilpleLines:YES textString:self.labelAutoFontSizeMultipleLine.text];
        adaptiveFont;
    });
}

@end
