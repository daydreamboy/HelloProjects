//
//  AddBorderToImageViewController.m
//  HelloUIView
//
//  Created by wesley_chen on 29/03/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "AddBorderToImageViewController.h"

// @see https://stackoverflow.com/a/40824055
@interface UIImage (Border)
- (UIImage *)imageWithBorderColor:(UIColor *)borderColor borderScale:(CGFloat)borderScale;
@end

@implementation UIImage (Border)
- (UIImage *)imageWithBorderColor:(UIColor *)borderColor borderScale:(CGFloat)borderScale {
    CGFloat scale = 1.0 - borderScale;
    
    UIImage *backgroundImage = [self imageWithTemplateColor:borderColor];
    UIImage *smallerImage = [self imageWithScale:scale];
    
    UIGraphicsBeginImageContext(backgroundImage.size);
    
    [backgroundImage drawAtPoint:CGPointZero];
    [smallerImage drawAtPoint:CGPointMake((backgroundImage.size.width - smallerImage.size.width) / 2.0, (backgroundImage.size.height - smallerImage.size.height) / 2.0)];
    
    UIImage *borderedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return borderedImage;
}

- (UIImage *)imageWithTemplateColor:(UIColor *)templateColor {
    UIGraphicsBeginImageContext(self.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    CGContextClipToMask(context, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
    
    [templateColor setFill];
    CGContextFillRect(context, CGRectMake(0, 0, self.size.width, self.size.height));
    
    UIImage *templateImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return templateImage;
}

- (UIImage *)imageWithScale:(CGFloat)scale {
    CGFloat width = scale * self.size.width;
    CGFloat height = scale * self.size.height;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}
@end

@interface AddBorderToImageViewController ()
@property (nonatomic, strong) UIImageView *imageViewLeft;
@property (nonatomic, strong) UIImageView *imageViewRight;
@end

@implementation AddBorderToImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.imageViewLeft];
    [self.view addSubview:self.imageViewRight];
}

#pragma mark - Getters

- (UIImageView *)imageViewLeft {
    if (!_imageViewLeft) {
        UIImage *image = [UIImage imageNamed:@"aliwx_card_bubble_left_bg"];
        CGSize imageSize = image.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 64 + 10, imageSize.width, imageSize.height)];
        imageView.image = [image imageWithBorderColor:[UIColor orangeColor] borderScale:0.1];
        
        _imageViewLeft = imageView;
    }
    
    return _imageViewLeft;
}

- (UIImageView *)imageViewRight {
    if (!_imageViewRight) {
        UIImage *image = [UIImage imageNamed:@"aliwx_card_bubble_right_bg"];
        CGSize imageSize = image.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.imageViewLeft.frame) + 20, imageSize.width, imageSize.height)];
        imageView.image = [image imageWithBorderColor:[UIColor redColor] borderScale:0.1];;
        
        _imageViewRight = imageView;
    }
    
    return _imageViewRight;
}

@end
