//
//  GetImageSizeWithoutCreateUIImageViewController.m
//  HelloUIImage
//
//  Created by wesley_chen on 2020/6/26.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "GetImageSizeWithoutCreateUIImageViewController.h"
#import "WCImageTool.h"

@interface GetImageSizeWithoutCreateUIImageViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray<NSString *> *imageFileNames;
@property (nonatomic, copy) NSString *currentImageFileName;
@end

@implementation GetImageSizeWithoutCreateUIImageViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _imageFileNames = @[
            @"lena_gray.bmp",
            @"sample_1920×1280.bmp",
            @"lena_color.tiff",
            @"grayscale_1.jpg",
            @"grayscale_4.pgm",
            @"fake@2x.png",
        ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.label];
    [self.view addSubview:self.pickerView];
    
    UIBarButtonItem *loadItem = [[UIBarButtonItem alloc] initWithTitle:@"Get Image Size" style:UIBarButtonItemStylePlain target:self action:@selector(loadItemClicked:)];
    self.navigationItem.rightBarButtonItem = loadItem;
    
    self.currentImageFileName = [self.imageFileNames firstObject];
}

#pragma mark - Getter

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    
    return _label;
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
    return self.imageFileNames[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *imageFileName = self.imageFileNames[row];
    self.currentImageFileName = imageFileName;
    
    NSLog(@"selected: %@", self.currentImageFileName);
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.imageFileNames count];
}

#pragma mark - Action

- (void)loadItemClicked:(id)sender {

    if (self.currentImageFileName.length) {
        NSString *filename = self.currentImageFileName;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[filename stringByDeletingPathExtension] ofType:[filename pathExtension]];

        // Note: set scale to 1, to get original image size
        self.image = [UIImage imageWithContentsOfFile:filePath];
        CGSize imageSize = [WCImageTool imageSizeWithPath:filePath scale:1];
        
        self.label.text = [NSString stringWithFormat:@"width(px): %@, height(px): %@", @(imageSize.width), @(imageSize.height)];
        [self.label sizeToFit];
        
        self.label.center = CGPointMake(CGRectGetMidX(self.view.bounds), 300);
    }
}

@end
