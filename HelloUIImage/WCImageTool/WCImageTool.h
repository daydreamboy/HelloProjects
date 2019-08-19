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

#pragma mark > From Image

/**
 Get an image with pure color

 @param color the UIColor
 @return a UIImage with {1px, 1px} colored by UIColor
 */
+ (nullable UIImage *)imageWithColor:(UIColor *)color;

/**
 Get an image with pure color

 @param color the UIColor
 @param size the size
 @return the image with the color
 */
+ (nullable UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 Get an image with pure color and corner radius

 @param color the UIColor
 @param size the size
 @param cornerRadius the corner radius. Pass 0 to not cornered
 @return the image with color and corner radius
 @see https://stackoverflow.com/questions/2835448/how-to-draw-a-rounded-rectangle-in-core-graphics-quartz-2d
 */
+ (nullable UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;

/**
 Get a alpha version of UIImage

 @param image the original image
 @param alpha the alpha, which is (0,1)
 @return the new image with alpha
 */
+ (nullable UIImage *)imageWithImage:(UIImage *)image alpha:(CGFloat)alpha;

/**
 Draw a foreground image with frame on a background image
 
 @param foregroundImage the foreground image
 @param backgroundImage the background image
 @param frame the frame of the foreground image
 @return the new image
 */
+ (nullable UIImage *)imageWithForegroundImage:(UIImage *)foregroundImage inBackgroundImage:(UIImage *)backgroundImage foregroundImageFrame:(CGRect)frame;

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
 Crop an image with the specific frame

 @param image the image to crop
 @param frame the frame of cropping
 @return the cropped image
 */
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

#pragma mark > From Video



#pragma mark - Image Modification

/**
 Get an image with tint color

 @param image the image as template
 @param tintColor the tint color
 @return an image with tint color
 */
+ (nullable UIImage *)imageWithImage:(UIImage *)image tintColor:(UIColor *)tintColor;

+ (UIImage *)imageWithImage:(UIImage *)image replaceColorComponents:(CGFloat[_Nonnull 6])components toColor:(UIColor *)color;

/**
 Get a corner rounded image

 @param image the original image
 @param radius the radius
 @return the corner rounded image
 */
+ (nullable UIImage *)cornerRoundedImageWithImage:(UIImage *)image radius:(CGFloat)radius;

/**
 Get a corner rounded image with size

 @param image the original image
 @param radius the radius
 @param size the size of corner rounded image. If the size not same as the image.size, the output image will be scaled.
 @return the corner rounded image
 @see https://stackoverflow.com/a/8125604
 */
+ (nullable UIImage *)cornerRoundedImageWithImage:(UIImage *)image radius:(CGFloat)radius scaledToSize:(CGSize)size;

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
