//
//  WCURLTool.h
//  HelloNSURL
//
//  Created by wesley_chen on 2018/7/26.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLComponents (parameterString)
@property (nonatomic, copy, nullable) NSString *parameterString;
@end

@interface WCURLTool : NSObject

/**
 Get URL for local png image

 @param imageName the png name without extension and @2x or @3x
 @param resourceBundleName the resource bundle name. If nil, use main bundle
 @return the NSURL for the png image
 */
+ (nullable NSURL *)PNGImageURLWithImageName:(NSString *)imageName inResourceBundle:(NSString *)resourceBundleName;
+ (nullable NSURLComponents *)URLComponentsWithUrlString:(NSString *)urlString;

@end

NS_ASSUME_NONNULL_END
