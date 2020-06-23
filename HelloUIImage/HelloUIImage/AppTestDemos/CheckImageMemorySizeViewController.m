//
//  CheckImageMemorySizeViewController.m
//  HelloUIImage
//
//  Created by wesley_chen on 2020/6/22.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "CheckImageMemorySizeViewController.h"
#import "WCImageTool.h"
#import "WCMacroTool.h"
#import "WCViewTool.h"
#import "WCStringTool.h"

@interface CheckImageMemorySizeViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray<NSString *> *imageFileNames;
@property (nonatomic, copy) NSString *currentImageFileName;
@end

@implementation CheckImageMemorySizeViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _imageFileNames = @[
            @"lena_gray.bmp",
            @"sample_1920×1280.bmp",
            @"lena_color.tiff",
            @"grayscale_1.jpg",
            @"grayscale_4.pgm",
        ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.pickerView];
    
    UIBarButtonItem *loadItem = [[UIBarButtonItem alloc] initWithTitle:@"Load" style:UIBarButtonItemStylePlain target:self action:@selector(loadItemClicked:)];
    self.navigationItem.rightBarButtonItem = loadItem;
    
    self.currentImageFileName = [self.imageFileNames firstObject];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat y = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(_pickerView.bounds) - [WCViewTool safeAreaInsetsWithView:self.view].bottom;
    self.pickerView.frame = FrameSetOrigin(self.pickerView.frame, NAN, y);
}

#pragma mark - Getter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
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
        
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        self.imageView.image = image;
        
        NSLog(@"image ref: %@", image.CGImage);
        
        NSUInteger bytes = [WCImageTool memoryBytesWithImage:image];
        NSLog(@"increased memory size: %@", [WCStringTool prettySizeWithMemoryBytes:bytes]);
        
        self.title = [NSString stringWithFormat:@"%@", [WCStringTool prettySizeWithMemoryBytes:bytes]];
    }
}

@end
