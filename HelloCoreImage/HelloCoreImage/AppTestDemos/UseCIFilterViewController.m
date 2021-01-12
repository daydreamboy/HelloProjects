//
//  UseCIFilterViewController.m
//  HelloCoreImage
//
//  Created by wesley_chen on 2021/1/6.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "UseCIFilterViewController.h"
#import "WCMacroTool.h"
#import "WCViewTool.h"
#import "WCCoreImageTool.h"

#define kFilterOriginal     @"Original"
#define kFilterColorInvert  @"CIColorInvert"
#define kFilterMaskToAlpha  @"CIMaskToAlpha"

@interface UseCIFilterViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UILabel *labelFilterName;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *filterNames;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *imageOriginal;
@end

@implementation UseCIFilterViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _filterNames = @[
            kFilterOriginal,
            kFilterColorInvert,
            kFilterMaskToAlpha,
        ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.labelFilterName];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.pickerView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat y = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(_pickerView.bounds) - [WCViewTool safeAreaInsetsWithView:self.view].bottom;
    self.pickerView.frame = FrameSetOrigin(self.pickerView.frame, NAN, y);
}

#pragma mark - Getter

- (UILabel *)labelFilterName {
    if (!_labelFilterName) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat marginH = 10;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(marginH, 10, screenSize.width - 2 * marginH, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        
        _labelFilterName = label;
    }
    
    return _labelFilterName;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageOriginal = [UIImage imageNamed:@"chrome.png"];
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat marginH = 10;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(marginH, CGRectGetMaxY(_labelFilterName.frame) + 10, screenSize.width - 2 * marginH, screenSize.width - 2 * marginH)];
        imageView.image = _imageOriginal;
        imageView.layer.borderColor = [UIColor redColor].CGColor;
        imageView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        
        _imageView = imageView;
    }
    
    return _imageView;
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

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *filterName = NSARRAY_SAFE_GET(self.filterNames, row);
    
    return filterName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *filterName = NSARRAY_SAFE_GET(self.filterNames, row);
    
    self.labelFilterName.text = filterName;
    NSLog(@"selected filter: %@", filterName);
    
    CIImage *originalCIImage = [CIImage imageWithCGImage:self.imageOriginal.CGImage];
    if ([filterName isEqualToString:kFilterColorInvert]) {
        CIImage *ciImage = [WCCoreImageTool invertColorsWithImage:originalCIImage];
        self.imageView.image = [UIImage imageWithCIImage:ciImage];
    }
    else if ([filterName isEqualToString:kFilterMaskToAlpha]) {
        CIImage *ciImage = [WCCoreImageTool blackColorToTransparentWithImage:originalCIImage];
        self.imageView.image = [UIImage imageWithCIImage:ciImage];
    }
    else {
        self.imageView.image = self.imageOriginal;
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.filterNames count];
}

@end
