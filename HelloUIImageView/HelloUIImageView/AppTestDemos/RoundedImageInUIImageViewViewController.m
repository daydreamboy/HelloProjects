//
//  RoundedImageInUIImageViewViewController.m
//  HelloUIImageView
//
//  Created by wesley_chen on 2018/8/26.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "RoundedImageInUIImageViewViewController.h"

@interface RoundedImageInUIImageViewViewController ()
@property (nonatomic, strong) UIImageView *imageViewWithCorner;
@property (nonatomic, strong) UIImageView *imageViewWithCorneredImage;
@end

@implementation RoundedImageInUIImageViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageViewWithCorner];
    [self.view addSubview:self.imageViewWithCorneredImage];
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
//    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - Getters

- (UIImageView *)imageViewWithCorner {
    if (!_imageViewWithCorner) {
        UIImage *image = [UIImage imageNamed:@"flower.jpg"];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60 + 10, image.size.width, image.size.height)];
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
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.imageViewWithCorner.frame) + 10, image.size.width, image.size.height)];
        imageView.image = [self.class roundCorneredImageWithImage:image radius:30];
        
        _imageViewWithCorneredImage = imageView;
    }
    
    return _imageViewWithCorneredImage;
}

#pragma mark -

+ (UIImage *)roundCorneredImageWithImage:(UIImage *)image radius:(CGFloat)radius {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    [[UIBezierPath bezierPathWithRoundedRect:(CGRect){CGPointZero, image.size} cornerRadius:radius] addClip];
    [image drawInRect:(CGRect){CGPointZero, image.size}];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - Actions

- (void)viewTapped:(id)sender {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

@end
