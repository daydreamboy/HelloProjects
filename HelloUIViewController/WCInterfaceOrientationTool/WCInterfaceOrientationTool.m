//
//  WCInterfaceOrientationTool.m
//  HelloUIViewController
//
//  Created by wesley_chen on 2021/6/29.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "WCInterfaceOrientationTool.h"
#import "WCViewControllerTool.h"

@interface WCInterfaceOrientationTool ()
@property (nonatomic, strong, class, readonly) NSMutableDictionary<NSString *, DeviceOrientationDidChangeBlockType> *observers;
@property (nonatomic, assign, class) BOOL isUIDeviceOrientationDidChangeNotificationRegistered;
@end

@implementation WCInterfaceOrientationTool

#pragma mark - Class Properties

static NSMutableDictionary *sObservers;

+ (NSMutableDictionary *)observers {
    if (!sObservers) {
        sObservers = [NSMutableDictionary dictionary];
    }
    return sObservers;
}

static BOOL sIsUIDeviceOrientationDidChangeNotificationRegistered;

+ (void)setIsUIDeviceOrientationDidChangeNotificationRegistered:(BOOL)isUIDeviceOrientationDidChangeNotificationRegistered {
    sIsUIDeviceOrientationDidChangeNotificationRegistered = isUIDeviceOrientationDidChangeNotificationRegistered;
}

+ (BOOL)isUIDeviceOrientationDidChangeNotificationRegistered {
    return sIsUIDeviceOrientationDidChangeNotificationRegistered;
}

#pragma mark -

+ (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    UIViewController *topViewController = [WCViewControllerTool topViewControllerOnWindow:window];
    
    BOOL shouldAutorotate = YES;
    if ([topViewController respondsToSelector:@selector(shouldAutorotate)]) {
        shouldAutorotate = [topViewController shouldAutorotate];
    }
    
    if (!shouldAutorotate) {
        return UIInterfaceOrientationMaskPortrait;
    }
    
    UIInterfaceOrientationMask mask = UIInterfaceOrientationMaskPortrait;
    if ([topViewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
        mask = [topViewController supportedInterfaceOrientations];
    }
    
    return mask;
}

+ (void)forceLockOrientation:(UIInterfaceOrientation)orientation {
    [[UIDevice currentDevice] setValue:@(orientation) forKey:@"orientation"];
    [UIViewController attemptRotationToDeviceOrientation];
}

+ (UIInterfaceOrientation)appCurrentOrientation {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;

    //Default orientation
    if (orientation == 0) {
        //UI is in Default (Portrait) -- this is really a just a failsafe.
        return UIInterfaceOrientationUnknown;
    }
    //Do something if the orientation is in Portrait
    else if (orientation == UIInterfaceOrientationPortrait) {
        return UIInterfaceOrientationPortrait;
    }
    // Do something if Left
    else if(orientation == UIInterfaceOrientationLandscapeLeft) {
        return UIInterfaceOrientationLandscapeLeft;
    }
    // Do something if right
    else if(orientation == UIInterfaceOrientationLandscapeRight) {
        return UIInterfaceOrientationLandscapeRight;
    }
    else {
        return UIInterfaceOrientationUnknown;
    }
}

#pragma mark - Device Orientation

+ (UIDeviceOrientation)deviceCurrentOrientation {
    UIDeviceOrientation currentOrientation = [UIDevice currentDevice].orientation;
    return currentOrientation;
}

+ (BOOL)registerDeviceOrientationDidChangeEventWithBizKey:(NSString *)bizKey eventBlock:(DeviceOrientationDidChangeBlockType)eventBlock {
    if (![bizKey isKindOfClass:[NSString class]] || bizKey.length == 0) {
        return NO;
    }
    
    if (!eventBlock) {
        return NO;
    }
    
    if (!self.isUIDeviceOrientationDidChangeNotificationRegistered) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUIDeviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
        self.isUIDeviceOrientationDidChangeNotificationRegistered = YES;
    }
    
    self.observers[bizKey] = [eventBlock copy];
    
    return YES;
}

+ (BOOL)unregisterDeviceOrientationChangeEventWithBizKey:(NSString *)bizKey {
    if (![bizKey isKindOfClass:[NSString class]] || bizKey.length == 0) {
        return NO;
    }
    
    self.observers[bizKey] = nil;
    
    return YES;
}

+ (BOOL)unregisterAllDeviceOrientationChangeEvents {
    [self.observers removeAllObjects];
    
    return YES;
}

#pragma mark - NSNotification

+ (void)handleUIDeviceOrientationDidChangeNotification:(NSNotification *)notification {
    UIDeviceOrientation currentOrientation = [UIDevice currentDevice].orientation;
    [self.observers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, DeviceOrientationDidChangeBlockType  _Nonnull block, BOOL * _Nonnull stop) {
        block(key, currentOrientation);
    }];
}

#pragma mark - Utility

NSString *WCNSStringFromUIInterfaceOrientationMask(UIInterfaceOrientationMask mask)
{
    switch (mask) {
        case UIInterfaceOrientationMaskPortrait:
            return @"MaskPortrait";
        case UIInterfaceOrientationMaskLandscapeLeft:
            return @"MaskLandscapeLeft";
        case UIInterfaceOrientationMaskLandscapeRight:
            return @"MaskLandscapeRight";
        case UIInterfaceOrientationMaskPortraitUpsideDown:
            return @"MaskPortraitUpsideDown";
        case UIInterfaceOrientationMaskLandscape:
            return @"MaskLandscape";
        case UIInterfaceOrientationMaskAll:
            return @"MaskAll";
        case UIInterfaceOrientationMaskAllButUpsideDown:
            return @"MaskAllButUpsideDown";
        default:
            return @"Unknown";
    }
}

NSString *WCNSStringFromUIDeviceOrientation(UIDeviceOrientation orientation)
{
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            return @"DevicePortrait";
        case UIDeviceOrientationPortraitUpsideDown:
            return @"DevicePortraitUpsideDown";
        case UIDeviceOrientationLandscapeLeft:
            return @"DeviceLandscapeLeft";
        case UIDeviceOrientationLandscapeRight:
            return @"DeviceLandscapeRight";
        case UIDeviceOrientationFaceUp:
            return @"DeviceFaceUp";
        case UIDeviceOrientationFaceDown:
            return @"DeviceFaceDown";
        case UIDeviceOrientationUnknown:
        default:
            return @"Unknown";
    }
}

NSString *WCNSStringFromUIInterfaceOrientation(UIInterfaceOrientation orientation)
{
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            return @"InterfacePortrait";
        case UIInterfaceOrientationPortraitUpsideDown:
            return @"InterfacePortraitUpsideDown";
        case UIInterfaceOrientationLandscapeLeft:
            return @"InterfaceLandscapeLeft";
        case UIInterfaceOrientationLandscapeRight:
            return @"InterfaceLandscapeRight";
        case UIInterfaceOrientationUnknown:
        default:
            return @"Unknown";
    }
}


@end
