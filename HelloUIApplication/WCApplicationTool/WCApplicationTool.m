//
//  WCApplicationTool.m
//  HelloUIApplication
//
//  Created by wesley_chen on 2019/2/25.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCApplicationTool.h"

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

#pragma mark - App Utility

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
