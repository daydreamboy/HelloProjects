//
//  WCApplicationTool.m
//  HelloUIApplication
//
//  Created by wesley_chen on 2019/2/25.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCApplicationTool.h"
#import <sys/utsname.h>

#define IS_IPAD             ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

// >= `13.0`
#ifndef IOS13_OR_LATER
#define IOS13_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"13.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@implementation WCApplicationTool

#pragma mark - App Info

+ (NSString *)appVersion {
    // Note: access from memory, maybe changed by some code
    // [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
    
    NSString *version = [[self plistInfo] objectForKey:@"CFBundleShortVersionString"];
    return version;
}

+ (NSString *)appBuildNumber {
    // (NSString*)kCFBundleVersionKey is same as \@"CFBundleVersion"
    NSString *buildNumber = [[self plistInfo] objectForKey:@"CFBundleVersion"];
    return buildNumber;
}

+ (NSString *)appDisplayName {
    NSString *displayName = [[self plistInfo] objectForKey:@"CFBundleDisplayName"];
    return displayName;
}

+ (NSString *)appExecutableName {
    NSString *executableName = [[self plistInfo] objectForKey:@"CFBundleExecutable"];
    return executableName;
}

+ (NSString *)appBundleName {
    // (NSString *)kCFBundleNameKey is same as \@"CFBundleName"
    NSString *bundleName = [[self plistInfo] objectForKey:@"CFBundleName"];
    return bundleName;
}

+ (NSString *)appBundleID {
    NSString *bundleID = [[self plistInfo] objectForKey:@"CFBundleIdentifier"];
    return bundleID;
}

+ (NSString *)appMinimumSupportedOSVersion {
    NSString *minimumOSVersion = [[self plistInfo] objectForKey:@"MinimumOSVersion"];
    return minimumOSVersion;
}

+ (NSURL *)appInfoPlistURL {
    NSURL *infoPlistURL = [[self plistInfo] objectForKey:@"CFBundleInfoPlistURL"];
    return infoPlistURL;
}

#pragma mark ::

+ (NSDictionary *)plistInfo {
    static dispatch_once_t onceToken;
    static NSDictionary *info;
    dispatch_once(&onceToken, ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        info = dict ?: [NSBundle mainBundle].infoDictionary;
    });
    
    return info;
}

#pragma mark ::

#pragma mark - App Directories

+ (NSString *)appDocumentsDirectory {
    return [self appSearchPathDirectory:NSDocumentDirectory];
}

+ (NSString *)appLibraryDirectory {
    return [self appSearchPathDirectory:NSLibraryDirectory];
}

+ (NSString *)appCachesDirectory {
    return [self appSearchPathDirectory:NSCachesDirectory];
}

+ (NSString *)appHomeDirectory {
    return NSHomeDirectory();
}

+ (NSString *)appTmpDirectory {
    return NSTemporaryDirectory();
}

+ (NSString *)appSearchPathDirectory:(NSSearchPathDirectory)searchPathDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(searchPathDirectory, NSUserDomainMask, YES);
    NSString *directoryPath = ([paths count] > 0) ? paths[0] : nil;
    return directoryPath;
}

#pragma mark - App Build Macros

+ (BOOL)macroDefined_DEBUG {
#ifdef DEBUG
    return YES;
#else
    return NO;
#endif
}

+ (BOOL)macroOn_DEBUG {
#if DEBUG
    return YES;
#else
    return NO;
#endif
}

+ (BOOL)macroDefined_NDEBUG {
#ifdef NDEBUG
    return YES;
#else
    return NO;
#endif
}

+ (BOOL)macroOn_NS_BLOCK_ASSERTIONS {
#if NS_BLOCK_ASSERTIONS
    return YES;
#else
    return NO;
#endif
}

#pragma mark - App Event

