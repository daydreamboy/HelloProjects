//
//  WCWindowTool.m
//  HelloUIWindow
//
//  Created by wesley_chen on 2019/4/22.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCWindowTool.h"

@implementation WCWindowTool

+ (UIViewController *)visibleViewControllerWithWindow:(UIWindow *)window {
    UIViewController *rootViewController = window.rootViewController;
    return [self getVisibleViewControllerFrom:rootViewController];
}

+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController *)vc) visibleViewController]];
    }
    else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self getVisibleViewControllerFrom:[((UITabBarController *)vc) selectedViewController]];
    }
    else {
        if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        }
        else {
            return vc;
        }
    }
}

@end
