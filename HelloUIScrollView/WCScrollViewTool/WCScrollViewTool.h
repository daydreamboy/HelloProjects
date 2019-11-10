//
//  WCScrollViewTool.h
//  HelloUIScrollView
//
//  Created by wesley_chen on 2019/9/25.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCScrollViewTool : NSObject

/**
 Observe the user touch event on the scroll view
 
 @param scrollView the scroll view
 @param touchEventCallback the callback when event happened.
 - scrollView The touching scroll view
 - state The state of eventCallback is same as UIGestureRecognizerState.
 @return YES if setup the observing successfully, NO if the parameters are wrong or already setup once
 @discussion The eventCallback should not retain the scroll view again, use its the first parameter `scrollView` instead
 */
+ (BOOL)observeTouchEventWithScrollView:(UIScrollView *)scrollView touchEventCallback:(void (^)(UIScrollView *scrollView, UIGestureRecognizerState state))touchEventCallback;

/**
 Check the scroll view is scrolling over or at the top edge
 
 @param scrollView the scroll view
 @return YES if scroll view is scrolling over or at the top edge, otherwise return NO. And also return NO if the parameters are wrong.
 */
+ (BOOL)isOverTopWithScrollView:(UIScrollView *)scrollView;

/**
 Check the scroll view is scrolling over or at the bottom edge
 
 @param scrollView the scroll view
 @return YES if scroll view is scrolling over or at the bottom edge, otherwise return NO. And also return NO if the parameters are wrong.
 */
+ (BOOL)isOverBottomWithScrollView:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