+ (BOOL)allowUserInteractionEvents:(BOOL)isAllow {
    if (isAllow) {
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            return YES;
        }
    }
    else {
        if (![[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - App Screen

+ (BOOL)checkIfSupportMultipleScenes {
    if (IS_IPAD) {
        if (IOS13_OR_LATER) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
            return [UIApplication sharedApplication].supportsMultipleScenes;
#pragma GCC diagnostic pop
        }
        else {
            return NO;
        }
    }
    else {
        return NO;
    }
}

#pragma mark - App Utility

#pragma mark > Gray Release

+ (int)hashCodeWithString:(NSString *)string {
    NSMutableString *stringM = [NSMutableString stringWithString:string];
    if (string.length < 7) {
        // Note: if string length shorter than 7, to fill its length to 7
        for (NSUInteger i = string.length; i <= 7; ++i) {
            [stringM appendString:@"0"];
        }
    }
    const char *cString = [stringM UTF8String];
    int ret = 0;
    
    if (cString != NULL) {
        size_t len = strlen(cString);
        for (NSUInteger i = 0; i < len; ++i) {
            ret = 31 * ret + cString[i];
        }
    }
    
    return ret;
}

+ (BOOL)checkIfSampledWithUniqueID:(NSString *)uniqueID lowerBound:(int)lowerBound upperBound:(int)upperBound mod:(int)mod {
    if (![uniqueID isKindOfClass:[NSString class]] || uniqueID.length == 0) {
        return NO;
    }
    
    int hashCode = [self hashCodeWithString:uniqueID];
    int modL = ABS(mod);
    int boundedHashCode = hashCode % modL;
    if (lowerBound <= boundedHashCode && boundedHashCode <= upperBound) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)checkIfSampledOnceWithWithUniqueID:(NSString *)uniqueID boundValue:(int)boundValue {
    if (boundValue == 0 || ![uniqueID isKindOfClass:[NSString class]] || uniqueID.length == 0) {
        return NO;
    }
    
    static NSNumber *sResult;
    if (!sResult) {
        int mod = 5000;
        int absBoundValue = MIN(ABS(boundValue), mod);
        int leftValue = -absBoundValue;
        int rightValue = absBoundValue;
        
        int hashCode = [self hashCodeWithString:uniqueID];
        int boundedHashCode = hashCode % mod;
        
        if (boundedHashCode >= leftValue && boundedHashCode <= rightValue) {
            sResult = @(YES);
        }
        else {
            sResult = @(NO);
        }
    }

    return [sResult boolValue];
}

#pragma mark > Get debug configuration

+ (nullable id)JSONObjectWithUserHomeFileName:(nullable NSString *)userHomeFileName {
    if (![userHomeFileName isKindOfClass:[NSString class]] || !userHomeFileName.length) {
        userHomeFileName = @"simulator_debug.json";
    }

    NSMutableArray *components = [NSMutableArray array];
    
    if ([self deviceIsSimulator]) {
        NSString *appHomeDirectoryPath = [@"~" stringByExpandingTildeInPath];
        NSArray *pathParts = [appHomeDirectoryPath componentsSeparatedByString:@"/"];
        if (pathParts.count < 2) {
            return nil;
        }
        
        [components addObject:@"/"];
        // Note: pathParts is @"", @"Users", @"<your name>", ...
        [components addObjectsFromArray:[pathParts subarrayWithRange:NSMakeRange(1, 2)]];
        
    }
    else {
        [components addObject:NSHomeDirectory()];
        [components addObject:@"Documents"];
    }
    
    [components addObject:userHomeFileName];
    
    NSString *filePath = [NSString pathWithComponents:components];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return nil;
    }
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:filePath options:kNilOptions error:&error];
    if (!data) {
        NSLog(@"[%@] an error occurred: %@", NSStringFromClass([self class]), error);
        return nil;
    }
    
    id JSONObject = nil;
    @try {
        NSError *error2;
        JSONObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:&error2];
        if (!JSONObject) {
            NSLog(@"[%@] error parsing JSON: %@", NSStringFromClass([self class]), error2);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[%@] an exception occured:\n%@", NSStringFromClass([self class]), exception);
    }
    
    return JSONObject;
}

#pragma mark ::

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

#pragma mark ::

#pragma mark > Risky Methods

+ (nullable UIWindow *)currentKeyboardWindow {
    NSArray *components = @[ @"UI", @"Remote", @"Keyboard", @"Window" ];
    Class clz = NSClassFromString([components componentsJoinedByString:@""]);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@", clz];
    NSArray<UIWindow *> *windows = [[[UIApplication sharedApplication] windows] filteredArrayUsingPredicate:predicate];
    if (windows.count == 1) {
        UIWindow *keyboardWindow = [windows firstObject];
        if (keyboardWindow) {
            return keyboardWindow;
        }
    }
    
    return nil;
}

@end
