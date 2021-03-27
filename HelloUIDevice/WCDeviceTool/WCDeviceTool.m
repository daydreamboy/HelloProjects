//
//  WCDeviceTool.m
//  HelloUIDevice
//
//  Created by wesley_chen on 2018/10/10.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCDeviceTool.h"

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <sys/sysctl.h>
#import <sys/utsname.h>
#import <mach/mach.h>
#import <objc/runtime.h>

// For Network
#import <net/if.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <net/if_dl.h>

// >= `13.0`
#ifndef IOS13_OR_LATER
#define IOS13_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"13.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@implementation WCDeviceTool

#pragma mark - Software Info

#pragma mark > Memory

+ (double)systemAvailableMemory {
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

+ (double)processMemoryResident {
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

+ (double)processMemoryFootprint {
    task_vm_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_VM_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_VM_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return taskInfo.phys_footprint / 1024.0 / 1024.0;
}

#pragma mark > App

+ (NSArray<NSString *> *)allInstalledApps {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject *workspace = [LSApplicationWorkspace_class performSelector:NSSelectorFromString(@"defaultWorkspace")];
    NSArray<NSObject *> *LSApplicationProxy_objects = [workspace performSelector:NSSelectorFromString(@"allApplications")];
    NSMutableArray *arrM = [NSMutableArray array];
    for (id object in LSApplicationProxy_objects) {
        id retVal = [object performSelector:NSSelectorFromString(@"applicationIdentifier")];
        if (retVal) {
            [arrM addObject:retVal];
        }
    }
    return arrM;
#pragma GCC diagnostic pop
}

#pragma mark > System

+ (NSString *)systemName {
    NSString *name = [[UIDevice currentDevice] systemName];
    return name ?: @"Unknown";
}

+ (NSString *)systemVersion {
    NSString *version = [[UIDevice currentDevice] systemVersion];
    return version ?: @"Unknown";
}

+ (NSString *)systemLanguage {
    NSString *langCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *langString = [[NSLocale currentLocale] displayNameForKey:NSLocaleIdentifier value:langCode];
    
    return langString;
}

+ (NSString *)systemLanguageCode {
    NSString *langCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    return langCode;
}

// System Uptime (dd hh mm)
+ (NSString *)systemUptime {
    // Set up the days/hours/minutes
    NSNumber *Days, *Hours, *Minutes;
    
    // Get the info about a process
    NSProcessInfo * processInfo = [NSProcessInfo processInfo];
    // Get the uptime of the system
    NSTimeInterval UptimeInterval = [processInfo systemUptime];
    // Get the calendar
    NSCalendar *Calendar = [NSCalendar currentCalendar];
    // Create the Dates
    NSDate *Date = [[NSDate alloc] initWithTimeIntervalSinceNow:(0-UptimeInterval)];
    unsigned int unitFlags = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *Components = [Calendar components:unitFlags fromDate:Date toDate:[NSDate date]  options:0];
    
    // Get the day, hour and minutes
    Days = [NSNumber numberWithLong:[Components day]];
    Hours = [NSNumber numberWithLong:[Components hour]];
    Minutes = [NSNumber numberWithLong:[Components minute]];
    
    // Format the dates
    NSString *Uptime = [NSString stringWithFormat:@"%@ %@ %@",
                        [Days stringValue],
                        [Hours stringValue],
                        [Minutes stringValue]];
    
    // Error checking
    if (!Uptime) {
        // No uptime found
        // Return nil
        return nil;
    }
    
    // Return the uptime
    return Uptime;
}

#pragma mark > System browser

+ (void)browserUserAgentWithBlock:(void (^)(NSString *userAgent))block {
    if (IOS13_OR_LATER) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height) configuration:configuration];
        [webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if ([result isKindOfClass:[NSString class]] && ((NSString *)result).length > 0) {
            // Note: create a variable to hold `webView` strongly if `webView` is
            // a local object release after call this method
            // @see https://forums.developer.apple.com/thread/123128
            __unused WKWebView *webViewL = webView;
            !block ?: block(result);
        }
        else {
            !block ?: block(@"Unknown");
        }
    }];
    }
    else {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        
        !block ?: block(userAgent ?: @"Unknown");
    }
}

#pragma mark > Localization

