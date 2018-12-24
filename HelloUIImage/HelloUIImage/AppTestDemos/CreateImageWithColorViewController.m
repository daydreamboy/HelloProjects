//
//  CreateImageWithColorViewController.m
//  HelloUIImage
//
//  Created by wesley_chen on 2018/12/24.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "CreateImageWithColorViewController.h"
#import "WCImageTool.h"

@interface CreateImageWithColorViewController ()
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *imageView3;
@end

@implementation CreateImageWithColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageView1];
    [self.view addSubview:self.imageView2];
    [self.view addSubview:self.imageView3];
}

#pragma mark - Getters

- (UIImageView *)imageView1 {
    if (!_imageView1) {
        CGSize size = CGSizeMake(100, 100);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 80, size.width, size.height)];
        imageView.image = [WCImageTool imageWithColor:[UIColor redColor] size:CGSizeMake(size.width, size.height)];
        _imageView1 = imageView;
    }
    
    return _imageView1;
}

- (UIImageView *)imageView2 {
    if (!_imageView2) {
        CGSize size = CGSizeMake(100, 100);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.imageView1.frame) + 10, size.width, size.height)];
        imageView.image = [WCImageTool imageWithColor:[UIColor redColor] size:CGSizeMake(size.width, size.height) cornerRadius:size.width / 2.0];
        _imageView2 = imageView;
    }
    
    return _imageView2;
}

- (UIImageView *)imageView3 {
    if (!_imageView3) {
        CGSize size = CGSizeMake(100, 100);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.imageView2.frame) + 10, size.width, size.height)];
        imageView.image = [WCImageTool imageWithColor:[UIColor redColor] size:CGSizeMake(size.width, size.height) cornerRadius:5];
        _imageView3 = imageView;
    }
    
    return _imageView3;
}


@end
