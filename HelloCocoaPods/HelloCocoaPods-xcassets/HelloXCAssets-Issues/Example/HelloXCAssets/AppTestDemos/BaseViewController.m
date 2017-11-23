//
//  BaseViewController.m
//  HelloXCAssets_Example
//
//  Created by wesley_chen on 23/11/2017.
//  Copyright © 2017 daydreamboy. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property (nonatomic, assign) CGFloat startY;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.startY = 64;
}

- (void)addImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, self.startY, image.size.width, image.size.height);
    [self.view addSubview:imageView];
    
    self.startY += (CGRectGetHeight(imageView.frame));
}

@end
