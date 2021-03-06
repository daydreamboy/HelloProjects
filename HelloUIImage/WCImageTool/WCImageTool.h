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

#pragma mark > From Image

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
 @param frame the frame of cropping which in image frame
 
 @return the cropped image
 */
+ (nullable UIImage *)imageWithImage:(UIImage *)image croppedToFrame:(CGRect)frame;

/**
 Crop an image with the specific frame, then scale the cropped image to the specific size

 @param image the image to crop
 @param frame the frame of cropping which in image frame
 @param size the scaled size which is returned image.size
 
 @return the cropped and scaled image
 
 @discussion See +[WCImageTool imageWithImage:croppedToFrame:scaledToSize:imageScale:] for more details.
 */
+ (nullable UIImage *)imageWithImage:(UIImage *)image croppedToFrame:(CGRect)frame scaledToSize:(CGSize)size;

/**
 Crop an image with the specific frame, then scale the cropped image to the specific size
 
 @param image image the image to crop
 @param frame the frame of cropping which in image frame
 @param size the scaled size which is returned image.size
 @param imageScale the image scale
 
 @return the cropped and scaled image
 
 @see https://nshipster.com/image-resizing/
 */
+ (nullable UIImage *)imageWithImage:(UIImage *)image croppedToFrame:(CGRect)frame scaledToSize:(CGSize)size imageScale:(CGFloat)imageScale;

/**
 Crop an image with the center square rect, then scale the cropped image to the specific size
 
 @param image image the image to crop
 @param size the scaled size which is returned image.size
 @param imageScale the image scale
 
 @return the cropped and scaled image
 */
+ (nullable UIImage *)cropImageByCenterSquareRectWithImage:(UIImage *)image scaledToSize:(CGSize)size imageScale:(CGFloat)imageScale;

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

 @param name the image name, if not with extension, treat image as png and consider @2x.png/@3x.png like imageNamed: method
 @param resourceBundleName the bundle name, and the name can have or not have .bundle extension. Note that nil for main bunde.
 @return the UIImage. Return nil if not found.
 */
+ (nullable UIImage *)imageWithName:(NSString *)name inResourceBundle:(nullable NSString *)resourceBundleName;

#pragma mark - Animated Image

+ (nullable UIImage *)animatedImageWithData:(NSData *)data;

#pragma mark - Query Image

/**
 Get the uncompressed data bytes of the image
 
 @param image the UIImage
 @return the memory size in bytes. If the parameter is not UIImage, return 0.
 @see https://stackoverflow.com/a/1298043
 */
+ (NSUInteger)memoryBytesWithImage:(UIImage *)image;

#pragma mark > Size

/**
 Get image size with file
 
 @param path the path to image file
 @param scale the scale for returned size, e.g. returnedSize.width = (widthInPixel / scale).
        If scale = 0, use [UIScreen mainScreen].scale
 
 @return the point size which is  (widthInPixel / scale, heightInPixel / scale)
 
 @discussion This method get image size without loading image into memory.
 */
+ (CGSize)imageSizeWithPath:(NSString *)path scale:(CGFloat)scale;

/**
 Get image size with data
 
 @param data the data of image
 @param scale the scale for returned size, e.g. returnedSize.width = (widthInPixel / scale).
        If scale = 0, use [UIScreen mainScreen].scale
 
 @return the point size which is  (widthInPixel / scale, heightInPixel / scale)
 */
+ (CGSize)imageSizeWithData:(NSData *)data scale:(CGFloat)scale;

#pragma mark > Metadata

+ (nullable NSDictionary *)imagePropertiesWithPath:(NSString *)path;
+ (nullable NSDictionary *)imagePropertiesWithData:(NSData *)data;

#pragma mark > File

+ (nullable NSString *)fileNameWithImage:(UIImage *)image;
+ (nullable NSString *)containerBundlePathWithImage:(UIImage *)image;

#pragma mark - Thumbnail

#pragma mark > Thumbnail UIImage

/**
 Create a thumbnail image from path
 
 @param path the path for image file
 @param boundingSize the bounding size of the thumbnail. The actual size of thumbnail is not equal to the bounding size, but it's sure that
 the thumbnail image is scaled by ratio into the bounding size
 @param scale the scale ratio. Pass 0 if use the current screen scale.
 @return the thumbnail image
 
 @see https://medium.com/@prafullkumar77/image-usage-memory-comparison-and-best-practices-in-ios-wwdc2018-4a8919019ae9
 */
+ (nullable UIImage *)thumbnailImageWithPath:(NSString *)path boundingSize:(CGSize)boundingSize scale:(CGFloat)scale;

/**
 Create a thumbnail image from path
 
 @param data the image data
 @param boundingSize the bounding size of the thumbnail. The actual size of thumbnail is not equal to the bounding size, but it's sure that
 the thumbnail image is scaled by ratio into the bounding size
 @param scale the scale ratio. Pass 0 if use the current screen scale.
 @return the thumbnail image
 
 @discussion This method used for the data is downloaded from network. If read image from local file,
 use +[WCImageTool thumbnailImageWithPath:boundingSize:scale:] instead.
 */
+ (nullable UIImage *)thumbnailImageWithData:(NSData *)data boundingSize:(CGSize)boundingSize scale:(CGFloat)scale;

+ (nullable UIImage *)thumbnailImageWithData:(NSData *)data limitedToMemorySize:(long long)memorySize;

#pragma mark > Thumbnail NSData

/**
 Get thumbnail image data from path
 
 @param path the path of image file
 @param boundingSize the bouding size which unit is pixel
 
 @return the thumbnail image data
 
 @header #import <MobileCoreServices/MobileCoreServices.h>
 */
+ (nullable NSData *)thumbnailImageDataWithPath:(NSString *)path boundingSize:(CGSize)boundingSize;

/**
 Get thumbnail image data from original image data
 
 @param data the original image data
 @param boundingSize the bouding size which unit is pixel
 
 @return the thumbnail image data
 
 @header #import <MobileCoreServices/MobileCoreServices.h>
 */
+ (nullable NSData *)thumbnailImageDataWithData:(NSData *)data boundingSize:(CGSize)boundingSize;

+ (nullable NSData *)thumbnailImageDataWithData:(NSData *)data boundingSize:(CGSize)boundingSize limitedToMemorySize:(long long)memorySize;

#pragma mark - Thumbnail Image Utility

/**
 Calculate the max length of side which make the image memory not greater than the specific memory size
 
 @param imageSize the size (width, height) of image, which width, height are expected > 0
 @param memorySize the limited memory size, which are expected > 0
 
 @return the calculated max length of side make the image memory not greater than the `memorySize`.
 Return 0 if the paramters are not correct.
 */
+ (CGFloat)calculateMaxLengthWithImageSize:(CGSize)imageSize limitedToMemorySize:(long long)memorySize;

#pragma mark - Thumbnail Animated Image Data

+ (nullable NSData *)thumbnailAnimatedImageDataWithData:(NSData *)data path:(NSString *)path boundingSize:(CGSize)boundingSize scale:(CGFloat)scale;

@end

NS_ASSUME_NONNULL_END
