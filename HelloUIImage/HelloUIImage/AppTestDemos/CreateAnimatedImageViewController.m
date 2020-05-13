//
//  CreateAnimatedImageViewController.m
//  HelloUIImage
//
//  Created by wesley_chen on 2020/5/13.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "CreateAnimatedImageViewController.h"
#import "WCImageTool.h"

@interface CreateAnimatedImageViewController ()
@property (nonatomic, strong) UIImageView *imageViewStatic;
@property (nonatomic, strong) UIImageView *imageViewGIFInfinityLoop;
@property (nonatomic, strong) UIImageView *imageViewGIFVariableFrameDuration;
@end

@implementation CreateAnimatedImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageViewStatic];
    [self.view addSubview:self.imageViewGIFInfinityLoop];
    [self.view addSubview:self.imageViewGIFVariableFrameDuration];
}

#pragma mark - Getters

- (UIImageView *)imageViewStatic {
    if (!_imageViewStatic) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"13" ofType:@"png"];
        NSError *error;
        NSData *data = [NSData dataWithContentsOfFile:filePath options:kNilOptions error:&error];
        UIImage *image = [WCImageTool animatedImageWithData:data];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, image.size.width, image.size.height)];
        imageView.image = image;
        
        NSLog(@"%@ duration: %f", image, image.duration);
        
        _imageViewStatic = imageView;
    }
    
    return _imageViewStatic;
}

- (UIImageView *)imageViewGIFInfinityLoop {
    if (!_imageViewGIFInfinityLoop) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"infinityLoop" ofType:@"gif"];
        NSError *error;
        NSData *data = [NSData dataWithContentsOfFile:filePath options:kNilOptions error:&error];
        UIImage *image = [WCImageTool animatedImageWithData:data];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_imageViewStatic.frame) + 20, image.size.width, image.size.height)];
        imageView.image = image;
        
        NSLog(@"%@ duration: %f", image, image.duration);
        
        _imageViewGIFInfinityLoop = imageView;
    }
    
    return _imageViewGIFInfinityLoop;
}

- (UIImageView *)imageViewGIFVariableFrameDuration {
    if (!_imageViewGIFVariableFrameDuration) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"variableDuration" ofType:@"gif"];
        NSError *error;
        NSData *data = [NSData dataWithContentsOfFile:filePath options:kNilOptions error:&error];
        UIImage *image = [WCImageTool animatedImageWithData:data];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_imageViewGIFInfinityLoop.frame) + 20, image.size.width, image.size.height)];
        imageView.image = image;
        
        NSLog(@"%@ duration: %f", image, image.duration);
        
        _imageViewGIFVariableFrameDuration = imageView;
    }
    
    return _imageViewGIFVariableFrameDuration;
}

@end
