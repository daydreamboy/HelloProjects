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

#pragma mark - App Screen

/**
 Check app if support multiple scenes
 
 @return YES if support, NO if not
 
 @see https://stackoverflow.com/questions/57900007/how-to-launch-multiple-instances-of-a-scene-on-iphone-with-ios-13
 */
+ (BOOL)checkIfSupportMultipleScenes;

#pragma mark - App Utility

#pragma mark > Get debug configuration

/**
 Get JSON Object at the specific JSON file at MacOS user direcotry
 
 @param userHomeFileName the debug configuratio file name. If pass nil、empty string or not a string, use @"simulator_debug.json" instead.
 
 @return the JSON object which allow fragments
 @discussion on Simulator, ~/simulator_debug.json; on Device, <App Documents>/simulator_debug.json
 */
+ (nullable id)JSONObjectWithUserHomeFileName:(nullable NSString *)userHomeFileName;

#define RTCall_JSONObjectWithUserHomeFileName(userHomeFileName) ([NSClassFromString(@"WCApplicationTool") performSelector:@selector(JSONObjectWithUserHomeFileName:) withObject:(userHomeFileName)])

#pragma mark > Gray Release

/**
 Get a hash code integer
 
 @param string the string to hash
 @return the hash code integer which usually is unique
 @see https://stackoverflow.com/questions/299304/why-does-javas-hashcode-in-string-use-31-as-a-multiplier
 */
+ (int)hashCodeWithString:(NSString *)string;

/**
 Check if sampled when use lower/upper bound and mod
 
 @param uniqueID the unique string
 @param lowerBound lower bound expected >= -mod
 @param upperBound upper bound expected <= mod
 @param mod the mod should not zero. If zero, return NO
 @return YES if sampled, NO if not.
 */
+ (BOOL)checkIfSampledWithUniqueID:(NSString *)uniqueID lowerBound:(int)lowerBound upperBound:(int)upperBound mod:(int)mod;

/**
Check if sampled when use  mod as 5000

@param uniqueID the unique string
@param boundValue the bound value for lower bound and upper bound which is [-boundValue, boundValue]
@return YES if sampled, NO if not. The result is stored as static variable.
@discussion The mod uses 5000, if abs(boundValue) > 5000, return YES always.
*/
+ (BOOL)checkIfSampledOnceWithWithUniqueID:(NSString *)uniqueID boundValue:(int)boundValue;

#pragma mark > Risky Methods

/**
 Get the window which owns the presented keyboard

 @return the window which presenting the keyboard. Return nil if the keyboard not show
 @see https://stackoverflow.com/a/45099545
 @discussion Use this method on your risk for it uses private class
 */
+ (nullable UIWindow *)currentKeyboardWindow;

@end

NS_ASSUME_NONNULL_END