// Country
+ (NSString *)localizationCountry {
    // Get the user's country
    @try {
        // Get the locale
        NSLocale *Locale = [NSLocale currentLocale];
        // Get the country from the locale
        NSString *Country = [Locale localeIdentifier];
        // Check for validity
        if (Country == nil || Country.length <= 0) {
            // Error, invalid country
            return nil;
        }
        // Completed Successfully
        return Country;
    }
    @catch (NSException *exception) {
        // Error
        return nil;
    }
}

// Language
+ (NSString *)localizationLanguage {
    // Get the user's language
    @try {
        // Get the list of languages
        NSArray *languageArray = [NSLocale preferredLanguages];
        // Get the user's language
        NSString *language = [languageArray objectAtIndex:0];
        // Check for validity
        if (language == nil || language.length <= 0) {
            // Error, invalid language
            return nil;
        }
        // Completed Successfully
        return language;
    }
    @catch (NSException *exception) {
        // Error
        return nil;
    }
}

// TimeZone
+ (NSString *)localizationTimeZone {
    // Get the user's timezone
    @try {
        // Get the system timezone
        NSTimeZone *localTime = [NSTimeZone systemTimeZone];
        // Convert the time zone to a string
        NSString *timeZone = [localTime name];
        // Check for validity
        if (timeZone == nil || timeZone.length <= 0) {
            // Error, invalid TimeZone
            return nil;
        }
        // Completed Successfully
        return timeZone;
    }
    @catch (NSException *exception) {
        // Error
        return nil;
    }
}

// Currency Symbol
+ (NSString *)localizationCurrency {
    // Get the user's currency
    @try {
        // Get the system currency
        NSString *Currency = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
        // Check for validity
        if (Currency == nil || Currency.length <= 0) {
            // Error, invalid Currency
            return nil;
        }
        // Completed Successfully
        return Currency;
    }
    @catch (NSException *exception) {
        // Error
        return nil;
    }
}

#pragma mark - Hardware Info

#pragma mark > Model

+ (NSString *)deviceName {
    NSString *name = [[UIDevice currentDevice] name];
    return name ?: @"Unknown";
}

+ (NSString *)deviceModel {
    NSString *model = [[UIDevice currentDevice] model];
    return model ?: @"Unknown";
}

+ (NSString *)deviceLocalizedModel {
    NSString *model = [[UIDevice currentDevice] localizedModel];
    return model ?: @"Unknown";
}

+ (NSString *)deviceDetailedModel {
    return [NSString stringWithFormat:@"%@, %@, %@", [WCDeviceTool deviceModelPrettyPrinted:YES], [WCDeviceTool systemName], [WCDeviceTool systemVersion]];
}

