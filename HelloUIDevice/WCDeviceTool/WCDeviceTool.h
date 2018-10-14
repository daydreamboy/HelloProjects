//
//  WCDeviceTool.h
//  HelloUIDevice
//
//  Created by wesley_chen on 2018/10/10.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCDeviceTool : NSObject

#pragma mark - Memory

+ (double)systemAvailableMemory;
+ (double)processMemoryResident;

/**
 查看内存footprint（基本和Memory Report显示一致）
 
 @return the memory footprint
 
 @note https://forums.developer.apple.com/thread/52186
 */
+ (double)processMemoryFootprint;

#pragma mark - System

/**
 Get all installed apps' bundle IDs
 
 @return the bundle IDs for installed apps
 @see https://stackoverflow.com/a/38345120
 */
+ (NSArray<NSString *> *)allInstalledApps;

@end

NS_ASSUME_NONNULL_END
