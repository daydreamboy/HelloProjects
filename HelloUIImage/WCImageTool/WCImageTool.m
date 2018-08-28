//
//  WCImageTool.m
//  Test
//
//  Created by wesley_chen on 2018/5/4.
//

#import "WCImageTool.h"

@implementation WCImageTool

#pragma mark - Image Generation

+ (UIImage *)imageWithColor:(UIColor *)color {
    // Note: create 1px X 1px size of rect
    return [self imageWithColor:color size:CGSizeMake(1.0 / [UIScreen mainScreen].scale, 1.0 / [UIScreen mainScreen].scale)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    // Note: use UIGraphicsBeginImageContextWithOptions instead of UIGraphicsBeginImageContext to set UIImage.scale
    // @see https://stackoverflow.com/questions/4965036/uigraphicsgetimagefromcurrentimagecontext-retina-resolution
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)drawImage:(UIImage *)image inParentImage:(UIImage *)parentImage placedAt:(CGRect)frame {
    UIGraphicsBeginImageContextWithOptions(parentImage.size, NO, 0.0);
    
    [parentImage drawInRect:CGRectMake(0, 0, parentImage.size.width, parentImage.size.height)];
    [image drawInRect:frame];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    return newImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image alpha:(CGFloat)alpha {
    
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

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
    
    // Avoid redundant drawing
    if (CGSizeEqualToSize(image.size, size)) {
        return image;
    }
    
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - Image Modify

/**
 Get an image with template color
 
 @param templateColor the template color which is a pure color
 @return an image which is a template shadow applied with template color
 */
+ (UIImage *)imageWithImage:(UIImage *)image templateColor:(UIColor *)templateColor {
    UIImage *newImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIGraphicsBeginImageContextWithOptions(newImage.size, NO, newImage.scale);
    [templateColor set];
    [newImage drawInRect:CGRectMake(0, 0, newImage.size.width, newImage.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// @see https://gist.github.com/Shilo/1292152
+ (UIImage *)setImage:(UIImage *)image replaceColorComponents:(CGFloat[6])components toColor:(UIColor *)color {
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

+ (UIImage *)cornerRoundedImageWithImage:(UIImage *)image radius:(CGFloat)radius {
    return [self cornerRoundedImageWithImage:image radius:radius size:image.size];
}

+ (UIImage *)cornerRoundedImageWithImage:(UIImage *)image radius:(CGFloat)radius size:(CGSize)size {
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

@end
