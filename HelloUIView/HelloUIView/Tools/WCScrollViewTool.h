//
//  WCScrollViewTool.h
//  HelloUIView
//
//  Created by wesley_chen on 2019/11/15.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#ifdef __IPHONE_11_0

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"

typedef NS_ENUM(NSInteger, WCScrollViewContentInsetAdjustmentBehavior) {
    WCScrollViewContentInsetAdjustmentAutomatic = UIScrollViewContentInsetAdjustmentAlways,
    WCScrollViewContentInsetAdjustmentScrollableAxes = UIScrollViewContentInsetAdjustmentScrollableAxes,
    WCScrollViewContentInsetAdjustmentNever = UIScrollViewContentInsetAdjustmentNever,
    WCScrollViewContentInsetAdjustmentAlways = UIScrollViewContentInsetAdjustmentAlways,
};

#pragma GCC diagnostic pop

#else

typedef NS_ENUM(NSInteger, WCScrollViewContentInsetAdjustmentBehavior) {
    WCScrollViewContentInsetAdjustmentAutomatic,
    WCScrollViewContentInsetAdjustmentScrollableAxes,
    WCScrollViewContentInsetAdjustmentNever,
    WCScrollViewContentInsetAdjustmentAlways,
};

#endif

@interface WCScrollViewTool : NSObject

/**
 Safe set contentInsetAdjustmentBehavior of UIScrollView on iOS 10 <=
 
 @param scrollView the UIScrollView
 @param behavior the WCScrollViewContentInsetAdjustmentBehavior which is same as UIScrollViewContentInsetAdjustmentBehavior
 @return YES if set successfully, or NO if set failed.
 @discussion setContentInsetAdjustmentBehavior: called on iOS 10  <= will cause to crash, but this method is safe.
 */
+ (BOOL)safeSetContentInsetAdjustmentBehaviorWithScrollView:(UIScrollView *)scrollView behavior:(WCScrollViewContentInsetAdjustmentBehavior)behavior;

/**
 Get actual content inset of UIScrollView
 
 @param scrollView the UIScrollView
 @return the actual content inset. On iOS 11+, return the UIScrollView.adjustedContentInset. On iOS 10-, return the UIScrollView.contentInset.
 */
+ (UIEdgeInsets)actualContentInsetsWithScrollView:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