+ (NSString *)deviceModelPrettyPrinted:(BOOL)prettyPrinted {
    NSString *deviceType;
    
    if (prettyPrinted) {
        @try {
            // Set up a struct
            struct utsname dt;
            // Get the system information
            uname(&dt);
            // Set the device type to the machine type
            deviceType = [NSString stringWithFormat:@"%s", dt.machine];
            
            // Note: set up a new Device Type String. By default, it's unknown
            NSString *newDeviceType = [NSString stringWithFormat:@"%@ Unknown (%@)", [[UIDevice currentDevice] model], deviceType];
            
            // Simulators
            if ([deviceType isEqualToString:@"i386"])
                newDeviceType = [NSString stringWithFormat:@"%@ Simulator", [[UIDevice currentDevice] model]];
            else if ([deviceType isEqualToString:@"x86_64"])
                newDeviceType = [NSString stringWithFormat:@"%@ Simulator", [[UIDevice currentDevice] model]];
            // iPhones
            else if ([deviceType isEqualToString:@"iPhone1,1"])
                newDeviceType = @"iPhone";
            else if ([deviceType isEqualToString:@"iPhone1,2"])
                newDeviceType = @"iPhone 3G";
            else if ([deviceType isEqualToString:@"iPhone2,1"])
                newDeviceType = @"iPhone 3GS";
            else if ([deviceType isEqualToString:@"iPhone3,1"])
                newDeviceType = @"iPhone 4";
            else if ([deviceType isEqualToString:@"iPhone4,1"])
                newDeviceType = @"iPhone 4S";
            else if ([deviceType isEqualToString:@"iPhone5,1"])
                newDeviceType = @"iPhone 5 (GSM)";
            else if ([deviceType isEqualToString:@"iPhone5,2"])
                newDeviceType = @"iPhone 5 (GSM+CDMA)";
            else if ([deviceType isEqualToString:@"iPhone5,3"])
                newDeviceType = @"iPhone 5c (GSM)";
            else if ([deviceType isEqualToString:@"iPhone5,4"])
                newDeviceType = @"iPhone 5c (GSM+CDMA)";
            else if ([deviceType isEqualToString:@"iPhone6,1"])
                newDeviceType = @"iPhone 5s (GSM)";
            else if ([deviceType isEqualToString:@"iPhone6,2"])
                newDeviceType = @"iPhone 5s (GSM+CDMA)";
            else if ([deviceType isEqualToString:@"iPhone7,1"])
                newDeviceType = @"iPhone 6 Plus";
            else if ([deviceType isEqualToString:@"iPhone7,2"])
                newDeviceType = @"iPhone 6";
            else if ([deviceType isEqualToString:@"iPhone8,1"])
                newDeviceType = @"iPhone 6s";
            else if ([deviceType isEqualToString:@"iPhone8,2"])
                newDeviceType = @"iPhone 6s Plus";
            else if ([deviceType isEqualToString:@"iPhone8,4"])
                newDeviceType = @"iPhone SE";
            else if ([deviceType isEqualToString:@"iPhone9,1"])
                newDeviceType = @"iPhone 7 (CDMA+GSM/LTE)";
            else if ([deviceType isEqualToString:@"iPhone9,3"])
                newDeviceType = @"iPhone 7 (GSM/LTE)";
            else if ([deviceType isEqualToString:@"iPhone9,2"])
                newDeviceType = @"iPhone 7 Plus (CDMA+GSM/LTE)";
            else if ([deviceType isEqualToString:@"iPhone9,4"])
                newDeviceType = @"iPhone 7 Plus (GSM/LTE)";
            else if ([deviceType isEqualToString:@"iPhone10,1"])
                newDeviceType = @"iPhone 8 (CDMA+GSM/LTE)";
            else if ([deviceType isEqualToString:@"iPhone10,4"])
                newDeviceType = @"iPhone 8 (GSM/LTE)";
            else if ([deviceType isEqualToString:@"iPhone10,2"])
                newDeviceType = @"iPhone 8 Plus (CDMA+GSM/LTE)";
            else if ([deviceType isEqualToString:@"iPhone10,5"])
                newDeviceType = @"iPhone 8 Plus (GSM/LTE)";
            else if ([deviceType isEqualToString:@"iPhone10,3"])
                newDeviceType = @"iPhone X (CDMA+GSM/LTE)";
            else if ([deviceType isEqualToString:@"iPhone10,6"])
                newDeviceType = @"iPhone X (GSM/LTE)";
            // @see https://stackoverflow.com/a/52485185
            else if ([deviceType isEqualToString:@"iPhone11,2"])
                newDeviceType = @"iPhone XS";
            else if ([deviceType isEqualToString:@"iPhone11,4"])
                newDeviceType = @"iPhone XS Max (Global)";
            else if ([deviceType isEqualToString:@"iPhone11,6"])
                newDeviceType = @"iPhone XS Max (China)";
            else if ([deviceType isEqualToString:@"iPhone11,8"])
                newDeviceType = @"iPhone XR";
            // @see https://gist.github.com/adamawolf/3048717
            else if ([deviceType isEqualToString:@"iPhone12,1"])
                newDeviceType = @"iPhone 11";
            else if ([deviceType isEqualToString:@"iPhone12,3"])
                newDeviceType = @"iPhone 11 Pro";
            else if ([deviceType isEqualToString:@"iPhone12,5"])
                newDeviceType = @"iPhone 11 Pro Max";
            else if ([deviceType isEqualToString:@"iPhone12,8"])
                newDeviceType = @"iPhone SE 2nd Gen";
            else if ([deviceType isEqualToString:@"iPhone13,1"])
                newDeviceType = @"iPhone 12 Mini";
            else if ([deviceType isEqualToString:@"iPhone13,2"])
                newDeviceType = @"iPhone 12";
            else if ([deviceType isEqualToString:@"iPhone13,3"])
                newDeviceType = @"iPhone 12 Pro";
            else if ([deviceType isEqualToString:@"iPhone13,4"])
                newDeviceType = @"iPhone 12 Pro Max";
            // iPods
            else if ([deviceType isEqualToString:@"iPod1,1"])
                newDeviceType = @"iPod Touch 1G";
            else if ([deviceType isEqualToString:@"iPod2,1"])
                newDeviceType = @"iPod Touch 2G";
            else if ([deviceType isEqualToString:@"iPod3,1"])
                newDeviceType = @"iPod Touch 3G";
            else if ([deviceType isEqualToString:@"iPod4,1"])
                newDeviceType = @"iPod Touch 4G";
            else if ([deviceType isEqualToString:@"iPod5,1"])
                newDeviceType = @"iPod Touch 5G";
            else if ([deviceType isEqualToString:@"iPod7,1"])
                newDeviceType = @"iPod Touch 6G";
            else if ([deviceType isEqualToString:@"iPod9,1"])
                newDeviceType = @"iPod Touch 7G";
            // iPads
            else if ([deviceType isEqualToString:@"iPad1,1"])
                newDeviceType = @"iPad";
            else if ([deviceType isEqualToString:@"iPad1,2"])
                newDeviceType = @"iPad 3G";
            else if ([deviceType isEqualToString:@"iPad2,1"])
                newDeviceType = @"iPad 2 (WiFi)";
            else if ([deviceType isEqualToString:@"iPad2,2"])
                newDeviceType = @"iPad 2 (GSM)";
            else if ([deviceType isEqualToString:@"iPad2,3"])
                newDeviceType = @"iPad 2 (CDMA)";
            else if ([deviceType isEqualToString:@"iPad2,4"])
                newDeviceType = @"iPad 2 (WiFi + New Chip)";
            else if ([deviceType isEqualToString:@"iPad2,5"])
                newDeviceType = @"iPad mini (WiFi)";
            else if ([deviceType isEqualToString:@"iPad2,6"])
                newDeviceType = @"iPad mini (GSM)";
            else if ([deviceType isEqualToString:@"iPad2,7"])
                newDeviceType = @"iPad mini (GSM+CDMA)";
            else if ([deviceType isEqualToString:@"iPad3,1"])
                newDeviceType = @"iPad 3 (WiFi)";
            else if ([deviceType isEqualToString:@"iPad3,2"])
                newDeviceType = @"iPad 3 (GSM)";
            else if ([deviceType isEqualToString:@"iPad3,3"])
                newDeviceType = @"iPad 3 (GSM+CDMA)";
            else if ([deviceType isEqualToString:@"iPad3,4"])
                newDeviceType = @"iPad 4 (WiFi)";
            else if ([deviceType isEqualToString:@"iPad3,5"])
                newDeviceType = @"iPad 4 (GSM)";
            else if ([deviceType isEqualToString:@"iPad3,6"])
                newDeviceType = @"iPad 4 (GSM+CDMA)";
            else if ([deviceType isEqualToString:@"iPad4,1"])
                newDeviceType = @"iPad Air (WiFi)";
            else if ([deviceType isEqualToString:@"iPad4,2"])
                newDeviceType = @"iPad Air (Cellular)";
            else if ([deviceType isEqualToString:@"iPad4,3"])
                newDeviceType = @"iPad Air (China)";
            else if ([deviceType isEqualToString:@"iPad4,4"])
                newDeviceType = @"iPad mini 2 (WiFi)";
            else if ([deviceType isEqualToString:@"iPad4,5"])
                newDeviceType = @"iPad mini 2 (Cellular)";
            else if ([deviceType isEqualToString:@"iPad5,1"])
                newDeviceType = @"iPad mini 4 (WiFi)";
            else if ([deviceType isEqualToString:@"iPad5,2"])
                newDeviceType = @"iPad mini 4 (Cellular)";
            else if ([deviceType isEqualToString:@"iPad5,4"])
                newDeviceType = @"iPad Air 2 (WiFi)";
            else if ([deviceType isEqualToString:@"iPad5,5"])
                newDeviceType = @"iPad Air 2 (Cellular)";
            else if ([deviceType isEqualToString:@"iPad6,3"])
                newDeviceType = @"9.7-inch iPad Pro (WiFi)";
            else if ([deviceType isEqualToString:@"iPad6,4"])
                newDeviceType = @"9.7-inch iPad Pro (Cellular)";
            else if ([deviceType isEqualToString:@"iPad6,7"])
                newDeviceType = @"12.9-inch iPad Pro (WiFi)";
            else if ([deviceType isEqualToString:@"iPad6,8"])
                newDeviceType = @"12.9-inch iPad Pro (Cellular)";
            else if ([deviceType isEqualToString:@"iPad6,11"])
                newDeviceType = @"iPad 5 (WiFi)";
            else if ([deviceType isEqualToString:@"iPad6,12"])
                newDeviceType = @"iPad 5 (Cellular)";
            else if ([deviceType isEqualToString:@"iPad7,1"])
                newDeviceType = @"iPad Pro 12.9 (2nd Gen - WiFi)";
            else if ([deviceType isEqualToString:@"iPad7,2"])
                newDeviceType = @"iPad Pro 12.9 (2nd Gen - Cellular)";
            else if ([deviceType isEqualToString:@"iPad7,3"])
                newDeviceType = @"iPad Pro 10.5 (WiFi)";
            else if ([deviceType isEqualToString:@"iPad7,4"])
                newDeviceType = @"iPad Pro 10.5 (Cellular)";
            // Catch All iPad
            else if ([deviceType hasPrefix:@"iPad"])
                newDeviceType = @"iPad";
            // Apple TV
            else if ([deviceType isEqualToString:@"AppleTV2,1"])
                newDeviceType = @"Apple TV 2";
            else if ([deviceType isEqualToString:@"AppleTV3,1"])
                newDeviceType = @"Apple TV 3";
            else if ([deviceType isEqualToString:@"AppleTV3,2"])
                newDeviceType = @"Apple TV 3 (2013)";
            
            // Return the new device type
            return newDeviceType;
        }
        @catch (NSException *exception) {
            // Error
            return @"Unknown";
        }
    }
    else {
        // Unformatted
        @try {
            // Set up a struct
            struct utsname dt;
            // Get the system information
            uname(&dt);
            // Set the device type to the machine type
            deviceType = [NSString stringWithFormat:@"%s", dt.machine];
            
            // Return the device type
            return deviceType;
        }
        @catch (NSException *exception) {
            // Error
            return @"Unknown";
        }
    }
}

