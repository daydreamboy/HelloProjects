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
@end

@interface WCImageTool ()

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

@end

NS_ASSUME_NONNULL_END
