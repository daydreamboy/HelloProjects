//
//  BlurAnyViewViewController.m
//  HelloUIView
//
//  Created by wesley_chen on 2018/8/24.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "BlurAnyViewViewController.h"
#import "WCViewTool.h"

/**
 macro for [UIImage imageNamed:@"xxx"]

 @param imageName the name of image
 @param resource_bundle the resource bundle (with .bundle) containes image. @"" is for main bundle
 @return the UIImage object
 */
#define UIImageInResourceBundle(imageName, resource_bundle)  ([UIImage imageNamed:[(resource_bundle) stringByAppendingPathComponent:(imageName)]])


@interface BlurAnyViewViewController ()
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *imageView3;
@end

@implementation BlurAnyViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.imageView1];
    [self.view addSubview:self.imageView2];
    [self.view addSubview:self.imageView3];
    
    [WCViewTool blurWithView:self.imageView1 style:UIBlurEffectStyleExtraLight];
    [WCViewTool blurWithView:self.imageView2 style:UIBlurEffectStyleLight];
    [WCViewTool blurWithView:self.imageView3 style:UIBlurEffectStyleDark];
}

#pragma mark - Getters

- (UIImageView *)imageView1 {
    if (!_imageView1) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 80, 166, 150)];
        imageView.image = UIImageInResourceBundle(@"dog.jpg", @"");
        
        _imageView1 = imageView;
    }
    
    return _imageView1;
}

- (UIImageView *)imageView2 {
    if (!_imageView2) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.imageView1.frame) + 10, 166, 150)];
        imageView.image = UIImageInResourceBundle(@"dog.jpg", @"");
        
        _imageView2 = imageView;
    }
    
    return _imageView2;
}

- (UIImageView *)imageView3 {
    if (!_imageView3) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.imageView2.frame) + 10, 166, 150)];
        imageView.image = UIImageInResourceBundle(@"dog.jpg", @"");
        
        _imageView3 = imageView;
    }
    
    return _imageView3;
}

@end
