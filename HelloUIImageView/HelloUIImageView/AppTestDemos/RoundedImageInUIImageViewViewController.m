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
@end

@implementation RoundedImageInUIImageViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageViewWithCorner];
}

- (UIImageView *)imageViewWithCorner {
    if (!_imageViewWithCorner) {
        UIImage *image = [UIImage imageNamed:@"flower.jpg"];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        imageView.layer.cornerRadius = 30;
        imageView.layer.masksToBounds = YES;
        imageView.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
        imageView.image = image;
        
        _imageViewWithCorner = imageView;
    }
    
    return _imageViewWithCorner;
}

- (UIImage *)roundCorneredImage:(UIImage *)orig radius:(CGFloat) r {
    UIGraphicsBeginImageContextWithOptions(orig.size, NO, 0);
    [[UIBezierPath bezierPathWithRoundedRect:(CGRect){CGPointZero, orig.size}
                                cornerRadius:r] addClip];
    [orig drawInRect:(CGRect){CGPointZero, orig.size}];
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

@end
