//
//  WCBundleTool.m
//  HelloNSBundle
//
//  Created by wesley_chen on 10/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCBundleTool.h"
#import <objc/runtime.h>

@implementation WCBundleTool

+ (NSArray *)classNamesWithMainBundleImage {
    return [self classNamesWithBinaryImagePath:[[NSBundle mainBundle] executablePath]];
}

+ (NSArray *)classNamesWithFrameworkImage:(NSString *)frameworkName {
    
    NSString *frameworkImagePath = nil;
    
    // Note: get all paths for images
    unsigned int countOfImages = 0;
    const char **imagePaths = objc_copyImageNames(&countOfImages);
    for (unsigned int i = 0; i < countOfImages; i++) {
        NSString *imagePath = [NSString stringWithUTF8String:imagePaths[i]];
        if ([imagePath rangeOfString:[NSString stringWithFormat:@"%@.framework", frameworkName]].location != NSNotFound) {
            frameworkImagePath = imagePath;
            break;
        }
    }
    
    if (frameworkImagePath.length) {
        return [self classNamesWithBinaryImagePath:frameworkImagePath];
    }
    else {
        return nil;
    }
}

+ (NSArray *)classNamesWithBinaryImagePath:(NSString *)binaryImagePath {
    
    NSMutableDictionary *dict = [self imagesDict];
    if (dict[binaryImagePath]) {
        return dict[binaryImagePath];
    }
    
    NSMutableArray *classNames = [NSMutableArray array];
    unsigned int count = 0;
    const char ** classes = objc_copyClassNamesForImage([binaryImagePath UTF8String], &count);
    for (unsigned int i = 0; i < count; i++){
        NSString *className = [NSString stringWithUTF8String:classes[i]];
        [classNames addObject:className];
    }
    
    dict[binaryImagePath] = [classNames copy];
    
    return [classNames copy];
}

+ (BOOL)loadFrameworkWithName:(NSString *)name error:(NSError **)error {
    NSString *frameworkFolder = [[NSBundle mainBundle] privateFrameworksPath];
    NSString *frameworkPath = [frameworkFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.framework", name]];
    NSBundle *frameworkBundle = [NSBundle bundleWithPath:frameworkPath];
    NSError *errorL = nil;
    BOOL loaded = [frameworkBundle loadAndReturnError:&errorL];
    if (error) {
        *error = errorL;
    }
    
    return loaded;
}

+ (NSMutableDictionary<NSString *, NSArray *> *)imagesDict {
    static NSMutableDictionary *sImagesDict;
    if (!sImagesDict) {
        sImagesDict = [NSMutableDictionary dictionary];
    }
    
    return sImagesDict;
}

@end
