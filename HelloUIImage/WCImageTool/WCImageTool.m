//
//  WCImageTool.m
//  Test
//
//  Created by wesley_chen on 2018/5/4.
//

#import "WCImageTool.h"

@implementation WCImageTool

#pragma mark - Image Generation

+ (nullable UIImage *)imageWithColor:(UIColor *)color {
    // Note: create 1px X 1px size of rect
    return [self imageWithColor:color size:CGSizeMake(1.0 / [UIScreen mainScreen].scale, 1.0 / [UIScreen mainScreen].scale) cornerRadius:0];
}

+ (nullable UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    return [self imageWithColor:color size:size cornerRadius:0];
}

+ (nullable UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius {
    if (![color isKindOfClass:[UIColor class]]) {
        return nil;
    }
    
    if (size.width <= 0 || size.height <= 0) {
        return nil;
    }
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    // Note: use UIGraphicsBeginImageContextWithOptions instead of UIGraphicsBeginImageContext to set UIImage.scale
    // @see https://stackoverflow.com/questions/4965036/uigraphicsgetimagefromcurrentimagecontext-retina-resolution
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (cornerRadius > 0) {
        [[UIBezierPath bezierPathWithRoundedRect:(CGRect){CGPointZero, size} cornerRadius:cornerRadius] addClip];
    }
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (nullable UIImage *)imageWithImage:(UIImage *)image alpha:(CGFloat)alpha {
    if (![image isKindOfClass:[UIImage class]]) {
        return nil;
    }
    
    if (alpha >= 1.0 || alpha < 0.0) {
        return image;
    }
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef contex = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(contex, 1, -1);
    CGContextTranslateCTM(contex, 0, -rect.size.height);
    
    CGContextSetBlendMode(contex, kCGBlendModeMultiply);
    CGContextSetAlpha(contex, alpha);
    
    CGContextDrawImage(contex, rect, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (nullable UIImage *)imageWithForegroundImage:(UIImage *)foregroundImage inBackgroundImage:(UIImage *)backgroundImage foregroundImageFrame:(CGRect)frame {
    if (![foregroundImage isKindOfClass:[UIImage class]] ||
        ![backgroundImage isKindOfClass:[UIImage class]]) {
        return nil;
    }
    
    if (frame.size.width <= 0 || frame.size.height <= 0) {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(backgroundImage.size, NO, 0.0);
    
    [backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
    [foregroundImage drawInRect:frame];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

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
    
    CGContextRelease(contextRef);
    CGImageRelease(newImageRef);
    
    return newImage;
}

+ (nullable UIImage *)imageWithImage:(UIImage *)image croppedToFrame:(CGRect)frame {
    if (!image) {
        return nil;
    }
    
    if (frame.size.width <= 0 || frame.size.height <= 0) {
        return nil;
    }
    
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    if (CGRectEqualToRect(frame, imageRect)) {
        return image;
    }
    
    CGRect clippedRect = frame;
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, clippedRect);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return newImage;
}

+ (nullable UIImage *)imageWithImage:(UIImage *)image croppedToFrame:(CGRect)frame scaledToSize:(CGSize)size {
    if (!image) {
        return nil;
    }
    
    if (frame.size.width <= 0 || frame.size.height <= 0 || size.width <= 0 || size.height <= 0) {
        return nil;
    }
    
    if (CGSizeEqualToSize(image.size, size)) {
        return image;
    }
    
    CGRect clippedRect = frame;
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, clippedRect);
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGSize canvasSize = CGSizeMake(size.width * scale, size.height * scale);
    
    CGContextRef contextRef = CGBitmapContextCreate(nil, canvasSize.width, canvasSize.height, bitsPerComponent, 0, colorSpace, bitmapInfo);
    if (contextRef == NULL) {
        return nil;
    }
    CGContextSetInterpolationQuality(contextRef, kCGInterpolationHigh);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, canvasSize.width, canvasSize.height), imageRef);
    
    CGImageRef newImageRef = CGBitmapContextCreateImage(contextRef);
    
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:scale orientation:UIImageOrientationUp];
    
    CGContextRelease(contextRef);
    CGImageRelease(imageRef);
    CGImageRelease(newImageRef);
    
    return newImage;
}

#pragma mark - Image Modify

+ (nullable UIImage *)imageWithImage:(UIImage *)image tintColor:(UIColor *)tintColor {
    if (![image isKindOfClass:[UIImage class]] || ![tintColor isKindOfClass:[UIColor class]]) {
        return nil;
    }
    
    UIImage *newImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIGraphicsBeginImageContextWithOptions(newImage.size, NO, newImage.scale);
    [tintColor set];
    [newImage drawInRect:CGRectMake(0, 0, newImage.size.width, newImage.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// @see https://gist.github.com/Shilo/1292152
+ (UIImage *)imageWithImage:(UIImage *)image replaceColorComponents:(CGFloat[6])components toColor:(UIColor *)color {
    CGFloat alpha = CGColorGetAlpha(color.CGColor);
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Note: UIGraphicsBeginImageContextWithOptions use UIKit coordiante system
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // convert coordiante system
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    if (!alpha) {
        CGContextClearRect(context, imageRect);
    }
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, imageRect);
    
    CGFloat maskingColorComponents[6] = { components[0], components[1], components[2], components[3], components[4], components[5] };
    /*
     UIGraphicsPushContext(context);
     
     CGImageRef imageRef = image.CGImage;
     context = CGBitmapContextCreate(NULL, image.size.width, image.size.height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), CGImageGetColorSpace(imageRef), CGImageGetBitmapInfo(imageRef));
     CGContextDrawImage(context, imageRect, image.CGImage);
     CGImageRef changedImageRef = CGBitmapContextCreateImage(context);
     
     CGContextRelease(context);
     UIGraphicsPopContext();
     
     context = UIGraphicsGetCurrentContext();
     */
    
    CGDataProviderRef provider = CGImageGetDataProvider(image.CGImage);
    CGBitmapInfo oldInfo = CGImageGetBitmapInfo(image.CGImage);
    CGBitmapInfo newInfo = (oldInfo & ~kCGBitmapAlphaInfoMask);//(oldInfo & (UINT32_MAX ^ kCGBitmapAlphaInfoMask));// | kCGImageAlphaNoneSkipLast;
    CGImageRef changedImageRef = CGImageCreate(image.size.width * image.scale, image.size.height * image.scale, CGImageGetBitsPerComponent(image.CGImage), CGImageGetBitsPerPixel(image.CGImage), CGImageGetBytesPerRow(image.CGImage), CGImageGetColorSpace(image.CGImage), newInfo, provider, NULL, false, kCGRenderingIntentDefault);
    
    CGImageRef maskedImageRef = CGImageCreateWithMaskingColors(changedImageRef/*image.CGImage*/, maskingColorComponents);
    if (!maskedImageRef) {
        return nil;
    }
    
    CGImageRef newImageRef;
    CGContextDrawImage(context, imageRect, maskedImageRef);
    newImageRef = CGBitmapContextCreateImage(context);
    CGImageRelease(maskedImageRef);
    
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (nullable UIImage *)cornerRoundedImageWithImage:(UIImage *)image radius:(CGFloat)radius {
    return [self cornerRoundedImageWithImage:image radius:radius scaledToSize:image.size];
}

+ (nullable UIImage *)cornerRoundedImageWithImage:(UIImage *)image radius:(CGFloat)radius scaledToSize:(CGSize)size {
    if (![image isKindOfClass:[UIImage class]]) {
        return nil;
    }
    
    if (size.width <= 0 || size.height <= 0) {
        return nil;
    }
    
    if (radius <= 0 && CGSizeEqualToSize(image.size, size)) {
        return image;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [[UIBezierPath bezierPathWithRoundedRect:(CGRect){CGPointZero, size} cornerRadius:radius] addClip];
    [image drawInRect:(CGRect){CGPointZero, size}];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - Image Access

+ (NSURL *)URLWithImageName:(NSString *)name inResourceBundle:(NSString *)resourceBundleName {
    NSBundle *resourceBundle;
    NSString *resourceBundlePath;
    
    if (resourceBundleName) {
        resourceBundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:resourceBundleName];
        resourceBundle = [NSBundle bundleWithPath:resourceBundlePath];
    }
    else {
        resourceBundlePath = [[NSBundle mainBundle] bundlePath];
        resourceBundle = [NSBundle mainBundle];
    }
    
    if (!name.pathExtension.length) {
        NSArray *imageNames = @[
                                // image@2x.png
                                [NSString stringWithFormat:@"%@@%dx.png", name, (int)[UIScreen mainScreen].scale],
                                // iamge@2x.PNG
                                [NSString stringWithFormat:@"%@@%dx.PNG", name, (int)[UIScreen mainScreen].scale],
                                // image@2X.png
                                [NSString stringWithFormat:@"%@@%dX.png", name, (int)[UIScreen mainScreen].scale],
                                // image@2X.PNG
                                [NSString stringWithFormat:@"%@@%dX.PNG", name, (int)[UIScreen mainScreen].scale],
                                ];
        
        NSString *imageFileName = [imageNames firstObject];
        for (NSString *imageName in imageNames) {
            NSString *filePath = [resourceBundlePath stringByAppendingPathComponent:imageName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                imageFileName = imageName;
                break;
            }
        }
        
        NSURL *URL = [resourceBundle URLForResource:[imageFileName stringByDeletingPathExtension] withExtension:[imageFileName pathExtension]];
        return URL;
    }
    else {
        NSURL *URL = [resourceBundle URLForResource:[name stringByDeletingPathExtension] withExtension:[name pathExtension]];
        return URL;
    }
}

+ (UIImage *)imageWithName:(NSString *)name inResourceBundle:(NSString *)resourceBundleName {
    NSString *resourceBundlePath = [NSBundle mainBundle].bundlePath;
    if (resourceBundleName) {
        if ([resourceBundleName hasSuffix:@".bundle"]) {
            resourceBundlePath = [resourceBundlePath stringByAppendingPathComponent:resourceBundleName];
        }
        else {
            resourceBundlePath = [resourceBundlePath stringByAppendingPathComponent:[resourceBundleName stringByAppendingPathExtension:@"bundle"]];
        }
    }
    
    NSString *filePath;
    if (!name.pathExtension.length) {
        NSArray *imageNames = @[
                                [NSString stringWithFormat:@"%@@%dx.png", name, (int)[UIScreen mainScreen].scale],
                                [NSString stringWithFormat:@"%@@%dx.PNG", name, (int)[UIScreen mainScreen].scale],
                                [NSString stringWithFormat:@"%@@%dX.png", name, (int)[UIScreen mainScreen].scale],
                                [NSString stringWithFormat:@"%@@%dX.PNG", name, (int)[UIScreen mainScreen].scale],
                                ];
        NSString *imageFileName = [imageNames firstObject];
        for (NSString *imageName in imageNames) {
            NSString *path = [resourceBundlePath stringByAppendingPathComponent:imageName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                imageFileName = imageName;
                break;
            }
        }
        filePath = [resourceBundlePath stringByAppendingPathComponent:imageFileName];
    }
    else {
        filePath = [resourceBundlePath stringByAppendingPathComponent:name];
    }
    
    return [UIImage imageWithContentsOfFile:filePath];
}

// @see https://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
+ (UIImage *)orientationUpImageWithImage:(UIImage *)image {
    // No-op if the orientation is already correct
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    UIImage *fixedImage = [UIImage imageWithCGImage:cgImage];
    CGContextRelease(ctx);
    CGImageRelease(cgImage);
    
    return fixedImage;
}

@end