+ (BOOL)deviceIsSimulator {
    // Set up a struct
    struct utsname dt;
    // Get the system information
    uname(&dt);
    // Set the device type to the machine type
    NSString *deviceType = [NSString stringWithFormat:@"%s", dt.machine];
    
    // Simulators
    if ([deviceType isEqualToString:@"i386"] || [deviceType isEqualToString:@"x86_64"]) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (NSString *)devicePlatformType {
    UIUserInterfaceIdiom idiom = [[UIDevice currentDevice] userInterfaceIdiom];
    switch (idiom) {
        case UIUserInterfaceIdiomPhone: {
            return @"iPhone";
        }
        case UIUserInterfaceIdiomPad: {
            return @"iPad";
        }
        case UIUserInterfaceIdiomTV: {
            return @"TV";
        }
        case UIUserInterfaceIdiomCarPlay: {
            return @"CarPlay";
        }
        case UIUserInterfaceIdiomUnspecified:
        default: {
            return @"Unknown";
        }
    }
}

#pragma mark > Processor

+ (NSInteger)deviceProcessorNumber {
    // See if the process info responds to selector
    if ([[NSProcessInfo processInfo] respondsToSelector:@selector(processorCount)]) {
        // Get the number of processors
        NSInteger processorCount = [[NSProcessInfo processInfo] processorCount];
        // Return the number of processors
        return processorCount;
    }
    else {
        return [self getSysInfo:HW_NCPU];
    }
}

+ (NSInteger)deviceProcessorActiveNumber {
    // See if the process info responds to selector
    if ([[NSProcessInfo processInfo] respondsToSelector:@selector(activeProcessorCount)]) {
        // Get the number of active processors
        NSInteger activeprocessorCount = [[NSProcessInfo processInfo] activeProcessorCount];
        // Return the number of active processors
        return activeprocessorCount;
    }
    else {
        // Return -1 (not found)
        return -1;
    }
}

+ (NSUInteger)deviceProcessorFrequency {
    // Try to get the processor speed
    @try {
        // Set the variables
        int hertz;
        size_t size = sizeof(int);
        int mib[2] = {CTL_HW, HW_CPU_FREQ};
        
        // Find the speed
        sysctl(mib, 2, &hertz, &size, NULL, 0);
        
        // Make sure it's not less than 0
        if (hertz < 1) {
            // Invalid value
            return -1;
        }
        
        // Divide the final speed by 1 million to get the speed in mhz
        hertz /= 1000000;
        
        // Return the result
        return hertz;
    }
    @catch (NSException * ex) {
        // Unable to get the speed (return -1)
        return -1;
    }
}

#pragma mark > Memory

+ (NSUInteger)deviceRAMSize {
    return [self getSysInfo:HW_MEMSIZE];
}

+ (NSUInteger)deviceTotalMemorySize {
    return [self getSysInfo:HW_PHYSMEM];
}

#pragma mark > Disk

+ (unsigned long long)deviceDiskTotalSize {
    NSError *error = nil;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    unsigned long long size = [[attributes objectForKey:NSFileSystemSize] unsignedLongLongValue];
    
    return size;
}

+ (unsigned long long)deviceDiskFreeSize {
    NSError *error = nil;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    unsigned long long size = [[attributes objectForKey:NSFileSystemFreeSize] unsignedLongLongValue];
    
    return size;
}

+ (unsigned long long)deviceDiskUsedSize {
    NSError *error = nil;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    unsigned long long size = [[attributes objectForKey:NSFileSystemSize] unsignedLongLongValue] - [[attributes objectForKey:NSFileSystemFreeSize] unsignedLongLongValue];
    
    return size;
}

#pragma mark > Bus

+ (NSInteger)deviceBusFrequency {
    // Try to get the processor bus speed
    @try {
        // Set the variables
        size_t lengthOfMib;
        int mib[2];
        int final;
        
        // Find the speeds
        // @see https://docs.huihoo.com/darwin/kernel-programming-guide/boundaries/chapter_14_section_7.html
        mib[0] = CTL_HW;
        mib[1] = HW_BUS_FREQ;
        lengthOfMib = sizeof(final);
        
        // Get the actual speed
        sysctl(mib, 2, &final, &lengthOfMib, NULL, 0);
        if (final > 0)
            final /= 1000000;
        else
            return -1;
        
        // Return the result
        return final;
    }
    @catch (NSException * ex) {
        // Unable to get the speed (return -1)
        return -1;
    }
}

#pragma mark ::

+ (NSUInteger)getSysInfo:(uint)typeSpecifier {
    size_t size = sizeof(int);
    int result;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &result, &size, NULL, 0);
    return (NSUInteger)result;
}

