//
//  MisuseUIImageWithYYAnimatedViewViewController.m
//  HelloYYKit
//
//  Created by wesley_chen on 2020/11/13.
//

#import "MisuseUIImageWithYYAnimatedViewViewController.h"
#import "YYKit.h"

@interface MisuseUIImageWithYYAnimatedViewViewController ()
@property (nonatomic, strong) YYAnimatedImageView *imageViewWrong;
@property (nonatomic, strong) YYAnimatedImageView *imageViewCorrect;
@end

@implementation MisuseUIImageWithYYAnimatedViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageViewWrong];
    [self.view addSubview:self.imageViewCorrect];
}

#pragma mark - Getter

- (YYAnimatedImageView *)imageViewWrong {
    if (!_imageViewWrong) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIImage *image = [UIImage imageNamed:@"cube@2x.png"];
        
        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
        imageView.center = CGPointMake(screenSize.width / 2.0, 200);
        imageView.layer.borderColor = [UIColor redColor].CGColor;
        imageView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        
        _imageViewWrong = imageView;
    }
    
    return _imageViewWrong;
}

- (YYAnimatedImageView *)imageViewCorrect {
    if (!_imageViewCorrect) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        YYImage *yyImage = [YYImage imageNamed:@"cube@2x.png"];
        
        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:yyImage];
        imageView.center = CGPointMake(screenSize.width / 2.0, 400);
        imageView.layer.borderColor = [UIColor redColor].CGColor;
        imageView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        
        _imageViewCorrect = imageView;
    }
    
    return _imageViewCorrect;
}

@end
