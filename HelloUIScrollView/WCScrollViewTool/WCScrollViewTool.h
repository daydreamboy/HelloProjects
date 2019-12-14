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

typedef NS_ENUM(NSUInteger, WCScrollViewScrollingDirection) {
    WCScrollViewScrollingDirectionNone,
    WCScrollViewScrollingDirectionLeft,
    WCScrollViewScrollingDirectionRight,
    WCScrollViewScrollingDirectionUp,
    WCScrollViewScrollingDirectionDown,
};

@interface WCScrollViewTool : NSObject

/**
 Observe the user touch event on the scroll view
 
 @param scrollView the scroll view
 @param touchEventCallback the callback when event happened.
 - scrollView The touching scroll view
 - state The state of eventCallback is same as UIGestureRecognizerState.
 @return YES if setup the observing successfully, NO if the parameters are wrong or already setup once
 @discussion The touchEventCallback should not retain the scroll view again, use its the first parameter `scrollView` instead
 */
+ (BOOL)observeTouchEventWithScrollView:(UIScrollView *)scrollView touchEventCallback:(void (^)(UIScrollView *scrollView, UIGestureRecognizerState state))touchEventCallback;

/**
Observe the scrolling event on the scroll view

@param scrollView the scroll view
@param scrollingEventCallback the callback when event happened.
- scrollView The scrolling scroll view
@return YES if setup the observing successfully, NO if the parameters are wrong or already setup once
@discussion The scrollingEventCallback should not retain the scroll view again, use its the first parameter `scrollView` instead
*/
+ (BOOL)observeScrollingEventWithScrollView:(UIScrollView *)scrollView scrollingEventCallback:(void (^)(UIScrollView *scrollView))scrollingEventCallback;

/**
 Check the scroll view is scrolling over the top edge
 
 @param scrollView the scroll view
 @return YES if scroll view is scrolling over the top edge, otherwise return NO. And also return NO if the parameters are wrong.
 @see https://stackoverflow.com/a/14745900
 */
+ (BOOL)checkIsScrollingOverTopWithScrollView:(UIScrollView *)scrollView;

/**
 Check the scroll view is scrolling over the bottom edge
 
 @param scrollView the scroll view
 @return YES if scroll view is scrolling over the bottom edge, otherwise return NO. And also return NO if the parameters are wrong.
 */
+ (BOOL)checkIsScrollingOverBottomWithScrollView:(UIScrollView *)scrollView;

/**
 Get fitted content size of the scroll view which can make scroll view not scrollable if
 alwaysBounceVertical and alwaysBounceHorizontal are NO.
 
 @param scrollView the scroll view
 @return Get fitted content size. Return CGSizeZero if parameter is wrong.
 */
+ (CGSize)fittedContentSizeWithScrollView:(UIScrollView *)scrollView;

#pragma mark - Adjust UIScrollView

#pragma mark > Content Size

/**
 Make the content size of scroll view just to fit, so only bounce if enable bouncing or not bounce if
 not enable bouncing.
 
 @param scrollView the scroll view
 @return YES if operate successully. NO if operate failed.
 */
+ (BOOL)makeContentSizeToFitWithScrollView:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
