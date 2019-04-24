//
//  WCViewTool.h
//  HelloUIView
//
//  Created by wesley_chen on 13/12/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

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

/**
 Check it and itself all ancestor views `isKindOfClass`

 @param view the view to check
 @param cls the Class type wanted to search
 @return The first ancestor view which belongs to cls. Return nil if all ancestor views not belong to cls.
 */
+ (nullable UIView *)checkAncestralViewWithView:(UIView *)view ancestralViewIsKindOfClass:(Class)cls;

/**
 Get the UIViewController holds the receiver UIView directly or indirectly (that's its super or super... view is self.view)

 @param view the view to check its holding view controller
 @return If nil, the receiver UIView has no UIViewController to holding it.
 @see http://stackoverflow.com/questions/1372977/given-a-view-how-do-i-get-its-viewcontroller
 */
+ (UIViewController *)holdingViewControllerWithView:(UIView *)view;

/**
 Print recursive description of its all subviews, including itself

 @param view the view to print
 @warning Only available in debug mode which is DEBUG macro is enabled
 @see http://www.raywenderlich.com/62435/make-swipeable-table-view-cell-actions-without-going-nuts-scroll-views
 */
+ (void)hierarchalDescriptionWithView:(UIView *)view;

#pragma mark - Frame Adjustment

/**
 Adjust the frame of the view to fit its all subviews

 @param superView the super view whose frame should fit its all subviews and it expect to has at less one subview
 @return YES if the operation is success. NO if the view has no subviews.
 @see https://stackoverflow.com/a/21107340
 */
+ (BOOL)makeViewFrameToFitAllSubviewsWithSuperView:(UIView *)superView;

/**
 Center the grouped subviews

 @param subviews the subviews which expected to group. Maybe not all subviews of a super view.
 @param centerPoint the center point of the grouped area
 @param groupViewsRect the rect of the grouped area after relayout. Pass NULL if not need.
 @return YES if the operation is success, or return NO.
 @discussion
 1. The subviews keep the original frame, after call this method will adjust the subview positions
 2. This method maybe work same as +[WCViewTool makeViewFrameToFitAllSubviewsWithSuperView:],
 but more efficient than it for not creating a wrapper view
 */
+ (BOOL)makeSubviewsIntoGroup:(NSArray *)subviews centeredAtPoint:(CGPoint)centerPoint groupViewsRect:(inout nullable CGRect *)groupViewsRect;

#pragma mark - Visibility

/**
 Check a view if visible to user

 @param view the view to check
 @return YES if the view possibly is visible to the user
 @discussion This method is not accurate to judge the view is visible to the user
 @see https://stackoverflow.com/questions/1536923/determine-if-uiview-is-visible-to-the-user
 */
+ (BOOL)checkViewVisibleToUserWithView:(UIView *)view;

#pragma mark - Add Layers

/**
 Add gradient layer with left color and right color

 @param view the view to add
 @param startLeftColor the left color
 @param endRightColor the right color
 @return the original view
 @discussion This method only add a gradient layer once when called mutiple times. To remove it use +[WCViewTool removeGradientLayerWithView:]
 */
+ (UIView *)addGradientLayerWithView:(UIView *)view startLeftColor:(UIColor *)startLeftColor endRightColor:(UIColor *)endRightColor;

/**
 Remove gradient layer which added by +[WCViewTool addGradientLayerWithView:startLeftColor:endRightColor:]

 @param view the view to remove
 @return the original view
 */
+ (UIView *)removeGradientLayerWithView:(UIView *)view;

#pragma mark - Assistant Methods

#pragma mark > CGRect

/**
 Safe wrapper of AVMakeRectWithAspectRatioInsideRect
 
 @param contentSize the content size to scale and fit to the bounding rect
 @param boundingRect the bounding rect
 @return the scaled rect
 @header #import <AVFoundation/AVFoundation.h>
 @discussion 1. The AVMakeRectWithAspectRatioInsideRect's signature is CGRect AVMakeRectWithAspectRatioInsideRect(CGSize aspectRatio, CGRect boundingRect), and contentSize for aspectRatio, boundingRect for boundingRect. 2. This method internally use AVMakeRectWithAspectRatioInsideRect.
 */
+ (CGRect)safeAVMakeAspectRatioRectWithContentSize:(CGSize)contentSize insideBoundingRect:(CGRect)boundingRect;

/**
 Equivalent of AVMakeRectWithAspectRatioInsideRect
 
 @param contentSize the content size to scale and fit to the bounding rect
 @param boundingRect the bounding rect
 @return the scaled rect
 @discussion The AVMakeRectWithAspectRatioInsideRect's signature is CGRect AVMakeRectWithAspectRatioInsideRect(CGSize aspectRatio, CGRect boundingRect), and contentSize for aspectRatio, boundingRect for boundingRect
 */
+ (CGRect)makeAspectRatioRectWithContentSize:(CGSize)contentSize insideBoundingRect:(CGRect)boundingRect;

/**
 Get the rect with specific size which always centered in the rect

 @param size the size of the centered rect
 @param rect the super rect
 @return the centered rect. Return CGRectZero if the `size` or `rect` have zero width or zero height.
 */
+ (CGRect)centeredRectInRectWithSize:(CGSize)size inRect:(CGRect)rect;

/**
 Change frame with new x, y, width or height.
 
 @discussion Set NAN to not change. See +[WCViewTool changeFrame:newX:newY:newWidth:newHeight:] for details.
 */
#define FrameSet(frame, x, y, width, height) ([WCViewTool changeFrame:(frame) newX:(x) newY:(y) newWidth:(width) newHeight:(height)])

/**
 Change frame with new x, y, width or height.
 For convenience, use macro FrameSet(frame, x, y, width, height) instead.
 
 @param frame the frame
 @param newX the new x to set. Set NAN to not change
 @param newY the new y to set. Set NAN to not change
 @param newWidth the new width to set. Set NAN to not change
 @param newHeight the new height to set. Set NAN to not change
 @return the new frame
 */
+ (CGRect)changeFrame:(CGRect)frame newX:(CGFloat)newX newY:(CGFloat)newY newWidth:(CGFloat)newWidth newHeight:(CGFloat)newHeight;

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

@end

NS_ASSUME_NONNULL_END
