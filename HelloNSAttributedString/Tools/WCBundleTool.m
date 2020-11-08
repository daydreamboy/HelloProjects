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
    NSError *errorL = nil;
    BOOL loaded = NO;
    
    NSString *frameworkFolder = [[NSBundle mainBundle] privateFrameworksPath];
    NSString *frameworkPath = [frameworkFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.framework", name]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:frameworkPath]) {
        loaded = NO;
        
        if (error) {
            NSString *errorDescription = [NSString stringWithFormat:@"%@ not exists", frameworkPath];
            *error = [NSError errorWithDomain:@"WCBundleToolError" code:-1 userInfo:@{ NSLocalizedDescriptionKey: errorDescription }];
        }
        
        return loaded;
    }
    
    NSBundle *frameworkBundle = [NSBundle bundleWithPath:frameworkPath];
    loaded = [frameworkBundle loadAndReturnError:&errorL];
    if (error) {
        *error = errorL;
    }
    
    return loaded;
}

+ (NSArray *)allDynamicLibraries {
    // Note: get all paths for images
    unsigned int countOfImages = 0;
    const char **imagePaths = objc_copyImageNames(&countOfImages);
    
    NSMutableArray *imagePathM = [NSMutableArray arrayWithCapacity:countOfImages];

    for (unsigned int i = 0; i < countOfImages; i++) {
        NSString *imagePath = [NSString stringWithUTF8String:imagePaths[i]];
        [imagePathM addObject:imagePath];
    }
    
    return [imagePathM sortedArrayUsingSelector:@selector(localizedCompare:)];
}

#pragma mark - Private Methods

+ (NSMutableDictionary<NSString *, NSArray *> *)imagesDict {
    static NSMutableDictionary *sImagesDict;
    if (!sImagesDict) {
        sImagesDict = [NSMutableDictionary dictionary];
    }
    
    return sImagesDict;
}

#pragma mark - Resource Bundle

+ (nullable NSURL *)URLForResource:(NSString *)resourceName inResourceBundle:(nullable NSString *)bundleName {
    if (bundleName) {
        NSURL *resourceBundleURL;
        if ([bundleName hasSuffix:@".bundle"]) {
            resourceBundleURL = [[NSBundle mainBundle] URLForResource:[bundleName stringByDeletingPathExtension] withExtension:@"bundle"];
        }
        else {
            resourceBundleURL = [[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle"];
        }
        
        if (resourceBundleURL) {
            // Note: pass nil to bundleWithURL: will crash
            return [[NSBundle bundleWithURL:resourceBundleURL] URLForResource:[resourceName stringByDeletingPathExtension] withExtension:[resourceName pathExtension]];
        }
        else {
            NSLog(@"resource bundle %@ not found", bundleName);
            return nil;
        }
    }
    else {
        return [[NSBundle mainBundle] URLForResource:[resourceName stringByDeletingPathExtension] withExtension:[resourceName pathExtension]];
    }
}

+ (nullable NSString *)pathForResource:(NSString *)resourceName inResourceBundle:(nullable NSString *)bundleName {
    if (bundleName) {
        NSString *resourceBundlePath;
        if ([bundleName hasSuffix:@".bundle"]) {
            resourceBundlePath = [[NSBundle mainBundle] pathForResource:[bundleName stringByDeletingPathExtension] ofType:@"bundle"];
        }
        else {
            resourceBundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
        }
        
        if (resourceBundlePath) {
            return [[NSBundle bundleWithPath:resourceBundlePath] pathForResource:[resourceName stringByDeletingPathExtension] ofType:[resourceName pathExtension]];
        }
        else {
            NSLog(@"resource bundle %@ not found", bundleName);
            return nil;
        }
    }
    else {
        return [[NSBundle mainBundle] pathForResource:[resourceName stringByDeletingPathExtension] ofType:[resourceName pathExtension]];
    }
}

@end
