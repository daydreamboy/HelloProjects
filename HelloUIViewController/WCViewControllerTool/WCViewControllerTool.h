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

@end

NS_ASSUME_NONNULL_END
