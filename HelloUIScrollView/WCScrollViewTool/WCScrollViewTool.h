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

#pragma mark - Scroll to Specific Area

#pragma mark > Scroll to edges of the scroll view

/**
 Scroll to the top edge of the scroll view
 
 @param scrollView the scroll view
 @param animated YES if animated
 @return YES if operate successfully, NO if failed.
*/
+ (BOOL)scrollToTopWithScrollView:(UIScrollView *)scrollView animated:(BOOL)animated;

/**
 Scroll to the bottom edge of the scroll view
 
 @param scrollView the scroll view
 @param animated YES if animated
 @return YES if operate successfully, NO if failed.
*/
+ (BOOL)scrollToBottomWithScrollView:(UIScrollView *)scrollView animated:(BOOL)animated;

/**
 Scroll to the left edge of the scroll view
 
 @param scrollView the scroll view
 @param animated YES if animated
 @return YES if operate successfully, NO if failed.
*/
+ (BOOL)scrollToLeftWithScrollView:(UIScrollView *)scrollView animated:(BOOL)animated;

/**
 Scroll to the right edge of the scroll view
 
 @param scrollView the scroll view
 @param animated YES if animated
 @return YES if operate successfully, NO if failed.
*/
+ (BOOL)scrollToRightWithScrollView:(UIScrollView *)scrollView animated:(BOOL)animated;

#pragma mark > Scroll to edges of the content

/**
 Scroll to the top edge of the content
 
 @param scrollView the scroll view
 @param animated YES if animated
 @param considerSafeArea YES if consider the top safe area
 @return YES if operate successfully, NO if failed.
*/
+ (BOOL)scrollToTopOfContentWithScrollView:(UIScrollView *)scrollView animated:(BOOL)animated considerSafeArea:(BOOL)considerSafeArea;

/**
 Scroll to the bottom edge of the content
 
 @param scrollView the scroll view
 @param animated YES if animated
 @param considerSafeArea YES if consider the bottom safe area
 @return YES if operate successfully, NO if failed.
*/
+ (BOOL)scrollToBottomOfContentWithScrollView:(UIScrollView *)scrollView animated:(BOOL)animated considerSafeArea:(BOOL)considerSafeArea;

/**
 Scroll to the left edge of the content
 
 @param scrollView the scroll view
 @param animated YES if animated
 @param considerSafeArea YES if consider the left safe area
 @return YES if operate successfully, NO if failed.
*/
+ (BOOL)scrollToLeftOfContentWithScrollView:(UIScrollView *)scrollView animated:(BOOL)animated considerSafeArea:(BOOL)considerSafeArea;

/**
 Scroll to the right edge of the content
 
 @param scrollView the scroll view
 @param animated YES if animated
 @param considerSafeArea YES if consider the right safe area
 @return YES if operate successfully, NO if failed.
*/
+ (BOOL)scrollToRightOfContentWithScrollView:(UIScrollView *)scrollView animated:(BOOL)animated considerSafeArea:(BOOL)considerSafeArea;

#pragma mark - Check Scrolling Over

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
 Check the scroll view is scrolling over the left edge
 
 @param scrollView the scroll view
 @return YES if scroll view is scrolling over the left edge, otherwise return NO. And also return NO if the parameters are wrong.
 */
+ (BOOL)checkIsScrollingOverLeftWithScrollView:(UIScrollView *)scrollView;

/**
 Check the scroll view is scrolling over the right edge
 
 @param scrollView the scroll view
 @return YES if scroll view is scrolling over the right edge, otherwise return NO. And also return NO if the parameters are wrong.
 */
+ (BOOL)checkIsScrollingOverRightWithScrollView:(UIScrollView *)scrollView;

#pragma mark - Query

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