#pragma mark ::

#pragma mark > Screen

+ (BOOL)screenHasNotch {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    if ([keyWindow respondsToSelector:@selector(safeAreaInsets)]) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
        return keyWindow.safeAreaInsets.bottom > 0 ? YES : NO;
#pragma GCC diagnostic pop
    }
    else {
        return NO;
    }
}

+ (CGSize)deviceScreenSize {
    return [[UIScreen mainScreen] bounds].size;
}

+ (CGSize)deviceScreenSizeInPixel {
    CGSize size = [[UIScreen mainScreen] bounds].size;
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGSize sizeByPixel = CGSizeMake(size.width * scale, size.height * scale);
    return sizeByPixel;
}

+ (CGFloat)deviceScreenScale {
    return [UIScreen mainScreen].scale;
}

+ (CGFloat)deviceScreenBrightness {
    // Get the screen brightness
    @try {
        // Brightness
        CGFloat brightness = [UIScreen mainScreen].brightness;
        // Verify validity
        if (brightness < 0.0 || brightness > 1.0) {
            // Invalid brightness
            return -1;
        }
        
        // Successful
        return (brightness * 100);
    }
    @catch (NSException *exception) {
        // Error
        return -1;
    }
}

#pragma mark > Battery

+ (BOOL)deviceBatteryMoniteringEnabled {
    return [[UIDevice currentDevice] isBatteryMonitoringEnabled];
}

