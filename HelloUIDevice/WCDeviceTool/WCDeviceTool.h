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

#pragma mark - Software Info

#pragma mark > Memory

+ (double)systemAvailableMemory;
+ (double)processMemoryResident;

/**
 查看内存footprint（基本和Memory Report显示一致）
 
 @return the memory footprint
 
 @note https://forums.developer.apple.com/thread/52186
 */
+ (double)processMemoryFootprint;

#pragma mark > App

/**
 Get all installed apps' bundle IDs
 
 @return the bundle IDs for installed apps
 @see https://stackoverflow.com/a/38345120
 */
+ (NSArray<NSString *> *)allInstalledApps;

#pragma mark > System

/**
 Get the name of system, e.g. `iOS`
 
 @return a NSSttring
 */
+ (NSString *)systemName;

+ (NSString *)systemVersion;

#pragma mark - Hardware Info

#pragma mark > Model

/**
 Get the name of the device, e.g. see '关于本机' in iPhone

 @return the device name
 */
+ (NSString *)deviceName;

/**
 Get the short model name of the device, e.g. "iPhone", "iPad"

 @return the short model name of the device
 */
+ (NSString *)deviceModel;

/**
 Get the short localized model name of the device, e.g. "iPhone", "iPad"

 @return the short localized model name of the device
 */
+ (NSString *)deviceLocalizedModel;

/**
 Get the long description with the model, system name, system version, e.g. "iPhone 6s, iOS, 11.4"

 @return the long model name of the device
 */
+ (NSString *)deviceDetailedModel;

/**
 Get the model identifier, e.g. "iPhone8,1" .see https://www.theiphonewiki.com/wiki/Models
 or
 Get the well-known model identifier, e.g. "iPhone 6s"

 @param prettyPrinted YES if get the well-known model identifier, NO if get the model identifier
 @return the model identifier, e.g. "iPhone8,1" or "iPhone 6s"
 @see https://github.com/Shmoopi/iOS-System-Services/blob/master/System%20Services/Utilities/SSHardwareInfo.m
 */
+ (NSString *)deviceModelPrettyPrinted:(BOOL)prettyPrinted;

@end

NS_ASSUME_NONNULL_END