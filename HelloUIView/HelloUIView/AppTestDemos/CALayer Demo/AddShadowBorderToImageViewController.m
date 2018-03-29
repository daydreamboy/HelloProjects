//
//  AddShadowBorderToImageViewController.m
//  HelloUIView
//
//  Created by wesley_chen on 28/03/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "AddShadowBorderToImageViewController.h"

// @sa UIImageView+Addition.m
@interface UIImageView (ShadowBorder)
- (void)addShadowBorderWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;
@end

@implementation UIImageView (ShadowBorder)

- (void)addShadowBorderWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    
    if (!self.image) {
        NSLog(@"%@'s image is nil", self);
        return;
    }
    
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    imageLayer.contents = (id)self.image.CGImage;
    imageLayer.position = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    //
    imageLayer.shadowColor = [UIColor redColor].CGColor;
    imageLayer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    imageLayer.shadowOpacity = 1.0f;
    //        imageLayer.borderWidth = 1.0;
    imageLayer.shadowRadius = 2.0f;
    
    [self.layer addSublayer:imageLayer];
}

@end

@interface AddShadowBorderToImageViewController ()
@property (nonatomic, strong) UIImageView *imageViewLeft;
@property (nonatomic, strong) UIImageView *imageViewRight;
@end

@implementation AddShadowBorderToImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageViewLeft];
    [self.view addSubview:self.imageViewRight];
}

#pragma mark - Getters

- (UIImageView *)imageViewLeft {
    if (!_imageViewLeft) {
        UIImage *image = [UIImage imageNamed:@"aliwx_card_bubble_left_bg"];
        CGSize imageSize = image.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 64 + 10, imageSize.width, imageSize.height)];
        imageView.image = image;
        [imageView addShadowBorderWithBorderColor:[UIColor orangeColor] borderWidth:1];
        
        _imageViewLeft = imageView;
    }
    
    return _imageViewLeft;
}

- (UIImageView *)imageViewRight {
    if (!_imageViewRight) {
        UIImage *image = [UIImage imageNamed:@"aliwx_card_bubble_right_bg"];
        CGSize imageSize = image.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.imageViewLeft.frame) + 20, imageSize.width, imageSize.height)];
        imageView.image = image;
        [imageView addShadowBorderWithBorderColor:[UIColor redColor] borderWidth:1];
        
        _imageViewRight = imageView;
    }
    
    return _imageViewRight;
}

@end
