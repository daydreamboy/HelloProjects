//
//  SystemFontViewController.m
//  HelloUIFont
//
//  Created by wesley_chen on 2018/11/30.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "SystemFontViewController.h"

#ifndef NSARRAY_SAFE_GET
#define NSARRAY_SAFE_GET(array, index)                      \
    ({                                                      \
        id __value = nil;                                     \
        if (array && 0 <= index && index < [array count]) { \
            __value = [array objectAtIndex:index];            \
        }                                                   \
        __value;                                              \
    })

#endif /* NSARRAY_SAFE_GET */

@interface SystemFontViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *labelFontName;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong, readonly) NSDictionary<NSString *, NSNumber *> *fontWeightInfo;
@property (nonatomic, strong, readonly) NSDictionary<NSString *, NSArray *> *pickerViewData;
@end

@implementation SystemFontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.label];
    [self.view addSubview:self.labelFontName];
    [self.view addSubview:self.pickerView];
}

#pragma mark - Getters

- (UILabel *)label {
    if (!_label) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat marginH = 10;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(marginH, CGRectGetHeight(self.navigationController.navigationBar.bounds) + 10, screenSize.width - 2 * marginH, 60)];
        label.text = @"Hello, world!你好，世界！";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBlack];
        
        _label = label;
    }
    
    return _label;
}

- (UILabel *)labelFontName {
    if (!_labelFontName) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat marginH = 10;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(marginH, CGRectGetMaxY(self.label.frame) + 10, screenSize.width - 2 * marginH, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [self.label.font fontName];
        
        _labelFontName = label;
    }
    
    return _labelFontName;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - CGRectGetHeight(_pickerView.bounds) - CGRectGetHeight(self.navigationController.navigationBar.bounds), screenSize.width, CGRectGetHeight(_pickerView.bounds));
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    }
    
    return _pickerView;
}

- (NSDictionary<NSString *,NSArray *> *)pickerViewData {
    return @{
             @"System": @[],
             @"System-Bold": @[],
             @"System-Italic": @[],
             @"System Weight": @[
                     @"UIFontWeightBlack",
                     @"UIFontWeightBold",
                     @"UIFontWeightHeavy",
                     @"UIFontWeightLight",
                     @"UIFontWeightMedium",
                     @"UIFontWeightRegular",
                     @"UIFontWeightSemibold",
                     @"UIFontWeightThin",
                     @"UIFontWeightUltraLight",
                     ],
             };
}

- (UIFontWeight)fontWeightFromString:(NSString *)string {
    NSDictionary *table = @{
                            @"UIFontWeightBlack": @(UIFontWeightBlack),
                            @"UIFontWeightBold": @(UIFontWeightBold),
                            @"UIFontWeightHeavy": @(UIFontWeightHeavy),
                            @"UIFontWeightLight": @(UIFontWeightLight),
                            @"UIFontWeightMedium": @(UIFontWeightMedium),
                            @"UIFontWeightRegular": @(UIFontWeightRegular),
                            @"UIFontWeightSemibold": @(UIFontWeightSemibold),
                            @"UIFontWeightThin": @(UIFontWeightThin),
                            @"UIFontWeightUltraLight": @(UIFontWeightUltraLight),
                            };
    
    UIFontWeight weight = [table[string] doubleValue];
    
    return weight;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.pickerViewData allKeys][row];
    }
    else {
        NSInteger index = [self.pickerView selectedRowInComponent:0];
        NSString *key = [self.pickerViewData allKeys][index];
        NSArray<NSString *> *value = self.pickerViewData[key];

        return NSARRAY_SAFE_GET(value, row);
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger index1;
    NSInteger index2;

    if (component == 0) {
        [pickerView reloadComponent:1];

        index1 = row;
        index2 = [self.pickerView selectedRowInComponent:1];
    }
    else {
        index1 = [self.pickerView selectedRowInComponent:0];
        index2 = row;
    }

    NSString *key = [self.pickerViewData allKeys][index1];
    NSArray<NSString *> *value = self.pickerViewData[key];
    
    NSString *fontName;
    if (value.count == 0) {
        fontName = key;
    }
    else {
        fontName = NSARRAY_SAFE_GET(value, index2);
    }

    self.labelFontName.text = fontName;
    if (fontName) {
        self.label.font = [UIFont fontWithName:fontName size:18];
    }
    else {
        self.label.font = nil;
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [[self.pickerViewData allKeys] count];
    }
    else {
        NSInteger index = [self.pickerView selectedRowInComponent:0];
        NSString *key = [self.pickerViewData allKeys][index];
        
        return [self.pickerViewData[key] count];
    }
}

@end
