//
//  Manager.h
//  header_dir
//
//  Created by wesley_chen on 10/11/2017.
//

#import <Foundation/Foundation.h>

@interface Manager : NSObject

+ (UIImage *)imageInPod;
+ (UIImage *)imageInResourceBundleOfPod;
+ (UIImage *)imageInMainBundle;
+ (UIImage *)imageInResourceBundleOfMainBundle;

@end
