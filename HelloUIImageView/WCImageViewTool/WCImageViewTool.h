//
//  WCImageViewTool.h
//  AppTest
//
//  Created by wesley_chen on 2018/5/4.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WCImageViewTool : NSObject

/**
 add shadow border to image view

 @param imageView the UIImageView
 @param shadowBorderColor the shadow border color
 @param shadowBorderWidth the shadow border width
 */
+ (void)setImageView:(UIImageView *)imageView shadowBorderColor:(UIColor *)shadowBorderColor shadowBorderWidth:(CGFloat)shadowBorderWidth;

/**
 mask the content of image view by mask image

 @param imageView the UIImageView
 @param maskImage the image to mask
 @param contentImage the content image of UIImageView
 @param capInsets the stretch cap inset. If no stretch, use UIEdgeInsetZero
 */
+ (void)setImageView:(UIImageView *)imageView maskImage:(UIImage *)maskImage contentImage:(UIImage *)contentImage capInsets:(UIEdgeInsets)capInsets;
@end