+ (void)setDeviceBatteryMoniteringEnabled:(BOOL)enabled {
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:enabled];
}

+ (NSString *)deviceBatteryState {
    UIDeviceBatteryState state = [[UIDevice currentDevice] batteryState];
    
    switch (state) {
        case UIDeviceBatteryStateUnplugged: {
            return NSLocalizedString(@"Unplugged", nil);
        }
        case UIDeviceBatteryStateCharging: {
            return NSLocalizedString(@"Charging", nil);
        }
        case UIDeviceBatteryStateFull: {
            return NSLocalizedString(@"Full", nil);
        }
        case UIDeviceBatteryStateUnknown:
        default: {
            return NSLocalizedString(@"Unknown", nil);
        }
    }
}

+ (NSString *)deviceBatteryLevel {
    NSString *level = @"Unknown";
    if ([[UIDevice currentDevice] isBatteryMonitoringEnabled]) {
        level = [NSString stringWithFormat:@"%2.0f%%", [[UIDevice currentDevice] batteryLevel] * 100];
    }
    return level;
}

#pragma mark > Network

+ (BOOL)deviceWiFiEnabled {
    NSCountedSet * cset = [NSCountedSet new];
    
    struct ifaddrs *interfaces;
    
    if (!getifaddrs(&interfaces)) {
        for (struct ifaddrs *interface = interfaces; interface; interface = interface->ifa_next) {
            if ( (interface->ifa_flags & IFF_UP) == IFF_UP ) {
                if (interfaces->ifa_name) {
                    NSString *ifaName = [NSString stringWithUTF8String:interface->ifa_name];
                    if (ifaName) {
                        [cset addObject:ifaName];
                    }
                }
            }
        }
        freeifaddrs(interfaces);
    }
    
    BOOL ret = [cset countForObject:@"awdl0"] > 1 ? YES : NO;
    return ret;
}

