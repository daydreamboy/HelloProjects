//
//  WCImageTool.m
//  Test
//
//  Created by wesley_chen on 2018/5/4.
//

#import "WCImageTool.h"

@implementation WCImageTool

#pragma mark - Image Generation

+ (nullable UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
    if (!image) {
        return nil;
    }
    
    if (size.width <= 0 || size.height <= 0) {
        return nil;
    }
    
    // Note: avoid redundant drawing
    if (CGSizeEqualToSize(image.size, size)) {
        return image;
    }
    
    CGImageRef imageRef = image.CGImage;
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGSize canvasSize = CGSizeMake(size.width * scale, size.height * scale);
    
    // Note: use 0, see https://stackoverflow.com/questions/24124546/cgbitmapcontextcreate-invalid-data-bytes-row
    CGContextRef contextRef = CGBitmapContextCreate(nil, canvasSize.width, canvasSize.height, bitsPerComponent, 0, colorSpace, bitmapInfo);
    CGContextSetInterpolationQuality(contextRef, kCGInterpolationHigh);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, canvasSize.width, canvasSize.height), imageRef);
    
    CGImageRef newImageRef = CGBitmapContextCreateImage(contextRef);
    
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:scale orientation:UIImageOrientationUp];
    
    // BUG: Don't release this imageRef
    CGImageRelease(imageRef);
    CGContextRelease(contextRef);
    CGImageRelease(newImageRef);
    
    return newImage;
}

@end
