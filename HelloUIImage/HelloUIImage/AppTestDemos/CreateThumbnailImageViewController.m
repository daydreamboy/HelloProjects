//
//  CreateThumbnailImageViewController.m
//  HelloUIImage
//
//  Created by wesley_chen on 2020/6/25.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "CreateThumbnailImageViewController.h"
#import "WCMacroTool.h"
#import "WCViewTool.h"
#import "WCImageTool.h"

@interface CreateThumbnailImageViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray<NSString *> *imageFileNames;
@property (nonatomic, copy) NSString *currentImageFileName;
@end

@implementation CreateThumbnailImageViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _imageFileNames = @[
            @"sample_1920×1280.bmp",
            @"grayscale_1.jpg",
            @"orientation_up.jpeg",
        ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView1];
    [self.view addSubview:self.imageView2];
    [self.view addSubview:self.pickerView];
    
    UIBarButtonItem *loadItem1 = [[UIBarButtonItem alloc] initWithTitle:@"Load Image" style:UIBarButtonItemStylePlain target:self action:@selector(loadItem1Clicked:)];
    UIBarButtonItem *loadItem2 = [[UIBarButtonItem alloc] initWithTitle:@"Load Thumbnail" style:UIBarButtonItemStylePlain target:self action:@selector(loadItem2Clicked:)];
    
    self.navigationItem.rightBarButtonItems = @[ loadItem1, loadItem2 ];
    
    self.currentImageFileName = [self.imageFileNames firstObject];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat y = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(_pickerView.bounds) - [WCViewTool safeAreaInsetsWithView:self.view].bottom;
    self.pickerView.frame = FrameSetOrigin(self.pickerView.frame, NAN, y);
}

#pragma mark - Getter

- (UIImageView *)imageView1 {
    if (!_imageView1) {
        _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    }
    
    return _imageView1;
}

- (UIImageView *)imageView2 {
    if (!_imageView2) {
        _imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView1.frame) + 20, 300, 300)];
    }
    
    return _imageView2;
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

- (void)loadItem1Clicked:(id)sender {
    if (self.currentImageFileName.length) {
        NSString *filename = self.currentImageFileName;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[filename stringByDeletingPathExtension] ofType:[filename pathExtension]];
        
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        self.imageView1.image = image;
        
        NSLog(@"image1 memeory size: %@", STR_PRETTY_SIZE_M([WCImageTool memoryBytesWithImage:image]));
    }
}

- (void)loadItem2Clicked:(id)sender {
    if (self.currentImageFileName.length) {
        NSString *filename = self.currentImageFileName;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[filename stringByDeletingPathExtension] ofType:[filename pathExtension]];
        
        UIImage *image = [WCImageTool thumbnailImageWithPath:filePath boundingSize:self.imageView2.bounds.size scale:0];
        self.imageView2.image = image;
        
        NSLog(@"image2 memeory size: %@", STR_PRETTY_SIZE_M([WCImageTool memoryBytesWithImage:image]));
    }
}

@end
