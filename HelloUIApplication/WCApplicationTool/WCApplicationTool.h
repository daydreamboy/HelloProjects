//
//  WCApplicationTool.h
//  HelloUIApplication
//
//  Created by wesley_chen on 2019/2/25.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCApplicationTool : NSObject

#pragma mark - App Info

/**
 App Version (Major Version), viewed in Target's 'General' -> 'Version'

 @return the app version
 @see http://stackoverflow.com/questions/458632/how-can-my-iphone-app-detect-its-own-version-number
 */
+ (NSString *)appVersion;

/**
 App Build Number (Minor Version), viewed in Target's 'General' -> 'Build'

 @return the app build number
 @see http://stackoverflow.com/questions/458632/how-can-my-iphone-app-detect-its-own-version-number
 */
+ (NSString *)appBuildNumber;

/**
 App Product Name

 @return the app display name
 */
+ (NSString *)appDisplayName;

/**
 App Binary Executable File Name

 @return the app executable file name
 */
+ (NSString *)appExecutableName;

/**
 App Bundle Name

 @return the app bundle name
 */
+ (NSString *)appBundleName;

/**
 App Bundle Identifier

 @return the app bundle identifier
 */
+ (NSString *)appBundleID;

/**
 App Minimum Supported OS Version

 @return the app minimum supported OS version
 */
+ (NSString *)appMinimumSupportedOSVersion;

/**
 The info.plist URL

 @return the info.plist URL
 */
+ (NSURL *)appInfoPlistURL;

#pragma mark - App Directories

/**
 Get the path of `Documents` directory

 @return the path of documents directory, e.g. "/.../<app_home>/Documents"
 */
+ (NSString *)appDocumentsDirectory;

/**
 Get the path of `Library` directory

 @return the path of library directory, e.g. "/.../<app_home>/Library"
 */
+ (NSString *)appLibraryDirectory;

/**
 Get the path of `Caches` directory

 @return the path of Caches directory, e.g. "/.../<app_home>/Library/Caches"
 */
+ (NSString *)appCachesDirectory;

/**
 Get the path of 'Home' directory

 @return the path of home directory, e.g. "/.../<app_home>"
 */
+ (NSString *)appHomeDirectory;

/**
 Get the path of `tmp` directory

 @return the path of tmp directory, e.g. "/.../tmp/"
 */
+ (NSString *)appTmpDirectory;

/**
 Get the path of directory, e.g. Documents, Library, Caches

 @param searchPathDirectory the enum value (NSDocumentDirectory | NSLibraryDirectory | NSCachesDirectory)
 @return the path of directory
 */
+ (NSString *)appSearchPathDirectory:(NSSearchPathDirectory)searchPathDirectory;

#pragma mark - App Build Macros

+ (BOOL)macroDefined_DEBUG;
+ (BOOL)macroDefined_NDEBUG;
+ (BOOL)macroOn_DEBUG;
+ (BOOL)macroOn_NS_BLOCK_ASSERTIONS;

#pragma mark - App Event

/*!
 *  enable/disable user interaction
 *
 *  @param isAllow YES, enable user interaction; NO, disable user interaction
 *
 *  @return If YES, operation is done. If NO, operation is ignored
 *  @warning
 *  <br/> 1. This method must be paired with YES and NO
 *  <br/> 2. This method doesn't work with third-party keyboard on iOS 8+, when disable user interaction but user still can press key
 */
+ (BOOL)allowUserInteractionEvents:(BOOL)isAllow;

#pragma mark - App Utility

#pragma mark - Risky Methods

/**
 Get the window which owns the presented keyboard

 @return the window which presenting the keyboard. Return nil if the keyboard not show
 @see https://stackoverflow.com/a/45099545
 @discussion Use this method on your risk for it uses private class
 */
+ (nullable UIWindow *)currentKeyboardWindow;

@end

NS_ASSUME_NONNULL_END
