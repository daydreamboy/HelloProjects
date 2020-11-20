//
//  MisuseUIImageWithYYAnimatedViewViewController.m
//  HelloYYKit
//
//  Created by wesley_chen on 2020/11/13.
//

#import "MisuseUIImageWithYYAnimatedViewViewController.h"
#import "YYKit.h"

@interface MisuseUIImageWithYYAnimatedViewViewController ()
@property (nonatomic, strong) YYAnimatedImageView *imageViewCorrect;
@property (nonatomic, strong) YYAnimatedImageView *imageViewWrong1;
@property (nonatomic, strong) YYAnimatedImageView *imageViewWrong2;
@property (nonatomic, strong) YYAnimatedImageView *imageViewWrong2Fixed;
@end

@implementation MisuseUIImageWithYYAnimatedViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageViewCorrect];
    [self.view addSubview:self.imageViewWrong1];
    [self.view addSubview:self.imageViewWrong2];
    [self.view addSubview:self.imageViewWrong2Fixed];
}

#pragma mark - Getter

- (YYAnimatedImageView *)imageViewCorrect {
    if (!_imageViewCorrect) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        YYImage *yyImage = [YYImage imageNamed:@"cube@2x.png"];
        
        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:yyImage];
        imageView.center = CGPointMake(screenSize.width / 2.0, 200);
        imageView.layer.borderColor = [UIColor greenColor].CGColor;
        imageView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        
        _imageViewCorrect = imageView;
    }
    
    return _imageViewCorrect;
}

- (YYAnimatedImageView *)imageViewWrong1 {
    if (!_imageViewWrong1) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIImage *image = [UIImage imageNamed:@"cube@2x.png"];
        
        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake((screenSize.width - image.size.width) / 2.0, CGRectGetMaxY(_imageViewCorrect.frame) + 10, image.size.width, image.size.height);
        imageView.layer.borderColor = [UIColor redColor].CGColor;
        imageView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        
        _imageViewWrong1 = imageView;
    }
    
    return _imageViewWrong1;
}

- (YYAnimatedImageView *)imageViewWrong2 {
    if (!_imageViewWrong2) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIImage *image1 = [UIImage imageNamed:@"001@2x.png"];
        
        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image1];
        imageView.frame = CGRectMake((screenSize.width - image1.size.width) / 2.0, CGRectGetMaxY(_imageViewWrong1.frame) + 10, image1.size.width, image1.size.height);
        imageView.layer.borderColor = [UIColor redColor].CGColor;
        imageView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        
        _imageViewWrong2 = imageView;
    }
    
    return _imageViewWrong2;
}

- (YYAnimatedImageView *)imageViewWrong2Fixed {
    if (!_imageViewWrong2Fixed) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIImage *image1 = [UIImage imageNamed:@"001@2x.png"];
        
        UIImage *animatedImage = [UIImage animatedImageWithImages:@[image1, image1] duration:0];
        
        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:animatedImage];
        imageView.frame = CGRectMake((screenSize.width - image1.size.width) / 2.0, CGRectGetMaxY(_imageViewWrong2.frame) + 10, image1.size.width, image1.size.height);
        imageView.layer.borderColor = [UIColor greenColor].CGColor;
        imageView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        
        _imageViewWrong2Fixed = imageView;
    }
    
    return _imageViewWrong2Fixed;
}

@end
