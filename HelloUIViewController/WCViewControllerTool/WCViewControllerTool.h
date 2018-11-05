//
//  WCViewControllerTool.h
//  HelloUIViewController
//
//  Created by wesley_chen on 2018/10/30.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WCViewControllerAppearingReason) {
    WCViewControllerAppearingReasonUnknown,
    WCViewControllerAppearingReasonPushItself,
    WCViewControllerAppearingReasonPopAnotherVC,
    WCViewControllerAppearingReasonDismissModalVC,
    WCViewControllerAppearingReasonPresentItself,
};

typedef NS_ENUM(NSUInteger, WCViewControllerDisappearingReason) {
    WCViewControllerDisappearingReasonUnknown,
    WCViewControllerDisappearingReasonPushAnotherVC,
    WCViewControllerDisappearingReasonPopItself,
    WCViewControllerDisappearingReasonPresentModalVC,
    WCViewControllerDisappearingReasonDismissItself,
};

@interface WCViewControllerTool : NSObject

#pragma mark - Status

/**
 Check view controller's view if visible

 @param viewController the view controller
 @return YES if view controller is loaded and its view on the window
 @warning This method is not very accurate for some situations, e.g. the view is overlapped, the window is invisible, and so on.
 @see http://stackoverflow.com/questions/2777438/how-to-tell-if-uiviewcontrollers-view-is-visible
 */
+ (BOOL)checkViewVisibleWithViewController:(UIViewController *)viewController;

#pragma mark - Transition

#pragma mark > Check Appearing

/**
 Check view controller appearing reason only in viewWillAppear:

 @param viewController the view controller
 @return the reason of appearing. Return WCViewControllerAppearingReasonUnknown if not detected.
 @warning This method only available in viewWillAppear: method
 */
+ (WCViewControllerAppearingReason)checkAppearingReasonWithViewController:(UIViewController *)viewController;

#pragma mark > Check Disappearing

/**
 Check view controller disappearing reason only in viewWillDisappear:

 @param viewController the view controller
 @return the reason of disappearing. Return WCViewControllerDisappearingReasonUnknown if not detected.
 @warning This method only available in viewWillDisappear: method
 */
+ (WCViewControllerDisappearingReason)checkDisappearingReasonWithViewController:(UIViewController *)viewController;

#pragma mark - Hierarchy

/**
 Get the root view controller of the navigation controller

 @param navController the navigation controller
 @return the root view controller of the navigation controller
 */
+ (nullable UIViewController *)rootViewControllerWithNavController:(UINavigationController *)navController;

/**
 Get the top most view controller on the keyed window

 @return the top most view controller
 @see http://stackoverflow.com/questions/6131205/iphone-how-to-find-topmost-view-controller
 */
+ (nullable UIViewController *)topViewController;

/**
 Get the top most view controller on the specific window

 @param window the window
 @return the top most view controller
 */
+ (nullable UIViewController *)topViewControllerOnWindow:(UIWindow *)window;

@end

NS_ASSUME_NONNULL_END
