//
//  WCImageTool.h
//  HelloUILabel
//
//  Created by wesley_chen on 2018/8/7.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WCImageTool : NSObject

@end

@interface WCImageTool ()
/*!
 *  Get an image with pure color
 *
 *  @param color the UIColor
 *
 *  @return a UIImage with {1px, 1px} colored by UIColor
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 Get an image with pure color
 
 @param color the UIColor
 @param size the size
 @return the new image
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)imageWithName:(NSString *)name inResourceBundle:(NSString *)resourceBundleName;

@end
