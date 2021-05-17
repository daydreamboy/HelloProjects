//
//  UseBuiltinFilterViewController.m
//  HelloCoreImage
//
//  Created by wesley_chen on 2021/5/16.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "UseBuiltinFilterViewController.h"

#define SpaceV 10

@interface UseBuiltinFilterViewController ()
@property (nonatomic, strong) UIImageView *imageViewOriginal;
@property (nonatomic, strong) UIImageView *imageViewSepia;
@property (nonatomic, strong) UIImageView *imageViewSepiaBloom;
@property (nonatomic, strong) UIImageView *imageViewSepiaBloomScaled;
@end

@implementation UseBuiltinFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.imageViewOriginal];
    [self.contentView addSubview:self.imageViewSepia];
    [self.contentView addSubview:self.imageViewSepiaBloom];
    [self.contentView addSubview:self.imageViewSepiaBloomScaled];
}

#pragma mark - Getter

- (UIImageView *)imageViewOriginal {
    if (!_imageViewOriginal) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UIImage *image = [UIImage imageNamed:@"sky.jpeg"];
        CGSize imageSize = image.size;
        
        imageSize = CGSizeMake(imageSize.width / 3.0, imageSize.height / 3.0);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((screenSize.width - imageSize.width) / 2.0, 0, imageSize.width, imageSize.height)];
        imageView.layer.borderColor = [UIColor redColor].CGColor;
        imageView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        
        CIImage *originalCIImage = [CIImage imageWithCGImage:image.CGImage];
        imageView.image = [UIImage imageWithCIImage:originalCIImage];
        
        _imageViewOriginal = imageView;
    }
    
    return _imageViewOriginal;
}

- (UIImageView *)imageViewSepia {
    if (!_imageViewSepia) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UIImage *image = [UIImage imageNamed:@"sky.jpeg"];
        CGSize imageSize = image.size;
        
        imageSize = CGSizeMake(imageSize.width / 3.0, imageSize.height / 3.0);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((screenSize.width - imageSize.width) / 2.0, CGRectGetMaxY(_imageViewOriginal.frame) + SpaceV, imageSize.width, imageSize.height)];
        imageView.layer.borderColor = [UIColor redColor].CGColor;
        imageView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        
        CIImage *originalCIImage = [CIImage imageWithCGImage:image.CGImage];
        CIImage *sepiaCIImage = [self sepiaFilterImage:originalCIImage withIntensity:0.9];
        imageView.image = [UIImage imageWithCIImage:sepiaCIImage];
        
        _imageViewSepia = imageView;
    }
    
    return _imageViewSepia;
}

- (UIImageView *)imageViewSepiaBloom {
    if (!_imageViewSepiaBloom) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UIImage *image = [UIImage imageNamed:@"sky.jpeg"];
        CGSize imageSize = image.size;
        
        imageSize = CGSizeMake(imageSize.width / 3.0, imageSize.height / 3.0);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((screenSize.width - imageSize.width) / 2.0, CGRectGetMaxY(_imageViewSepia.frame) + SpaceV, imageSize.width, imageSize.height)];
        imageView.layer.borderColor = [UIColor redColor].CGColor;
        imageView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        
        CIImage *originalCIImage = [CIImage imageWithCGImage:image.CGImage];
        CIImage *sepiaCIImage = [self sepiaFilterImage:originalCIImage withIntensity:0.9];
        CIImage *bloomCIImage = [self bloomFilterImage:sepiaCIImage withIntensity:1 radius:10];
        imageView.image = [UIImage imageWithCIImage:bloomCIImage];
        
        _imageViewSepiaBloom = imageView;
    }
    
    return _imageViewSepiaBloom;
}

- (UIImageView *)imageViewSepiaBloomScaled {
    if (!_imageViewSepiaBloomScaled) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UIImage *image = [UIImage imageNamed:@"sky.jpeg"];
        CGSize imageSize = image.size;
        
        imageSize = CGSizeMake(imageSize.width / 3.0, imageSize.height / 3.0);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((screenSize.width - imageSize.width) / 2.0, CGRectGetMaxY(_imageViewSepiaBloom.frame) + SpaceV, imageSize.width, imageSize.height)];
        imageView.layer.borderColor = [UIColor redColor].CGColor;
        imageView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        
        CIImage *originalCIImage = [CIImage imageWithCGImage:image.CGImage];
        CIImage *sepiaCIImage = [self sepiaFilterImage:originalCIImage withIntensity:0.9];
        CIImage *bloomCIImage = [self bloomFilterImage:sepiaCIImage withIntensity:1 radius:10];
        CGFloat imageWidth = image.size.width;
        CGFloat imageHeight = image.size.height;
        CGFloat aspectRatio = imageHeight / imageWidth;
        CIImage *scaledCIImage = [self scaleFilterImage:bloomCIImage withAspectRatio:aspectRatio scale:0.05];
        imageView.image = [UIImage imageWithCIImage:scaledCIImage];
        
        _imageViewSepiaBloomScaled = imageView;
    }
    
    return _imageViewSepiaBloomScaled;
}

#pragma mark - Filter

- (CIImage *)sepiaFilterImage:(CIImage *)inputImage withIntensity:(CGFloat)intensity {
    CIFilter* sepiaFilter = [CIFilter filterWithName:@"CISepiaTone"];
    [sepiaFilter setValue:inputImage forKey:kCIInputImageKey];
    [sepiaFilter setValue:@(intensity) forKey:kCIInputIntensityKey];
    return sepiaFilter.outputImage;
}

- (CIImage *)bloomFilterImage:(CIImage*)inputImage withIntensity:(CGFloat)intensity radius:(CGFloat)radius {
    CIFilter* bloomFilter = [CIFilter filterWithName:@"CIBloom"];
    [bloomFilter setValue:inputImage forKey:kCIInputImageKey];
    [bloomFilter setValue:@(intensity) forKey:kCIInputIntensityKey];
    [bloomFilter setValue:@(radius) forKey:kCIInputRadiusKey];
    return bloomFilter.outputImage;
}

- (CIImage *)scaleFilterImage:(CIImage *)inputImage withAspectRatio:(CGFloat)aspectRatio scale:(CGFloat)scale {
    CIFilter* scaleFilter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
    [scaleFilter setValue:inputImage forKey:kCIInputImageKey];
    [scaleFilter setValue:@(scale) forKey:kCIInputScaleKey];
    [scaleFilter setValue:@(aspectRatio) forKey:kCIInputAspectRatioKey];
    return scaleFilter.outputImage;
}

@end
