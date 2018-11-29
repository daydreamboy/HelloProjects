//
//  GetAllFontNamesViewController.m
//  HelloUIFont
//
//  Created by wesley_chen on 2018/11/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "GetAllFontNamesViewController.h"

#ifndef NSARRAY_SAFE_GET
#define NSARRAY_SAFE_GET(array, index)                      \
    ({                                                      \
        id value = nil;                                     \
        if (array && 0 <= index && index < [array count]) { \
            value = [array objectAtIndex:index];            \
        }                                                   \
        value;                                              \
    })

#endif /* NSARRAY_SAFE_GET */

@interface GetAllFontNamesViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *labelFontName;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong, readonly) NSArray<NSString *> *familyNames;
@end

@implementation GetAllFontNamesViewController

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
        label.text = [label.font fontName];
        
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

- (NSArray<NSString *> *)familyNames {
    return [[UIFont familyNames] sortedArrayUsingSelector:@selector(compare:)];
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.familyNames[row];
    }
    else {
        NSInteger index = [self.pickerView selectedRowInComponent:0];
        NSString *familyName = NSARRAY_SAFE_GET(self.familyNames, index);
        NSArray<NSString *> *fontNames = [UIFont fontNamesForFamilyName:familyName];
        
        return fontNames[row];
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
    
    NSString *familyName = NSARRAY_SAFE_GET(self.familyNames, index1);
    NSArray<NSString *> *fontNames = [UIFont fontNamesForFamilyName:familyName];
    NSString *fontName = NSARRAY_SAFE_GET(fontNames, index2);
    
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
        NSArray<NSString *> *familyNames = [[UIFont familyNames] sortedArrayUsingSelector:@selector(compare:)];
        return [familyNames count];
    }
    else {
        NSInteger index = [self.pickerView selectedRowInComponent:0];
        NSString *familyName = NSARRAY_SAFE_GET(self.familyNames, index);
        NSArray<NSString *> *fontNames = [UIFont fontNamesForFamilyName:familyName];
        
        return [fontNames count];
    }
}

@end
