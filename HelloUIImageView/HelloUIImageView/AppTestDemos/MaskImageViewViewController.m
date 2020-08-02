//
//  MaskImageViewViewController.m
//  AppTest
//
//  Created by wesley_chen on 2018/5/4.
//

#import "MaskImageViewViewController.h"
#import "WCImageViewTool.h"

@interface MaskImageViewViewController ()
@property (nonatomic, strong) UIImageView *demo1MaskingWithImageByRedraw;
@property (nonatomic, strong) UIImageView *demo2MaskingWithResizableImageByRedraw;

@property (nonatomic, strong) UIImageView *demo3MaskingWithImageByLayer;
@property (nonatomic, strong) UIImageView *demo4MaskingWithResizaleImageByLayer;

@property (nonatomic, strong) UIImageView *demo5MaskingWithTextLayer;

@end

@implementation MaskImageViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.demo1MaskingWithImageByRedraw];
    [self.contentView addSubview:self.demo2MaskingWithResizableImageByRedraw];
    [self.contentView addSubview:self.demo3MaskingWithImageByLayer];
    [self.contentView addSubview:self.demo4MaskingWithResizaleImageByLayer];
    [self.contentView addSubview:self.demo5MaskingWithTextLayer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGRect rect = self.demo2MaskingWithResizableImageByRedraw.bounds;
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.demo2MaskingWithResizableImageByRedraw.layer renderInContext:context];
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    NSLog(@"%@", image);
    
    UIGraphicsEndImageContext();
}

#pragma mark - Getters

- (UIImageView *)demo1MaskingWithImageByRedraw {
    if (!_demo1MaskingWithImageByRedraw) {
        UIImage *contentImage = [UIImage imageNamed:@"coupon"];
        UIImage *maskImage = [UIImage imageNamed:@"mask.png"];
        CGSize maskImageSize = maskImage.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, maskImageSize.width, maskImageSize.height)];
        [WCImageViewTool setImageView:imageView maskImage:maskImage contentImage:contentImage capInsets:UIEdgeInsetsZero];

        _demo1MaskingWithImageByRedraw = imageView;
    }
    
    return _demo1MaskingWithImageByRedraw;
}

- (UIImageView *)demo2MaskingWithResizableImageByRedraw {
    if (!_demo2MaskingWithResizableImageByRedraw) {
        UIImage *contentImage = [UIImage imageNamed:@"coupon"];
        UIImage *maskImage = [UIImage imageNamed:@"mask.png"];
        
        CGSize imageViewSize = CGSizeMake(300, 100);//CGSizeMake(200, 80);
        CGRect frame = CGRectMake(10, CGRectGetMaxY(_demo1MaskingWithImageByRedraw.frame) + 10, imageViewSize.width, imageViewSize.height);
        UIEdgeInsets capInsets = UIEdgeInsetsMake(maskImage.size.height / 2.0 - 0.5, maskImage.size.width / 2.0 - 0.5, maskImage.size.height / 2.0 - 0.5, maskImage.size.width / 2.0 - 0.5);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [WCImageViewTool setImageView:imageView maskImage:maskImage contentImage:contentImage capInsets:capInsets];
        
        _demo2MaskingWithResizableImageByRedraw = imageView;
    }
    
    return _demo2MaskingWithResizableImageByRedraw;
}

- (UIImageView *)demo3MaskingWithImageByLayer {
    if (!_demo3MaskingWithImageByLayer) {
        UIImage *contentImage = [UIImage imageNamed:@"cascade_session"];
        UIImage *maskImage = [UIImage imageNamed:@"cascade_session_mask"];
        CGSize maskImageSize = CGSizeMake(48, 48);
        CGRect frame = CGRectMake(10, CGRectGetMaxY(_demo2MaskingWithResizableImageByRedraw.frame) + 10, maskImageSize.width, maskImageSize.height);
        
        UIImageView *imageView = [WCImageViewTool maskedImageViewWithFrame:frame maskImage:maskImage contentImage:contentImage capInsets:UIEdgeInsetsZero];

        _demo3MaskingWithImageByLayer = imageView;
    }
    
    return _demo3MaskingWithImageByLayer;
}

- (UIImageView *)demo4MaskingWithResizaleImageByLayer {
    if (!_demo4MaskingWithResizaleImageByLayer) {
        UIImage *contentImage = [UIImage imageNamed:@"coupon"];
        UIImage *maskImage = [UIImage imageNamed:@"mask.png"];
        
        CGSize imageViewSize = CGSizeMake(300, 100);//CGSizeMake(200, 80);
        CGRect frame = CGRectMake(10, CGRectGetMaxY(_demo3MaskingWithImageByLayer.frame) + 10, imageViewSize.width, imageViewSize.height);
        UIEdgeInsets capInsets = UIEdgeInsetsMake(maskImage.size.height / 2.0 - 0.5, maskImage.size.width / 2.0 - 0.5, maskImage.size.height / 2.0 - 0.5, maskImage.size.width / 2.0 - 0.5);
        
        UIImageView *imageView = [WCImageViewTool maskedImageViewWithFrame:frame maskImage:maskImage contentImage:contentImage capInsets:capInsets];
        
        _demo4MaskingWithResizaleImageByLayer = imageView;
    }
    
    return _demo4MaskingWithResizaleImageByLayer;
}

- (UIImageView *)demo5MaskingWithTextLayer {
    if (!_demo5MaskingWithTextLayer) {
        UIImage *contentImage = [UIImage imageNamed:@"colour_gradient.jpeg"];
        
        CGSize imageViewSize = CGSizeMake(300, 100);//CGSizeMake(200, 80);
        CGRect frame = CGRectMake(10, CGRectGetMaxY(_demo4MaskingWithResizaleImageByLayer.frame) + 10, imageViewSize.width, imageViewSize.height);

        // @see https://littlebitesofcocoa.com/245-masking-views-with-text-using-catextlayer
        CATextLayer *textLayer = [CATextLayer layer];
        
        textLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        textLayer.rasterizationScale = [UIScreen mainScreen].scale;
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.fontSize = 42.0;
        textLayer.font = (__bridge CFTypeRef _Nullable)([UIFont fontWithName:@"TrebuchetMS-Bold" size:42.0]);
        textLayer.wrapped = YES;
        textLayer.truncationMode = kCATruncationEnd;
        textLayer.string = @"Hello, world!";
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = contentImage;
        imageView.layer.mask = textLayer;
        
        _demo5MaskingWithTextLayer = imageView;
    }
    
    return _demo5MaskingWithTextLayer;
}

@end
