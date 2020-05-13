//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "ContentModeOfUIImageViewViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WCMacroTool.h"

@interface ContentModeOfUIImageViewViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray<NSNumber *> *contentModes;
@end

@implementation ContentModeOfUIImageViewViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _contentModes = @[
            @(UIViewContentModeScaleToFill),
            @(UIViewContentModeScaleAspectFit),
            @(UIViewContentModeScaleAspectFill),
            @(UIViewContentModeRedraw),
            @(UIViewContentModeCenter),
            @(UIViewContentModeTop),
            @(UIViewContentModeBottom),
            @(UIViewContentModeLeft),
            @(UIViewContentModeRight),
            @(UIViewContentModeTopLeft),
            @(UIViewContentModeTopRight),
            @(UIViewContentModeBottomLeft),
            @(UIViewContentModeBottomRight),
        ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat side = 400;
    CGFloat startY = 10;
    CGFloat spaceV = 10;
    
    for (NSInteger i = 0; i < self.contentModes.count; ++i) {
        UIViewContentMode contentMode = [self.contentModes[i] integerValue];
        CGRect frame = CGRectMake((screenSize.width - side) / 2.0, startY, side, side);
        
        UIImageView *imageView = [self createImageViewWithContentMode:contentMode frame:frame];
        [self.scrollView addSubview:imageView];
        
        startY += (spaceV + side);
    }

    self.scrollView.contentSize = CGSizeMake(screenSize.width, startY + spaceV);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.scrollView.frame = self.view.bounds;
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

#pragma mark -

- (UIImageView *)createImageViewWithContentMode:(UIViewContentMode)contentMode frame:(CGRect)frame {
    UIImage *image = UIImageInResourceBundle(@"walnuts@2x.png", @"");
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = image;
    imageView.contentMode = contentMode;

    [self addOverlayToView:imageView];
    
    return imageView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UIImage *image = UIImageInResourceBundle(@"walnuts@2x.png", @"");
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((screenSize.width - 400) / 2.0, 10, 400, 400)];
        imageView.image = image;
        imageView.contentMode = UIViewContentModeCenter;//UIViewContentModeScaleAspectFit;
        
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
//    overlay.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
    [view addSubview:overlay];
}
@end
