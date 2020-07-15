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
            // iPads
            else if ([deviceType isEqualToString:@"iPad1,1"])
                newDeviceType = @"iPad";
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
        // Return -1 (not found)
        return -1;
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

@end
