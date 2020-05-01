//
//  WCImageTool.m
//  HelloUILabel
//
//  Created by wesley_chen on 2018/8/7.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCImageTool.h"

@implementation WCImageTool

+ (UIImage *)imageWithColor:(UIColor *)color {
    // Note: create 1px X 1px size of rect
    return [self imageWithColor:color size:CGSizeMake(1.0 / [UIScreen mainScreen].scale, 1.0 / [UIScreen mainScreen].scale)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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

@end
