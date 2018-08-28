//
//  RoundedImageInUIImageViewViewController.m
//  HelloUIImageView
//
//  Created by wesley_chen on 2018/8/26.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "RoundedImageInUIImageViewViewController.h"
#import "WCImageTool.h"

@interface RoundedImageInUIImageViewViewController ()
@property (nonatomic, strong) UIImageView *imageViewWithCornerScaled;
@property (nonatomic, strong) UIImageView *imageViewWithCorneredImageScaled;

@property (nonatomic, strong) UIImageView *imageViewWithCorner;
@property (nonatomic, strong) UIImageView *imageViewWithCorneredImage;

@end

@implementation RoundedImageInUIImageViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageViewWithCornerScaled];
    [self.view addSubview:self.imageViewWithCorneredImageScaled];
    
    [self.view addSubview:self.imageViewWithCorner];
    [self.view addSubview:self.imageViewWithCorneredImage];
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
//    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - Getters

- (UIImageView *)imageViewWithCornerScaled {
    if (!_imageViewWithCornerScaled) {
        UIImage *image = [UIImage imageNamed:@"flower.jpg"];
        CGSize imageSize = CGSizeMake(200, 100);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, imageSize.width, imageSize.height)];
        imageView.layer.cornerRadius = 30;
        imageView.layer.masksToBounds = YES;
        imageView.image = image;
        
        _imageViewWithCornerScaled = imageView;
    }
    
    return _imageViewWithCornerScaled;
}

- (UIImageView *)imageViewWithCorneredImageScaled {
    if (!_imageViewWithCorneredImageScaled) {
        UIImage *image = [UIImage imageNamed:@"flower.jpg"];
        CGSize imageSize = CGSizeMake(200, 100);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.imageViewWithCornerScaled.frame) + 10, imageSize.width, imageSize.height)];
        imageView.image = [WCImageTool roundCorneredImageWithImage:image radius:30 size:imageSize];
        
        _imageViewWithCorneredImageScaled = imageView;
    }
    
    return _imageViewWithCorneredImageScaled;
}

- (UIImageView *)imageViewWithCorner {
    if (!_imageViewWithCorner) {
        UIImage *image = [UIImage imageNamed:@"flower.jpg"];
        CGSize imageSize = image.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.imageViewWithCorneredImageScaled.frame) + 10, imageSize.width, imageSize.height)];
        imageView.layer.cornerRadius = 30;
        imageView.layer.masksToBounds = YES;
        imageView.image = image;
        
        _imageViewWithCorner = imageView;
    }
    
    return _imageViewWithCorner;
}

- (UIImageView *)imageViewWithCorneredImage {
    if (!_imageViewWithCorneredImage) {
        UIImage *image = [UIImage imageNamed:@"flower.jpg"];
        CGSize imageSize = image.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.imageViewWithCorner.frame) + 10, imageSize.width, imageSize.height)];
        imageView.image = [WCImageTool roundCorneredImageWithImage:image radius:30];
        
        _imageViewWithCorneredImage = imageView;
    }
    
    return _imageViewWithCorneredImage;
}

#pragma mark - Actions

- (void)viewTapped:(id)sender {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

@end
