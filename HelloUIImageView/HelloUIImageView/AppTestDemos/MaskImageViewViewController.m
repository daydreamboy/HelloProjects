//
//  MaskImageViewViewController.m
//  AppTest
//
//  Created by wesley_chen on 2018/5/4.
//

#import "MaskImageViewViewController.h"
#import "WCImageViewTool.h"

@interface MaskImageViewViewController ()
@property (nonatomic, strong) UIImageView *imageViewNoStretch;
@property (nonatomic, strong) UIImageView *imageViewStretch;
@end

@implementation MaskImageViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageViewNoStretch];
    [self.view addSubview:self.imageViewStretch];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGRect rect = self.imageViewStretch.bounds;
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.imageViewStretch.layer renderInContext:context];
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    NSLog(@"%@", image);
    
    UIGraphicsEndImageContext();
}

#pragma mark - Getters

- (UIImageView *)imageViewNoStretch {
    if (!_imageViewNoStretch) {
        UIImage *contentImage = [UIImage imageNamed:@"coupon"];
        UIImage *maskImage = [UIImage imageNamed:@"mask.png"];
        CGSize maskImageSize = maskImage.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 64 + 10, maskImageSize.width, maskImageSize.height)];
        [WCImageViewTool setImageView:imageView maskImage:maskImage contentImage:contentImage capInsets:UIEdgeInsetsZero];

        _imageViewNoStretch = imageView;
    }
    
    return _imageViewNoStretch;
}

- (UIImageView *)imageViewStretch {
    if (!_imageViewStretch) {
        UIImage *contentImage = [UIImage imageNamed:@"coupon"];
        UIImage *maskImage = [UIImage imageNamed:@"mask.png"];
        
        CGSize imageViewSize = CGSizeMake(300, 100);//CGSizeMake(200, 80);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 64 + 100, imageViewSize.width, imageViewSize.height)];
        [WCImageViewTool setImageView:imageView maskImage:maskImage contentImage:contentImage capInsets:UIEdgeInsetsMake(maskImage.size.height / 2.0 - 0.5, maskImage.size.width / 2.0 - 0.5, maskImage.size.height / 2.0 + 0.5, maskImage.size.width / 2.0 + 0.5)];
        
        _imageViewStretch = imageView;
    }
    
    return _imageViewStretch;
}


@end