+ (NSString *)deviceWiFiAddress {
    // Get the WiFi IP Address
    @try {
        // Set a string for the address
        NSString *IPAddress;
        // Set up structs to hold the interfaces and the temporary address
        struct ifaddrs *interfaces;
        struct ifaddrs *temp;
        // Set up int for success or fail
        int status = 0;
        
        // Get all the network interfaces
        status = getifaddrs(&interfaces);
        
        // If it's 0, then it's good
        if (status == 0) {
            // Loop through the list of interfaces
            temp = interfaces;
            
            // Run through it while it's still available
            while (temp != NULL) {
                // If the temp interface is a valid interface
                if (temp -> ifa_addr -> sa_family == AF_INET) {
                    // Check if the interface is WiFi
                    if ([[NSString stringWithUTF8String:temp -> ifa_name] isEqualToString:@"en0"]) {
                        // Get the WiFi IP Address
                        IPAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp -> ifa_addr) -> sin_addr)];
                    }
                }
                
                // Set the temp value to the next interface
                temp = temp -> ifa_next;
            }
        }
        
        // Free the memory of the interfaces
        freeifaddrs(interfaces);
        
        // Check to make sure it's not empty
        if (IPAddress == nil || IPAddress.length <= 0) {
            // Empty, return not found
            return nil;
        }
        
        // Return the IP Address of the WiFi
        return IPAddress;
        
    }
    @catch (NSException *exception) {
        // Error, IP Not found
        return nil;
    }
}

+ (NSString *)deviceWiFiIPv6Address {
    // Get the WiFi IP Address
    @try {
        // Set a string for the address
        NSString *IPAddress;
        // Set up structs to hold the interfaces and the temporary address
        struct ifaddrs *interfaces;
        struct ifaddrs *temp;
        // Set up int for success or fail
        int status = 0;
        
        // Get all the network interfaces
        status = getifaddrs(&interfaces);
        
        // If it's 0, then it's good
        if (status == 0) {
            // Loop through the list of interfaces
            temp = interfaces;
            
            // Run through it while it's still available
            while (temp != NULL) {
                // If the temp interface is a valid interface
                if (temp -> ifa_addr -> sa_family == AF_INET6) {
                    // Check if the interface is WiFi
                    if ([[NSString stringWithUTF8String:temp -> ifa_name] isEqualToString:@"en0"]) {
                        // Get the WiFi IP Address
                        struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)temp -> ifa_addr;
                        char buf[INET6_ADDRSTRLEN];
                        if (inet_ntop(AF_INET6, (void *)&(addr6 -> sin6_addr), buf, sizeof(buf)) == NULL) {
                            // Failed to find it
                            IPAddress = nil;
                        }
                        else {
                            // Got the Cell IP Address
                            IPAddress = [NSString stringWithUTF8String:buf];
                        }
                    }
                }
                
                // Set the temp value to the next interface
                temp = temp -> ifa_next;
            }
        }
        
        // Free the memory of the interfaces
        freeifaddrs(interfaces);
        
        // Check to make sure it's not empty
        if (IPAddress == nil || IPAddress.length <= 0) {
            // Empty, return not found
            return nil;
        }
        
        // Return the IP Address of the WiFi
        return IPAddress;
        
    }
    @catch (NSException *exception) {
        // Error, IP Not found
        return nil;
    }
}

