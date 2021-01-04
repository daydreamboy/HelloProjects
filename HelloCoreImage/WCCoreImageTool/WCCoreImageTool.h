//
//  WCCoreImageTool.h
//  HelloCoreImage
//
//  Created by wesley_chen on 2019/1/25.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCCoreImageTool : NSObject

/**
 Get string from QRCode image

 @param QRCodeImage the QRCode image
 @return return string if detect successfully. Return nil if failed.
 @see https://stackoverflow.com/a/39294599
 */
- (nullable NSString *)stringWithQRCodeImage:(UIImage *)QRCodeImage;

#pragma mark -

/**
 Get string from QRCode image
 
 @param QRCodeImage the QRCode image
 @return return string if detect successfully. Return nil if failed.
 @see https://stackoverflow.com/a/39294599
 @discussion If call this method frequently, use its instance method instead for performance.
 */
+ (nullable NSString *)stringWithQRCodeImage:(UIImage *)QRCodeImage;

#pragma mark > QR Code from String

/**
 Create a QR image from string
 
 @param string the string in QR image
 @param size the image size
 @param tintColor the tint color. If nil, use the default style
 
 @return the QR image
 
 @see https://stackoverflow.com/a/37967191
 */
+ (nullable UIImage *)QRImageWithString:(NSString *)string size:(CGSize)size tintColor:(nullable UIColor *)tintColor;

#pragma mark - CIImage Processing

+ (nullable CIImage *)invertColorsWithImage:(CIImage *)image;
+ (nullable CIImage *)blackColorToTransparentWithImage:(CIImage *)image;

@end

NS_ASSUME_NONNULL_END
