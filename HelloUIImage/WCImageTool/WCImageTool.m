//
//  WCImageTool.m
//  Test
//
//  Created by wesley_chen on 2018/5/4.
//

#import "WCImageTool.h"
#import <ImageIO/ImageIO.h>

#if __has_feature(objc_arc)

#define toCF (__bridge CFTypeRef)
#define fromCF (__bridge id)

#else

#define toCF (CFTypeRef)
#define fromCF (id)

#endif

#define CF_SAFE_RELEASE(ref) if ((ref) != NULL) { CFRelease((ref)); }

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

+ (nullable UIImage *)imageWithName:(NSString *)name inResourceBundle:(nullable NSString *)resourceBundleName {
    if (![name isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (resourceBundleName && ![resourceBundleName isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSString *resourceBundlePath = [NSBundle mainBundle].bundlePath;
    if (resourceBundleName.length) {
        resourceBundleName = [resourceBundleName hasSuffix:@".bundle"] ? resourceBundleName : [resourceBundleName stringByAppendingPathExtension:@"bundle"];
        resourceBundlePath = [resourceBundlePath stringByAppendingPathComponent:resourceBundleName];
    }
    
    NSString *filePath;
    if (name.pathExtension.length) {
        filePath = [resourceBundlePath stringByAppendingPathComponent:name];
        return [UIImage imageWithContentsOfFile:filePath];
    }
    
    
    int currentScale = (int)[UIScreen mainScreen].scale;
    NSMutableArray *imageNames = [NSMutableArray arrayWithCapacity:3];
    [imageNames addObject:[NSString stringWithFormat:@"%@@%@x.png", name, @(currentScale)]];
    
    for (int scale = 3; scale > 0; --scale) {
        if (scale != currentScale) {
            [imageNames addObject:[NSString stringWithFormat:@"%@@%@x.png", name, @(scale)]];
        }
    }
    
    for (NSString *imageName in imageNames) {
        NSString *path = [resourceBundlePath stringByAppendingPathComponent:imageName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            filePath = path;
            break;
        }
    }
    
    if (filePath) {
        return [UIImage imageWithContentsOfFile:filePath];
    }
    
    return nil;
}

#pragma mark -

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

#pragma mark - Animated Image

+ (nullable UIImage *)animatedImageWithData:(NSData *)data {
    if (![data isKindOfClass:[NSData class]] || data.length == 0) {
        return nil;
    }
    
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithData(toCF data, NULL);
    size_t count = CGImageSourceGetCount(imageSourceRef);
    CGImageRef images[count];
    int delaysInCentiseconds[count]; // in centiseconds
    int totalDurationInCentiseconds = 0;
    int gcd = 1;
    
    for (size_t i = 0; i < count; ++i) {
        images[i] = CGImageSourceCreateImageAtIndex(imageSourceRef, i, NULL);
        
        // Note: use 100ms (also 0.1s) as default, see https://stackoverflow.com/a/17824564
        int delayInCentiseconds = 1;
        
        CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, i, NULL);
        if (properties != NULL) {
            CFDictionaryRef GIFProperties = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
            if (GIFProperties != NULL) {
                NSNumber *delayInSeconds = fromCF CFDictionaryGetValue(GIFProperties, kCGImagePropertyGIFUnclampedDelayTime);
                
                if (delayInSeconds == NULL || [delayInSeconds doubleValue] <= 0) {
                    delayInSeconds = fromCF CFDictionaryGetValue(GIFProperties, kCGImagePropertyGIFDelayTime);
                }
                
                if ([delayInSeconds doubleValue] > 0) {
                    // Convert seconds to centiseconds
                    delayInCentiseconds = (int)lrint([delayInSeconds doubleValue] * 100);
                }
            }
            
            CFRelease(properties);
        }
        
        delaysInCentiseconds[i] = delayInCentiseconds;
        totalDurationInCentiseconds += delayInCentiseconds;
        gcd = (i == 0 ? delaysInCentiseconds[i] : GCDOfPair(delaysInCentiseconds[i], gcd));
    }
        
    size_t frameCount = totalDurationInCentiseconds / gcd;
    UIImage *frames[frameCount];
    for (size_t i = 0, f = 0; i < count; ++i) {
        // Note: create one frame according to the one image of GIF
        UIImage *frame = [UIImage imageWithCGImage:images[i]];
        
        for (size_t j = delaysInCentiseconds[i] / gcd; j > 0; --j) {
            // Note: repeat adding the same frame base on its times (the faked `duration`)
            frames[f++] = frame;
        }
        
        // Note: because images[i] created by CGImageSourceCreateImageAtIndex so should release it
        CGImageRelease(images[i]);
    }
    
    UIImage *animatedImage = [UIImage animatedImageWithImages:[NSArray arrayWithObjects:frames count:frameCount] duration:(NSTimeInterval)totalDurationInCentiseconds / 100.0];
    
    CFRelease(imageSourceRef);
    
    return animatedImage;
}

#pragma mark - Query Image

+ (NSUInteger)memoryBytesWithImage:(UIImage *)image {
    if (![image isKindOfClass:[UIImage class]]) {
        return 0;
    }
    
    NSUInteger bytes = 0;
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGColorSpaceModel model = CGColorSpaceGetModel(colorSpace);
    
    // Note: use components to check grayscale image is not accurate
    // @see https://stackoverflow.com/a/16770978
    //size_t components = CGColorSpaceGetNumberOfComponents(colorSpace);
    if (model == kCGColorSpaceModelMonochrome) {
        bytes = CGImageGetHeight(image.CGImage) * CGImageGetBytesPerRow(image.CGImage);
    }
    else {
        NSUInteger height = (NSUInteger)ceil(image.size.height) * image.scale;
        NSUInteger width = (NSUInteger)ceil(image.size.width) * image.scale;
        
        NSUInteger bytesPerRow = 4 * width;
        if (bytesPerRow % 16)
            bytesPerRow = ((bytesPerRow / 16) + 1) * 16;
        bytes = height * bytesPerRow;
    }

    return bytes;
}

#pragma mark > Size

+ (CGSize)imageSizeWithPath:(NSString *)path scale:(CGFloat)scale {
    return [self imageSizeWithData:nil path:path scale:scale];
}

+ (CGSize)imageSizeWithData:(NSData *)data scale:(CGFloat)scale {
    return [self imageSizeWithData:data path:nil scale:scale];
}

#pragma mark ::

+ (CGSize)imageSizeWithData:(NSData *)data path:(NSString *)path scale:(CGFloat)scale {
    if ((![data isKindOfClass:[NSData class]] || data.length == 0) &&
        (![path isKindOfClass:[NSString class]] || path.length == 0)) {
        return CGSizeMake(-1, -1);
    }
    
    CGImageSourceRef imageSourceRef = NULL;
    
    if (data) {
        imageSourceRef = CGImageSourceCreateWithData(toCF data, NULL);
    }
    else {
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            return CGSizeMake(-1, -1);
        }
        
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        if (!fileURL) {
            return CGSizeMake(-1, -1);
        }
        
        imageSourceRef = CGImageSourceCreateWithURL(toCF fileURL, NULL);
    }
    
    if (imageSourceRef == NULL) {
        return CGSizeMake(-1, -1);
    }
    
    CFDictionaryRef imagePropertiesRef = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
    if (imagePropertiesRef == NULL) {
        return CGSizeMake(-1, -1);
    }
    
    CGFloat widthInPixel = 0.0;
    CGFloat heightInPixel = 0.0;
    
    CFNumberRef widthNum = CFDictionaryGetValue(imagePropertiesRef, kCGImagePropertyPixelWidth);
    if (widthNum != NULL) {
        CFNumberGetValue(widthNum, kCFNumberCGFloatType, &widthInPixel);
    }
    else {
        widthInPixel = -1;
    }

    CFNumberRef heightNum = CFDictionaryGetValue(imagePropertiesRef, kCGImagePropertyPixelHeight);
    if (heightNum != NULL) {
        CFNumberGetValue(heightNum, kCFNumberCGFloatType, &heightInPixel);
    }
    else {
        heightInPixel = -1;
    }

    scale = scale <= 0 ? [UIScreen mainScreen].scale : scale;
    
    // cleanup
    CF_SAFE_RELEASE(imagePropertiesRef);
    CF_SAFE_RELEASE(imageSourceRef);
    
    CGFloat width = widthInPixel == -1 ? -1 : (widthInPixel / (CGFloat)scale);
    CGFloat height = heightInPixel == -1 ? -1 : (heightInPixel / (CGFloat)scale);
    
    return CGSizeMake(width, height);
}

#pragma mark ::

#pragma mark - Thumbnail Image

+ (nullable UIImage *)thumbnailImageWithPath:(NSString *)path boundingSize:(CGSize)boundingSize scale:(CGFloat)scale {
    return [self thumbnailImageWithData:nil path:path boundingSize:boundingSize scale:scale];
}

+ (nullable UIImage *)thumbnailImageWithData:(NSData *)data boundingSize:(CGSize)boundingSize scale:(CGFloat)scale {
    return [self thumbnailImageWithData:data path:nil boundingSize:boundingSize scale:scale];
}

#pragma mark ::

+ (nullable UIImage *)thumbnailImageWithData:(NSData *)data path:(NSString *)path boundingSize:(CGSize)boundingSize scale:(CGFloat)scale {
    if (boundingSize.width <= 0 || boundingSize.height <= 0) {
        return nil;
    }
    
    if ((![data isKindOfClass:[NSData class]] || data.length == 0) &&
        (![path isKindOfClass:[NSString class]] || path.length == 0)) {
        return nil;
    }
    
    CGImageSourceRef imageSourceRef = NULL;
    NSDictionary *options = @{
        fromCF kCGImageSourceShouldCache: @NO,
    };
    
    if (data) {
        imageSourceRef = CGImageSourceCreateWithData(toCF data, toCF options);
    }
    else {
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            return nil;
        }
        
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        if (!fileURL) {
            return nil;
        }
        
        imageSourceRef = CGImageSourceCreateWithURL(toCF fileURL, toCF options);
    }
    
    if (imageSourceRef == NULL) {
        return nil;
    }
    
    scale = scale <= 0 ? [UIScreen mainScreen].scale : scale;
    CGFloat maxDimensionInPixels = MAX(boundingSize.width, boundingSize.height) * scale;
    
    NSDictionary *downsampledOptions = @{
        fromCF kCGImageSourceCreateThumbnailFromImageAlways: @YES,
        fromCF kCGImageSourceShouldCacheImmediately: @YES,
        fromCF kCGImageSourceThumbnailMaxPixelSize: @(maxDimensionInPixels),
        fromCF kCGImageSourceCreateThumbnailWithTransform: @YES,
    };
    
    CGImageRef downsampledImageRef = CGImageSourceCreateThumbnailAtIndex(imageSourceRef, 0, toCF downsampledOptions);
    
    UIImage *thumbnailImage = [UIImage imageWithCGImage:downsampledImageRef scale:scale orientation:UIImageOrientationUp];
    
    // cleanup
    CF_SAFE_RELEASE(imageSourceRef);
    CF_SAFE_RELEASE(downsampledImageRef);
    
    return thumbnailImage;
}

#pragma mark ::

#pragma mark - Utility

static int GCDOfPair(int a, int b)
{
    if (a < b) {
        return GCDOfPair(b, a);
    }
    while (true) {
        int const r = a % b;
        if (r == 0)
            return b;
        a = b;
        b = r;
    }
}

@end
