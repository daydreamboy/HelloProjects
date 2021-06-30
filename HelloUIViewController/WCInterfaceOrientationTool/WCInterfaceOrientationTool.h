//
//  WCInterfaceOrientationTool.h
//  HelloUIViewController
//
//  Created by wesley_chen on 2021/6/29.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Callback type
 
 @param bizKey the unique biz key
 @param orientation the orientation after changed
 */
typedef void(^DeviceOrientationDidChangeBlockType)(NSString *bizKey, UIDeviceOrientation orientation);

@interface WCInterfaceOrientationTool : NSObject

+ (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window;

+ (void)forceLockOrientation:(UIInterfaceOrientation)orientation;
+ (UIInterfaceOrientation)appCurrentOrientation;

#pragma mark - Device Orientation

+ (UIDeviceOrientation)deviceCurrentOrientation;

/**
 Add an observer for UIDeviceOrientationDidChangeNotification
 
 @param bizKey the unique biz key
 @param eventBlock the callback when device orientation did change
 
 @return YES if registered successfully, NO if not
 
 @see https://stackoverflow.com/questions/38894031/swift-how-to-detect-orientation-changes
 */
+ (BOOL)registerDeviceOrientationDidChangeEventWithBizKey:(NSString *)bizKey eventBlock:(DeviceOrientationDidChangeBlockType)eventBlock;

/**
 Remove the observer
 
 @param bizKey the unique biz key
 
 @return YES if unregistered successfully, NO if not
 */
+ (BOOL)unregisterDeviceOrientationChangeEventWithBizKey:(NSString *)bizKey;

/**
 Remove all observers
 
 @return YES if unregistered successfully, NO if not
 */
+ (BOOL)unregisterAllDeviceOrientationChangeEvents;


#pragma mark - Utility

NSString *WCNSStringFromUIInterfaceOrientationMask(UIInterfaceOrientationMask mask);
NSString *WCNSStringFromUIDeviceOrientation(UIDeviceOrientation orientation);
NSString *WCNSStringFromUIInterfaceOrientation(UIInterfaceOrientation orientation);

@end

NS_ASSUME_NONNULL_END
