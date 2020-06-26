//
//  WCViewTool.h
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2020/6/26.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCViewTool : NSObject

@end

@interface WCViewTool ()

#pragma mark - Assistant Methods

#pragma mark > CGRect

/**
 Get the rect with specific size which always centered in the rect
 
 @param size the size of the centered rect
 @param rect the super rect
 @return the centered rect. Return CGRectZero if the `size` or `rect` have zero width or zero height.
 */
+ (CGRect)centeredRectInRectWithSize:(CGSize)size inRect:(CGRect)rect;

#pragma mark > CGSize

/**
 Get scaled size by ratio of width
 
 @param contentSize the content size
 @param fixedWidth the fixed width to fit
 @return the scaled size. Return CGSizeZero if the content's width or height is <= 0 or fixedWidth <= 0
 */
+ (CGSize)scaledSizeWithContentSize:(CGSize)contentSize fitToWidth:(CGFloat)fixedWidth;

/**
 Get scaled size by ratio of height
 
 @param contentSize the content size
 @param fixedHeight the fixed height to fit
 @return the scaled size. Return CGSizeZero if the content's width or height is <= 0 or fixedHeight <= 0
 */
+ (CGSize)scaledSizeWithContentSize:(CGSize)contentSize fitToHeight:(CGFloat)fixedHeight;

#pragma mark > SafeArea

/**
 Get safeAreaInsets of the view. Wrapper of the view.safeAreaInsets
  
 @param view the view
 @return the safeAreaInsets.  iOS 11+, return by view.safeAreaInsets. iOS 10-, return UIEdgeInsetsZero.
*/
+ (UIEdgeInsets)safeAreaInsetsWithView:(UIView *)view;

/**
 Get safe area frame base on the parent view
  
 @param parentView the parent view (e.g. self.view, or other views)
 @return the frame which always in the safe area
 @discussion the safe area is available on iOS 11+, but this API is compatible with lower version and
 return the parent view's bounds in iOS 10-
*/
+ (CGRect)safeAreaFrameWithParentView:(UIView *)parentView;

/**
 Get safe area layout frame for the view
  
 @param view the view to get its safe area layout  frame
 @return the frame which always in the safe area
 @discussion
 1. This method works same as view.safeAreaLayoutGuide.layoutFrame, but still can get
 correct layout frame when view.safeAreaInsets reach maximum or not increased.
 2. This method usually called in -[UIView layoutSubviews] get the correct layout frame.
*/
+ (CGRect)safeAreaLayoutFrameWithView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
