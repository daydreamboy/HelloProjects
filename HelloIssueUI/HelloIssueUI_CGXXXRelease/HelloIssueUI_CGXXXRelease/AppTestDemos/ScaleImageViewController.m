//
//  ScaleImageViewController.m
//  AppTest
//
//  Created by wesley_chen on 2018/5/6.
//

#import "ScaleImageViewController.h"
#import "WCImageTool.h"

@interface ScaleImageViewController ()
@property (nonatomic, strong) UIImageView *imageViewOriginal;
@property (nonatomic, strong) UIImageView *imageViewScaledToSmaller;
@property (nonatomic, strong) UIImageView *imageViewScaledToBigger;
@end

@implementation ScaleImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageViewOriginal];
    [self.view addSubview:self.imageViewScaledToSmaller];
    //[self.view addSubview:self.imageViewScaledToBigger];
}

#pragma mark - Getters

- (UIImageView *)imageViewOriginal {
    if (!_imageViewOriginal) {
        UIImage *image = [UIImage imageNamed:@"10"];
        CGSize imageSize = image.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, imageSize.width, imageSize.height)];
        imageView.image = image;
        
        _imageViewOriginal = imageView;
    }
    
    return _imageViewOriginal;
}

- (UIImageView *)imageViewScaledToSmaller {
    if (!_imageViewScaledToSmaller) {
        UIImage *image = [UIImage imageNamed:@"10"];
        CGSize imageSize = image.size;
        
        image = [WCImageTool imageWithImage:image scaledToSize:CGSizeMake(imageSize.width / 2, imageSize.height / 2)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_imageViewOriginal.frame) + 5, image.size.width, image.size.height)];
        imageView.image = image;
        
        _imageViewScaledToSmaller = imageView;
    }
    
    return _imageViewScaledToSmaller;
}

- (UIImageView *)imageViewScaledToBigger {
    if (!_imageViewScaledToBigger) {
        UIImage *image = [UIImage imageNamed:@"10"];
        CGSize imageSize = image.size;
        image = [WCImageTool imageWithImage:image scaledToSize:CGSizeMake(imageSize.width * 2, imageSize.height * 2)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_imageViewScaledToSmaller.frame) + 5, image.size.width, image.size.height)];
        imageView.image = image;
        
        _imageViewScaledToBigger = imageView;
    }
    
    return _imageViewScaledToBigger;
}

@end
