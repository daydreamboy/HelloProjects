//
//  WCDeviceTool.h
//  HelloUIDevice
//
//  Created by wesley_chen on 2018/10/10.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCDeviceTool : NSObject

#pragma mark - Software Info

#pragma mark > Memory

/**
 Get available memory on the device

 @return the available memory (MB)
 @see https://gist.github.com/1901/917a0064b125175db95e
 */
+ (double)systemAvailableMemory;

/**
 Get resident memory for the current process/app
 
 @return the resident memory (MB)
 @see https://gist.github.com/1901/917a0064b125175db95e
 */
+ (double)processMemoryResident;

/**
 Get footprint for the current process/app

 @return the footprint memory (MB), which should be same as Xcode's Memory Report
 @see https://forums.developer.apple.com/thread/52186
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

/**
 Get system current language, e.g. `中文（繁體字）`
 
 @see http://stackoverflow.com/questions/6829448/ios-how-to-get-the-device-current-language-setting
 @see http://stackoverflow.com/a/15174562/4794665
 */
+ (NSString *)systemLanguage;

/**
 Get system current language code, e.g. `en`
 */
+ (NSString *)systemLanguageCode;

+ (NSString *)systemUptime;

#pragma mark > System browser

/**
 Get user agent, e.g. Mozilla/5.0 (iPhone; CPU iPhone OS 13_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148
 
 @param block the block to return the user agent
 @discussion iOS 13+, the block is asynchronous and queried by WKWebView; iOS 12-, the block is synchronous and queried by UIWebView,
 */
+ (void)browserUserAgentWithBlock:(void (^)(NSString *userAgent))block;

#pragma mark > Localization

/**
 Country
 */
+ (NSString *)localizationCountry;

/**
 Language
 */
+ (NSString *)localizationLanguage;

/**
 TimeZone
 */
+ (NSString *)localizationTimeZone;

/**
 Currency Symbol
 */
+ (NSString *)localizationCurrency;

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

/**
 Check device is if simulator
 
 @return YES if device is simulator, NO if not
 
 @header #import <sys/utsname.h>
 */
+ (BOOL)deviceIsSimulator;

/**
 Get device platform, e.g. `iPhone`, `iPad`
 */
+ (NSString *)devicePlatformType;

#pragma mark > Processor

/**
 Get the number of processors

 @return the number of processors. Return -1 if failed.
 */
+ (NSInteger)deviceProcessorNumber;

/**
 Get the number of active processors

 @return the number of active processors. Return -1 if failed.
 */
+ (NSInteger)deviceProcessorActiveNumber;

+ (NSUInteger)deviceProcessorFrequency;

#pragma mark > Memory

+ (NSUInteger)deviceRAMSize;

+ (NSUInteger)deviceTotalMemorySize;

#pragma mark > Bus

+ (NSInteger)deviceBusFrequency;

#pragma mark > Screen

/**
 Detect current screen if has notch, e.g. iPhoneX/XR/XS
 
 @return YES if current screen has notch, NO if not
 @see https://medium.com/@cafielo/how-to-detect-notch-screen-in-swift-56271827625d
 */
+ (BOOL)screenHasNotch;

/**
 Get screen size by dp
 */
+ (CGSize)deviceScreenSize;

/**
 Get screen size by px
 */
+ (CGSize)deviceScreenSizeInPixel;

/**
 Get screen scale, e.g. `2.0`
 */
+ (CGFloat)deviceScreenScale;

+ (CGFloat)deviceScreenBrightness;

#pragma mark - Device Battery

+ (BOOL)deviceBatteryMoniteringEnabled;
+ (void)setDeviceBatteryMoniteringEnabled:(BOOL)enabled;

/**
 Get battery state, e.g. `Full`
 
 @warning Always return `Unknown`, when `deviceBatteryMoniteringEnabled` is NO
 */
+ (NSString *)deviceBatteryState;

/**
 Get battery level, e.g. `100%`
 
 @warning Always return `Unknown`, when `deviceBatteryMoniteringEnabled` is NO
 */
+ (NSString *)deviceBatteryLevel;

#pragma mark > Network

+ (BOOL)deviceWiFiEnabled;
+ (NSString *)deviceWiFiAddress;
+ (NSString *)deviceWiFiIPv6Address;

#pragma mark > Identifier

+ (NSString *)deviceIdentifierForVendor;

#pragma mark > Feature

+ (BOOL)deviceJailBroken;

+ (BOOL)deviceMultitaskingEnabled;

+ (BOOL)deviceProximitySensorEnabled;

+ (BOOL)deviceDebuggerAttached;

+ (BOOL)devicePluggedIn;

@end

NS_ASSUME_NONNULL_END
