//
//  WCImageViewTool.m
//  AppTest
//
//  Created by wesley_chen on 2018/5/4.
//

#import "WCImageViewTool.h"

@implementation WCImageViewTool

+ (void)setImageView:(UIImageView *)imageView shadowBorderColor:(UIColor *)shadowBorderColor shadowBorderWidth:(CGFloat)shadowBorderWidth {
    
    if (!imageView.image) {
        NSLog(@"%@'s image is nil", self);
        return;
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
}

+ (void)setImageView:(UIImageView *)imageView maskImage:(UIImage *)maskImage contentImage:(UIImage *)contentImage capInsets:(UIEdgeInsets)capInsets {
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
}

@end
