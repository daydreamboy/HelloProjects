//
//  WCImageViewTool.m
//  AppTest
//
//  Created by wesley_chen on 2018/5/4.
//

#import "WCImageViewTool.h"

@implementation WCImageViewTool

+ (BOOL)setImageView:(UIImageView *)imageView shadowBorderColor:(UIColor *)shadowBorderColor shadowBorderWidth:(CGFloat)shadowBorderWidth {
    if (![imageView isKindOfClass:[UIImageView class]] ||
        ![imageView.image isKindOfClass:[UIImage class]] ||
        ![shadowBorderColor isKindOfClass:[UIColor class]] ||
        shadowBorderWidth <= 0.0) {
        return NO;
    }
    
    CALayer *borderLayer = [CALayer layer];
    borderLayer.frame = CGRectMake(0, 0, imageView.image.size.width, imageView.image.size.height);
    borderLayer.contents = (id)imageView.image.CGImage;
    borderLayer.position = CGPointMake(imageView.bounds.size.width / 2.0, imageView.bounds.size.height / 2.0);
    borderLayer.shadowColor = shadowBorderColor.CGColor;
    borderLayer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    borderLayer.shadowOpacity = 1.0f;
    borderLayer.shadowRadius = shadowBorderWidth;
    
    [imageView.layer addSublayer:borderLayer];
    
    return YES;
}

+ (BOOL)setImageView:(UIImageView *)imageView maskImage:(UIImage *)maskImage contentImage:(UIImage *)contentImage capInsets:(UIEdgeInsets)capInsets {
    if (![imageView isKindOfClass:[UIImageView class]] ||
        ![maskImage isKindOfClass:[UIImage class]] ||
        ![contentImage isKindOfClass:[UIImage class]]) {
        return NO;
    }
    
    CGSize imageViewSize = imageView.bounds.size;
    
    UIImage *finalMaskImage = maskImage;
    
    if (!UIEdgeInsetsEqualToEdgeInsets(capInsets, UIEdgeInsetsZero)) {
        UIImage *resizableMaskImage = [maskImage resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
        
        UIImageView *maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageViewSize.width, imageViewSize.height)];
        maskImageView.image = resizableMaskImage;
        
        UIGraphicsBeginImageContextWithOptions(imageViewSize, NO, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [maskImageView.layer renderInContext:context];
        
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        finalMaskImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        UIGraphicsEndImageContext();
    }
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.contents = (id)[finalMaskImage CGImage];
    maskLayer.frame = CGRectMake(0, 0, imageViewSize.width, imageViewSize.height);
    imageView.layer.mask = maskLayer;
    imageView.layer.masksToBounds = YES;
    imageView.image = contentImage;
    
    return YES;
}

#pragma mark - Creation

+ (UIImageView *)maskedImageViewWithFrame:(CGRect)frame maskImage:(UIImage *)maskImage contentImage:(UIImage *)contentImage capInsets:(UIEdgeInsets)capInsets {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    maskLayer.contents = (id)maskImage.CGImage;
    
    if (!UIEdgeInsetsEqualToEdgeInsets(capInsets, UIEdgeInsetsZero)) {
        maskLayer.contentsScale = maskImage.scale;
        
        CGFloat y = capInsets.top / maskImage.size.height;
        CGFloat x = capInsets.left / maskImage.size.width;
        CGFloat width = (maskImage.size.width - capInsets.left - capInsets.right) / maskImage.size.width;
        CGFloat height = (maskImage.size.height - capInsets.top - capInsets.bottom) / maskImage.size.height;
        
        x = MIN(MAX(0, x), 1.0);
        y = MIN(MAX(0, y), 1.0);
        width = MIN(MAX(0, width), 1.0);
        height = MIN(MAX(0, height), 1.0);
        
        maskLayer.contentsCenter = CGRectMake(x, y, width, height);
    }

    imageView.layer.mask = maskLayer;
    imageView.layer.masksToBounds = YES;
    imageView.image = contentImage;
    
    return imageView;
}

@end
