//
//  WCViewControllerTool.m
//  HelloUIViewController
//
//  Created by wesley_chen on 2018/10/30.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCViewControllerTool.h"

@implementation WCViewControllerTool

#pragma mark - Status

+ (BOOL)checkViewVisibleWithViewController:(UIViewController *)viewController {
    if (![viewController isKindOfClass:[UIViewController class]]) {
        return NO;
    }
    
    return [viewController isViewLoaded] && viewController.view.window;
}

#pragma mark - Transition

#pragma mark > Check Appearing

+ (WCViewControllerAppearingReason)checkAppearingReasonWithViewController:(UIViewController *)viewController {
    if (![viewController isKindOfClass:[UIViewController class]]) {
        return WCViewControllerAppearingReasonUnknown;
    }
    
    // Note: firstly check modal condition
    if (viewController.presentedViewController || viewController.presentingViewController) {
        
        if (viewController.isBeingPresented) {
            // it's the modal vc
            return WCViewControllerAppearingReasonPresentItself;
        }
        else {
            // it has a modal vc
            return WCViewControllerAppearingReasonDismissModalVC;
        }
    }
    
    // Note: check on stack condition
    if (viewController.navigationController) {
        if (viewController.isMovingToParentViewController) {
            // it's being pushed
            return WCViewControllerAppearingReasonPushItself;
        }
        else {
            // it has a popped vc
            return WCViewControllerAppearingReasonPopAnotherVC;
        }
    }
    
    return WCViewControllerAppearingReasonUnknown;
}

#pragma mark > Check Disappearing

+ (WCViewControllerDisappearingReason)checkDisappearingReasonWithViewController:(UIViewController *)viewController {
    if (![viewController isKindOfClass:[UIViewController class]]) {
        return WCViewControllerDisappearingReasonUnknown;
    }
    
    // Note: firstly check modal condition
    if (viewController.presentedViewController || viewController.presentingViewController) {
        
        if (viewController.isBeingDismissed) {
            // it's the modal vc
            return WCViewControllerDisappearingReasonDismissItself;
        }
        else {
            // it will present a modal vc
            return WCViewControllerDisappearingReasonPresentModalVC;
        }
    }
    
    // Note: check on stack condition
    if (viewController.navigationController) {
        
        NSArray *stack = [viewController.navigationController viewControllers];
        if (stack.count >= 2) {
            UIViewController *lastButOneViewController = stack[stack.count - 2];
            if (lastButOneViewController == viewController) {
                return WCViewControllerDisappearingReasonPushAnotherVC;
            }
        }
        
        if (viewController.isMovingFromParentViewController) {
            // it's being to pop
            return WCViewControllerDisappearingReasonPopItself;
        }
    }
    
    return WCViewControllerDisappearingReasonUnknown;
}

#pragma mark - Hierarchy

+ (nullable UIViewController *)rootViewControllerWithNavController:(UINavigationController *)navController {
    
    UIViewController *rootViewController = nil;
    
    if ([navController isKindOfClass:[UINavigationController class]]) {
        NSArray *viewControllers = [navController viewControllers];
        
        if (viewControllers.count > 0) {
            rootViewController = viewControllers[0];
        }
    }
    
    return rootViewController;
}

+ (nullable UIViewController *)topViewController {
    return [self topViewControllerOnWindow:[UIApplication sharedApplication].keyWindow];
}

+ (nullable UIViewController *)topViewControllerOnWindow:(UIWindow *)window {
    if (![window isKindOfClass:[UIWindow class]]) {
        return nil;
    }
    
    return [self topViewControllerWithRootViewController:window.rootViewController];
}

#pragma mark ::

+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        // Note: visibleViewController is the view controller at the top of the navigation stack or a view controller that was presented modally on top of the navigation controller itself.
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    }
    else if (rootViewController.presentedViewController) {
        UIViewController *presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    }
    else {
        return rootViewController;
    }
}

@end
