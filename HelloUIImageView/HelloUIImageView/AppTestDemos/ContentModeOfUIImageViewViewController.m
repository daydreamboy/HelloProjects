//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "ContentModeOfUIImageViewViewController.h"
#import <AVFoundation/AVFoundation.h>

/**
 macro for [UIImage imageNamed:@"xxx"]

 @param imageName the name of image
 @param resource_bundle the resource bundle (with .bundle) containes image. @"" is for main bundle
 @return the UIImage object
 */
#define UIImageInResourceBundle(imageName, resource_bundle)  ([UIImage imageNamed:[(resource_bundle) stringByAppendingPathComponent:(imageName)]])

@interface ContentModeOfUIImageViewViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation ContentModeOfUIImageViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.imageView];
}

#pragma mark - Getters

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        scrollView.contentSize = CGSizeMake(screenSize.width, screenSize.height * 3);
        _scrollView = scrollView;
    }
    
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UIImage *image = UIImageInResourceBundle(@"walnuts@2x.png", @"");
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((screenSize.width - 200) / 2.0, 10, 200, 200)];
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        CGRect imageAspectRect = AVMakeRectWithAspectRatioInsideRect(image.size, imageView.bounds);
        NSLog(@"imageAspectRect = %@, imageView =%@",NSStringFromCGRect(imageAspectRect),NSStringFromCGRect(imageView.frame));
        
        [self addOverlayToView:imageView];
        
        _imageView = imageView;
    }
    
    return _imageView;
}

#pragma mark - Utility Methods

- (void)addOverlayToView:(UIView *)view {
    UIView *overlay = [[UIView alloc] initWithFrame:view.bounds];
    overlay.layer.borderColor = [UIColor redColor].CGColor;
    overlay.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    overlay.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
    [view addSubview:overlay];
}
@end
