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

+ (UIImage *)xcassetsImageNamed:(NSString *)name resourceBundleName:(NSString *)resourceBundleName podName:(NSString *)podName;

@end
