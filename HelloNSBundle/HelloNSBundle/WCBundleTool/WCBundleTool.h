//
//  WCBundleTool.h
//  HelloNSBundle
//
//  Created by wesley_chen on 10/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCBundleTool : NSObject

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

@end
