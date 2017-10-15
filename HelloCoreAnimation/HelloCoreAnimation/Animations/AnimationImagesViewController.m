//
//  AnimationImagesViewController.m
//  HelloCoreAnimation
//
//  Created by wesley chen on 16/6/6.
//  Copyright © 2016年 wesley_chen. All rights reserved.
//

#import "AnimationImagesViewController.h"

@interface AnimationImagesViewController ()
@property (nonatomic, strong) UIImageView *loadingImageView;
@end

@implementation AnimationImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.loadingImageView];
    [self.loadingImageView startAnimating];
}

- (UIImageView *)loadingImageView {
    if (!_loadingImageView) {
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat width = 33.0f;
        CGFloat height = 7.0f;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((screenSize.width - width) / 2.0 , (screenSize.height - height) / 2.0, width, height)];
        imageView.contentMode = UIViewContentModeCenter;
        UIImage *loading0 = [UIImage imageNamed:@"common_btn_animation_normal"];
        UIImage *loading1 = [UIImage imageNamed:@"common_btn_animation_left"];
        UIImage *loading2 = [UIImage imageNamed:@"common_btn_animation_middle"];
        UIImage *loading3 = [UIImage imageNamed:@"common_btn_animation_right"];
        imageView.animationImages = @[loading1, loading0, loading2, loading0, loading3, loading0];
        imageView.animationDuration = 0.8f;
        
        _loadingImageView = imageView;
    }
    
    return _loadingImageView;
}

@end
