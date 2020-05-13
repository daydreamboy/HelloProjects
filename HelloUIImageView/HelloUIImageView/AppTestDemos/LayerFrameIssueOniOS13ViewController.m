//
//  LayerFrameIssueOniOS13ViewController.m
//  HelloUIImageView
//
//  Created by wesley_chen on 2019/9/5.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "LayerFrameIssueOniOS13ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WCMacroTool.h"

@interface LayerFrameIssueOniOS13ViewController ()
@property (nonatomic, strong) UIImageView *imageView1Issued;
@property (nonatomic, strong) UIImageView *imageView2Normal;
@property (nonatomic, strong) UIImageView *imageView3Fixed;
@end

@implementation LayerFrameIssueOniOS13ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageView1Issued];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    // ISSUE: set layer frame instead of set view frame will cause UIImageView's image not show on iOS 13+
    self.imageView1Issued.layer.frame = CGRectMake((screenSize.width - 200) / 2.0, 10, 200, 200);
    
    [self.view addSubview:self.imageView2Normal];
    
    [self.view addSubview:self.imageView3Fixed];
    // Note: Ok
    self.imageView3Fixed.layer.frame = CGRectMake((screenSize.width - 200) / 2.0, CGRectGetMaxY(self.imageView2Normal.frame) + 10, 200, 200);
}

#pragma mark - Getters

- (UIImageView *)imageView1Issued {
    if (!_imageView1Issued) {
        UIImage *image = UIImageInResourceBundle(@"walnuts@2x.png", @"");
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.layer.borderColor = [UIColor redColor].CGColor;
        imageView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        imageView.image = image;
        
        _imageView1Issued = imageView;
    }
    
    return _imageView1Issued;
}

- (UIImageView *)imageView2Normal {
    if (!_imageView2Normal) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UIImage *image = UIImageInResourceBundle(@"walnuts@2x.png", @"");
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((screenSize.width - 200) / 2.0, CGRectGetMaxY(self.imageView1Issued.frame) + 10, 200, 200)];
        imageView.layer.borderColor = [UIColor redColor].CGColor;
        imageView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        imageView.image = image;
        
        _imageView2Normal = imageView;
    }
    
    return _imageView2Normal;
}

- (UIImageView *)imageView3Fixed {
    if (!_imageView3Fixed) {
        UIImage *image = UIImageInResourceBundle(@"walnuts@2x.png", @"");
        
        // Note: initialize or set frame of UIImageView with a temparory non-zero frame on iOS 13+
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        imageView.layer.borderColor = [UIColor redColor].CGColor;
        imageView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        imageView.image = image;
        // FIXED: imageView.frame = <temparory non-zero frame>
        
        _imageView3Fixed = imageView;
    }
    
    return _imageView3Fixed;
}

@end
