//
//  WCImageTool.h
//  Test
//
//  Created by wesley_chen on 2018/5/4.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCImageTool : NSObject

#pragma mark - Image Generation

/*!
 *  Get an image with pure color
 *
 *  @param color the UIColor
 *
 *  @return a UIImage with {1px, 1px} colored by UIColor
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 Get an image with pure color

 @param color the UIColor
 @param size the size
 @return the new image
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 Get a alpha version of UIImage

 @param image the original image
 @param alpha the alpha, which is (0,1)
 @return the new image with alpha
 */
+ (UIImage *)imageWithImage:(UIImage *)image alpha:(CGFloat)alpha;

/**
 Resize UIImage
 
 @param image the orginal image
 @param size the size for scale to fit
 @return the new image
 @see http://stackoverflow.com/questions/2658738/the-simplest-way-to-resize-an-uiimage
 @discussion The returned image considers screen scale
 */
+ (nullable UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size;

/**
 Draw a foreground image with frame on a background image

 @param foregroundImage the foreground image
 @param backgroundImage the background image
 @param frame the frame of the foreground image
 @return the new image
 */
+ (UIImage *)imageWithForegroundImage:(UIImage *)foregroundImage inBackgroundImage:(UIImage *)backgroundImage foregroundImageFrame:(CGRect)frame;

+ (nullable UIImage *)imageWithImage:(UIImage *)image croppedToFrame:(CGRect)frame;

/**
 Crop an image with the specific frame, then scale the cropped image to the specific size

 @param image the image to crop
 @param frame the frame of cropping
 @param size the scaled size
 @return the cropped and scaled image
 @see https://nshipster.com/image-resizing/
 @discussion The returned image considers screen scale
 */
+ (nullable UIImage *)imageWithImage:(UIImage *)image croppedToFrame:(CGRect)frame scaledToSize:(CGSize)size;

#pragma mark - Image Modification

+ (UIImage *)imageWithImage:(UIImage *)image templateColor:(UIColor *)templateColor;
+ (UIImage *)imageWithImage:(UIImage *)image replaceColorComponents:(CGFloat[6])components toColor:(UIColor *)color;

/**
 Get a corner rounded image

 @param image the original image
 @param radius the radius
 @return the corner rounded image
 */
+ (UIImage *)cornerRoundedImageWithImage:(UIImage *)image radius:(CGFloat)radius;

/**
 Get a corner rounded image with size

 @param image the original image
 @param radius the radius
 @param size the size of corner rounded image. If the size not same as the image.size, the output image will be scaled.
 @return the corner rounded image
 @see https://stackoverflow.com/a/8125604
 */
+ (UIImage *)cornerRoundedImageWithImage:(UIImage *)image radius:(CGFloat)radius size:(CGSize)size;

#pragma mark - Image Access

/**
 Get a URL for image in resource bundle

 @param imageName the name of image, if not with extension, treat image as png and consider @2x.png/@2X.PNG, @3x.png/@3X.PNG
 @param resourceBundleName the resource bundle name, and nil for main bundle
 @return the NSURL. Return nil if not found.
 */
+ (NSURL *)URLWithImageName:(NSString *)imageName inResourceBundle:(nullable NSString *)resourceBundleName;

/**
 Get an image with name in resource bundle

 @param name the image name, if not with extension, treat image as png and consider @2x.png/@2X.PNG, @3x.png/@3X.PNG
 @param resourceBundleName the bundle name, and the name can have or not have .bundle extension. Note that nil for main bunde.
 @return the UIImage. Return nil if not found.
 */
+ (UIImage *)imageWithName:(NSString *)name inResourceBundle:(nullable NSString *)resourceBundleName;

NS_ASSUME_NONNULL_END

@end
