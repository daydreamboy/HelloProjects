//
//  WCViewTool.h
//  HelloUIView
//
//  Created by wesley_chen on 13/12/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WCViewTool : NSObject

#pragma mark - Blurring

+ (void)blurWithView:(UIView *)view style:(UIBlurEffectStyle)style;

#pragma mark - Debug

/**
 Register to observe the geometry change event for the view

 @param view the view to observe
 @discussion this method is not strongly retain the view
 */
+ (void)registerGeometryChangedObserverForView:(UIView *)view;

/**
 Unregister for the view

 @param view the view to unregister
 */
+ (void)unregisterGeometryChangeObserverForView:(UIView *)view;

#pragma mark - Hierarchy

/**
 Traverse all subviews of the UIView, excluding the sender view

 @param view the view to traverse
 @param block the callback
    - subview child of the view, or child...child of the view
    - stop set *stop = YES to stop traversing
 @discussion the block not called if the view has no subviews
 @warning be careful when view hierarchy is changing (addSubview or removeFromSuperview...)
 
 @see http://stackoverflow.com/questions/2746478/how-can-i-loop-through-all-subviews-of-a-uiview-and-their-subviews-and-their-su
 @see http://stackoverflow.com/questions/7243888/how-to-list-out-all-the-subviews-in-a-uiviewcontroller-in-ios
 @see https://stackoverflow.com/questions/22463017/recursive-method-with-block-and-stop-arguments
 */
+ (void)enumerateSubviewsInView:(UIView *)view usingBlock:(void (^)(UIView *subview, BOOL *stop))block;

@end
