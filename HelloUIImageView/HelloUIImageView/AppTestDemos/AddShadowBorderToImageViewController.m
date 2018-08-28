//
//  AddShadowBorderToImageViewController.m
//  HelloUIView
//
//  Created by wesley_chen on 28/03/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "AddShadowBorderToImageViewController.h"
#import "WCImageViewTool.h"

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
        [WCImageViewTool setImageView:imageView shadowBorderColor:[UIColor orangeColor] shadowBorderWidth:5];
        
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
        [WCImageViewTool setImageView:imageView shadowBorderColor:[UIColor redColor] shadowBorderWidth:1];
        
        _imageViewRight = imageView;
    }
    
    return _imageViewRight;
}

@end
