//
//  WCXCAssetsImageTool.h
//  HelloXCAssets_Example
//
//  Created by wesley_chen on 23/11/2017.
//  Copyright © 2017 daydreamboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WCXCAssetsImageTool : NSObject

/**
 Get image in xcassets folder

 @param name the image name in xcassets folder
 @param resourceBundleName the resource bundel which contains xcassets folder
 @param podName the Pod name (intergated as static libray or framework).
        - @"" stands for main bundle
        - nil statnd for current bundle which this code reside in
 @return the UIImage object. return nil if not found
 */
+ (UIImage *)xcassetsImageNamed:(NSString *)name resourceBundleName:(NSString *)resourceBundleName podName:(NSString *)podName NS_AVAILABLE_IOS(8_0);

@end