#pragma mark > Identifier

+ (NSString *)deviceIdentifierForVendor {
    return [[UIDevice currentDevice] identifierForVendor].UUIDString;
}

#pragma mark > Feature

/*
 *  Check device jaikbreak
 *
 *  @see http://stackoverflow.com/a/26712383/4794665
 */
+ (BOOL)deviceJailBroken {
    NSArray *jailbreak_tool_pathes = @[
                                       @"/Applications/Cydia.app",
                                       @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                                       @"/bin/bash",
                                       @"/usr/sbin/sshd",
                                       @"/etc/apt"
                                       ];
    
    for (NSUInteger i = 0; i < jailbreak_tool_pathes.count; i++) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:jailbreak_tool_pathes[i]]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)deviceMultitaskingEnabled {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) {
        // Create a bool
        BOOL multitaskingSupported = [UIDevice currentDevice].multitaskingSupported;
        // Return the value
        return multitaskingSupported;
    }
    else {
        // Doesn't respond to selector
        return NO;
    }
}

+ (BOOL)deviceProximitySensorEnabled {
    // Is the proximity sensor enabled?
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setProximityMonitoringEnabled:)]) {
        // Create a UIDevice variable
        UIDevice *device = [UIDevice currentDevice];
        
        // Make a Bool for the proximity Sensor
        BOOL ProximitySensor;
        
        // Turn the sensor on, if not already on, and see if it works
        if (device.proximityMonitoringEnabled != YES) {
            // Sensor is off dn try to turn it on
            [device setProximityMonitoringEnabled:YES];
            // See if it turned on
            if (device.proximityMonitoringEnabled == YES) {
                // It turned on!  Turn it off
                [device setProximityMonitoringEnabled:NO];
                // It works
                ProximitySensor = YES;
            } else {
                // Didn't turn on, no good
                ProximitySensor = NO;
            }
        } else {
            // Sensor is already on
            ProximitySensor = NO;
        }
        
        // Return on or off
        return ProximitySensor;
    }
    else {
        // Doesn't respond to selector
        return NO;
    }
}

+ (BOOL)deviceDebuggerAttached {
    // Is the debugger attached?
    @try {
        // Set up the variables
        size_t size = sizeof(struct kinfo_proc);
        struct kinfo_proc info;
        int ret = 0, name[4];
        memset(&info, 0, sizeof(struct kinfo_proc));
        
        // Get the process information
        name[0] = CTL_KERN;
        name[1] = KERN_PROC;
        name[2] = KERN_PROC_PID;
        name[3] = getpid();
        
        // Check to make sure the variables are correct
        if (ret == (sysctl(name, 4, &info, &size, NULL, 0))) {
            // Sysctl() failed
            // Return the output of sysctl
            return ret;
        }
        
        // Return whether or not we're being debugged
        return (info.kp_proc.p_flag & P_TRACED) ? 1 : 0;
    }
    @catch (NSException *exception) {
        // Error
        return false;
    }
}

+ (BOOL)devicePluggedIn {
    // Is the device plugged in?
    if ([[UIDevice currentDevice] respondsToSelector:@selector(batteryState)]) {
        // Create a bool
        BOOL pluggedIn;
        // Set the battery monitoring enabled
        [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
        // Get the battery state
        UIDeviceBatteryState batteryState = [UIDevice currentDevice].batteryState;
        // Check if it's plugged in or finished charging
        if (batteryState == UIDeviceBatteryStateCharging || batteryState == UIDeviceBatteryStateFull) {
            // We're plugged in
            pluggedIn = YES;
        }
        else {
            pluggedIn = NO;
        }
        // Return the value
        return pluggedIn;
    }
    else {
        // Doesn't respond to selector
        return NO;
    }
}

@end
