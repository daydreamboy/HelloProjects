//
//  AspectRatioScaledImageViewInsideRectViewController1.m
//  HelloUIImageView
//
//  Created by wesley_chen on 2018/10/12.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "AspectRatioScaledImageViewInsideRectViewController1.h"
#import <AVFoundation/AVFoundation.h>

/**
 macro for [UIImage imageNamed:@"xxx"]
 
 @param imageName the name of image
 @param resource_bundle the resource bundle (with .bundle) containes image. @"" is for main bundle
 @return the UIImage object
 */
#define UIImageInResourceBundle(imageName, resource_bundle)  ([UIImage imageNamed:[(resource_bundle) stringByAppendingPathComponent:(imageName)]])

//#define BoundingSize CGSizeMake(300, 300)
#define BoundingSize CGSizeMake(300, 200)

@interface AspectRatioScaledImageViewInsideRectViewController1 ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *boundingView;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation AspectRatioScaledImageViewInsideRectViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:[self createBoundingViewWithImageName:@"bigger_landscape.png" atY:20]];
    [self.scrollView addSubview:[self createBoundingViewWithImageName:@"bigger_portrait.png" atY:20 + (BoundingSize.height + 10) * 1]];
    [self.scrollView addSubview:[self createBoundingViewWithImageName:@"bigger_squared.png" atY:20 + (BoundingSize.height + 10) * 2]];
    [self.scrollView addSubview:[self createBoundingViewWithImageName:@"smaller_landscape.png" atY:20 + (BoundingSize.height + 10) * 3]];
    [self.scrollView addSubview:[self createBoundingViewWithImageName:@"smaller_portrait.png" atY:20 + (BoundingSize.height + 10) * 4]];
    [self.scrollView addSubview:[self createBoundingViewWithImageName:@"smaller_squared.png" atY:20 + (BoundingSize.height + 10) * 5]];
}

#pragma mark - Getters

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        scrollView.contentSize = CGSizeMake(screenSize.width, screenSize.height * 4);
        _scrollView = scrollView;
    }
    
    return _scrollView;
}

#pragma mark -

- (UIView *)createBoundingViewWithImageName:(NSString *)imageName atY:(CGFloat)y {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake((screenSize.width - BoundingSize.width) / 2.0, y, BoundingSize.width, BoundingSize.height)];
    
    UIImage *image = UIImageInResourceBundle(imageName, @"");
    CGRect aspectScaledRect = AVMakeRectWithAspectRatioInsideRect(image.size, view.bounds);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = aspectScaledRect;
    
    [view addSubview:imageView];
    [self addOverlayToView:view];
    
    return view;
}

#pragma mark - Utility Methods

- (void)addOverlayToView:(UIView *)view {
    UIView *overlay = [[UIView alloc] initWithFrame:view.bounds];
    overlay.layer.borderColor = [UIColor redColor].CGColor;
    overlay.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    overlay.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    [view addSubview:overlay];
}

@end
