//
//  DragDownPresentedViewController.m
//  HelloUIViewControllerTransitioningDelegate
//
//  Created by wesley_chen on 2020/10/15.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import "DragDownPresentedViewController.h"

@interface DragDownPresentedViewController ()
@property (nonatomic, strong, readwrite) UIImageView *imageView;
@end

@implementation DragDownPresentedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.imageView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - Getters

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImage *image = [UIImage imageNamed:@"Xcode"];
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat side = screenSize.width;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, side, side)];
        imageView.image = image;
        imageView.center = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0);
        
        _imageView = imageView;
    }
    
    return _imageView;
}

#pragma mark - Action

- (void)viewTapped:(UITapGestureRecognizer *)recognizer {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
