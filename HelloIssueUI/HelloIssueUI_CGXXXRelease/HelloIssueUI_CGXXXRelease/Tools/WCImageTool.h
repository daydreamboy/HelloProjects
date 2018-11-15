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
 Resize UIImage
 
 @param image the orginal image
 @param size the size for scale to fit
 @return the new image
 @see http://stackoverflow.com/questions/2658738/the-simplest-way-to-resize-an-uiimage
 @discussion The returned image considers screen scale
 */
+ (nullable UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size;

NS_ASSUME_NONNULL_END

@end
