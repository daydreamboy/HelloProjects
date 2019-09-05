//
//  LayerFrameIssueOniOS13ViewController.m
//  HelloUIImageView
//
//  Created by wesley_chen on 2019/9/5.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "LayerFrameIssueOniOS13ViewController.h"
#import <AVFoundation/AVFoundation.h>

/**
 macro for [UIImage imageNamed:@"xxx"]

 @param imageName the name of image
 @param resource_bundle the resource bundle (with .bundle) containes image. @"" is for main bundle
 @return the UIImage object
 */
#define UIImageInResourceBundle(imageName, resource_bundle)  ([UIImage imageNamed:[(resource_bundle) stringByAppendingPathComponent:(imageName)]])

@interface LayerFrameIssueOniOS13ViewController ()
@property (nonatomic, strong) UIImageView *imageView1Issued;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *imageView1Fixed;
@end

@implementation LayerFrameIssueOniOS13ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageView1Issued];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    // ISSUE: set layer frame instead of set view frame will cause UIImageView's image not show on iOS 13+
    self.imageView1Issued.layer.frame = CGRectMake((screenSize.width - 200) / 2.0, 10, 200, 200);
    
    [self.view addSubview:self.imageView2];
    
    [self.view addSubview:self.imageView1Fixed];
    // Note: Ok
    self.imageView1Fixed.layer.frame = CGRectMake((screenSize.width - 200) / 2.0, CGRectGetMaxY(self.imageView2.frame) + 10, 200, 200);
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

- (UIImageView *)imageView2 {
    if (!_imageView2) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UIImage *image = UIImageInResourceBundle(@"walnuts@2x.png", @"");
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((screenSize.width - 200) / 2.0, CGRectGetMaxY(self.imageView1Issued.frame) + 10, 200, 200)];
        imageView.layer.borderColor = [UIColor redColor].CGColor;
        imageView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        imageView.image = image;
        
        _imageView2 = imageView;
    }
    
    return _imageView2;
}

- (UIImageView *)imageView1Fixed {
    if (!_imageView1Fixed) {
        UIImage *image = UIImageInResourceBundle(@"walnuts@2x.png", @"");
        
        // Note: initialize or set frame of UIImageView with a temparory non-zero frame on iOS 13+
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        imageView.layer.borderColor = [UIColor redColor].CGColor;
        imageView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        imageView.image = image;
        // FIXED: imageView.frame = <temparory non-zero frame>
        
        _imageView1Fixed = imageView;
    }
    
    return _imageView1Fixed;
}

@end
