//
//  WCBundleTool.h
//  HelloNSBundle
//
//  Created by wesley_chen on 10/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCBundleTool : NSObject

#pragma mark - Binary Bundle

+ (NSArray *)classNamesWithMainBundleImage;
+ (NSArray *)classNamesWithFrameworkImage:(NSString *)frameworkName;
+ (NSArray *)classNamesWithBinaryImagePath:(NSString *)binaryImagePath;

/**
 Load framework manually

 @param name the name of framework
 @param error the NSError
 @return the status of loaded success or failure
 */
+ (BOOL)loadFrameworkWithName:(NSString *)name error:(NSError **)error;

+ (NSArray *)allDynamicLibraries;

#pragma mark - Resource Bundle

/**
 Get the URL for resource file, e.g. plist, png

 @param resourceName the resource file with extension
 @param bundleName the resource bundle, e.g @"images" or @"images.bundle". And nil for main bundle
 @return the URL for the resource file. Return nil if the resource file not found or the resource bundle not found.
 */
+ (nullable NSURL *)URLForResource:(NSString *)resourceName inResourceBundle:(nullable NSString *)bundleName;

/**
 Get the Path for resource file, e.g. plist, png

 @param resourceName the resource file with extension
 @param bundleName the resource bundle, e.g @"images" or @"images.bundle". And nil for main bundle
 @return the Path for the resource file. Return nil if the resource file not found or the resource bundle not found.
 */
+ (nullable NSString *)pathForResource:(NSString *)resourceName inResourceBundle:(nullable NSString *)bundleName;

@end

NS_ASSUME_NONNULL_END
