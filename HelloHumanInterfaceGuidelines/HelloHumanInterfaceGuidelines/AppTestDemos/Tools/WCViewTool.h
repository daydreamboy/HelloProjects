//
//  WCViewTool.h
//  HelloUIFont
//
//  Created by wesley_chen on 2020/5/27.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCViewTool : NSObject

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
