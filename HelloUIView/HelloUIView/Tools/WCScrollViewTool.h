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

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"

typedef NS_ENUM(NSInteger, WCScrollViewContentInsetAdjustmentBehavior) {
    WCScrollViewContentInsetAdjustmentAutomatic = UIScrollViewContentInsetAdjustmentAlways,
    WCScrollViewContentInsetAdjustmentScrollableAxes = UIScrollViewContentInsetAdjustmentScrollableAxes,
    WCScrollViewContentInsetAdjustmentNever = UIScrollViewContentInsetAdjustmentNever,
    WCScrollViewContentInsetAdjustmentAlways = UIScrollViewContentInsetAdjustmentAlways,
};

#pragma GCC diagnostic pop

@interface WCScrollViewTool : NSObject

/**
 Safe set contentInsetAdjustmentBehavior of UIScrollView on iOS 11-
 
 @param scrollView the UIScrollView
 @param behavior the WCScrollViewContentInsetAdjustmentBehavior which is same as UIScrollViewContentInsetAdjustmentBehavior
 @return YES if set successfully, or NO if set failed.
 @discussion setContentInsetAdjustmentBehavior: called on iOS 11- will cause to crash
 */
+ (BOOL)safeSetContentInsetAdjustmentBehaviorWithScrollView:(UIScrollView *)scrollView behavior:(WCScrollViewContentInsetAdjustmentBehavior)behavior;

@end

NS_ASSUME_NONNULL_END
