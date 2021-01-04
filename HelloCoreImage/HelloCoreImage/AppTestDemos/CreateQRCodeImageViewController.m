//
//  CreateQRCodeImageViewController.m
//  HelloUIImage
//
//  Created by wesley_chen on 2020/12/21.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "CreateQRCodeImageViewController.h"
#import "WCCoreImageTool.h"

@interface CreateQRCodeImageViewController () <UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIImageView *imageViewQRCode;
@property (nonatomic, strong) UIImageView *imageViewQRCodeColour;
@end

@implementation CreateQRCodeImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.textView];
    [self.view addSubview:self.imageViewQRCode];
    [self.view addSubview:self.imageViewQRCodeColour];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - Getter

- (UITextView *)textView {
    if (!_textView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat paddingH = 10;
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(paddingH, paddingH, screenSize.width - 2 * paddingH, 80)];
        textView.font = [UIFont systemFontOfSize:17];
        textView.layer.borderColor = [UIColor orangeColor].CGColor;
        textView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        textView.delegate = self;
        
        _textView = textView;
    }
    
    return _textView;
}

- (UIImageView *)imageViewQRCode {
    if (!_imageViewQRCode) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat side = 200;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((screenSize.width - side) / 2.0, CGRectGetMaxY(_textView.frame) + 10, side, side)];
        imageView.layer.borderColor = [UIColor redColor].CGColor;
        imageView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        
        _imageViewQRCode = imageView;
    }
    
    return _imageViewQRCode;
}

- (UIImageView *)imageViewQRCodeColour {
    if (!_imageViewQRCodeColour) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat side = 200;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((screenSize.width - side) / 2.0, CGRectGetMaxY(_imageViewQRCode.frame) + 10, side, side)];
        imageView.layer.borderColor = [UIColor redColor].CGColor;
        imageView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        
        _imageViewQRCodeColour = imageView;
    }
    
    return _imageViewQRCodeColour;
}

#pragma mark - Action

- (void)viewTapped:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    if (tappedView == self.view) {
        [self.textView endEditing:YES];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.imageViewQRCode.image = [WCCoreImageTool QRImageWithString:textView.text size:self.imageViewQRCode.bounds.size tintColor:nil];
    
    UIColor *tintColor = [UIColor colorWithRed:0.93 green:0.31 blue:0.23 alpha:0.8];
    self.imageViewQRCodeColour.image = [WCCoreImageTool QRImageWithString:textView.text size:self.imageViewQRCodeColour.bounds.size tintColor:tintColor];
}

@end
