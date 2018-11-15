//
//  CropImageViewController.m
//  HelloUIImage
//
//  Created by wesley_chen on 2018/11/14.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "CropImageViewController.h"
#import "WCViewTool.h"
#import "WCImageTool.h"

@interface CropImageViewController ()
@property (nonatomic, strong) UIImageView *imageViewOriginal;
@property (nonatomic, strong) UIImageView *imageViewScaled;
@end

@implementation CropImageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageViewOriginal];
    //[self.view addSubview:self.imageViewScaled];
}

#pragma mark - Getters

- (UIImageView *)imageViewOriginal {
    if (!_imageViewOriginal) {
        UIImage *image = [UIImage imageNamed:@"12.jpg"];
        
        CGSize size = CGSizeMake(120, 150);
        CGSize cropSize = [WCViewTool scaledSizeWithContentSize:size fitToWidth:image.size.width];
        CGRect cropRect = [WCViewTool centeredRectInRectWithSize:cropSize inRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        
        UIImage *croppedImage = [WCImageTool imageWithImage:image croppedToFrame:cropRect scaledToSize:size];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 64 + 10, size.width, size.height)];
        imageView.image = croppedImage;
        
        _imageViewOriginal = imageView;
    }
    
    return _imageViewOriginal;
}

- (UIImageView *)imageViewScaled {
    if (!_imageViewScaled) {
        UIImage *image = [UIImage imageNamed:@"10"];
        CGSize imageSize = image.size;
        image = [WCImageTool imageWithImage:image scaledToSize:CGSizeMake(imageSize.width * 2, imageSize.height * 2)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 300, image.size.width, image.size.height)];
        imageView.image = image;
        
        _imageViewScaled = imageView;
    }
    
    return _imageViewScaled;
}

@end
