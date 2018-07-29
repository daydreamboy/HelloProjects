//
//  WCURLTool.m
//  HelloNSURL
//
//  Created by wesley_chen on 2018/7/26.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCURLTool.h"
#import <UIKit/UIKit.h>

@implementation WCURLTool

+ (NSURL *)PNGImageURLWithImageName:(NSString *)imageName inResourceBundle:(NSString *)resourceBundleName {
    if (![imageName isKindOfClass:[NSString class]] || ![resourceBundleName isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSBundle *resourceBundle;
    NSString *resourceBundlePath;
    if (resourceBundleName) {
        resourceBundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:resourceBundleName];
        resourceBundle = [NSBundle bundleWithPath:resourceBundlePath];
    }
    else {
        resourceBundle = [NSBundle mainBundle];
        resourceBundlePath = [[NSBundle mainBundle] bundlePath];
    }
    
    NSArray *imageNames = @[
                            // image@2x.png
                            [NSString stringWithFormat:@"%@@%dx.png", imageName, (int)[UIScreen mainScreen].scale],
                            // iamge@2x.PNG
                            [NSString stringWithFormat:@"%@@%dx.PNG", imageName, (int)[UIScreen mainScreen].scale],
                            // image@2X.png
                            [NSString stringWithFormat:@"%@@%dX.png", imageName, (int)[UIScreen mainScreen].scale],
                            // image@2X.PNG
                            [NSString stringWithFormat:@"%@@%dX.png", imageName, (int)[UIScreen mainScreen].scale],
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

@end
