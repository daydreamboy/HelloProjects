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

/**
 Change frame with new x, y, width or height.
 
 @discussion Set NAN to not change. See +[WCViewTool changeFrame:newX:newY:newWidth:newHeight:] for details.
 */
#define FrameSet(frame, x, y, width, height) ([WCViewTool changeFrame:(frame) newX:(x) newY:(y) newWidth:(width) newHeight:(height)])

/**
 Change center with new x, y
 
 @discussion Set NAN to not change. See +[WCViewTool changeCenter:newCX:newCY:] for details.
 */
#define CenterSet(center, cx, cy) ([WCViewTool changeCenter:(center) newCX:(cx) newCY:(cy)])

#define ViewFrameSet(view, x, y, width, height) ([WCViewTool changeFrameWithView:(view) newX:(x) newY:(y) newWidth:(width) newHeight:(height)])

#define ViewCenterSet(view, cx, cy) ([WCViewTool changeCenterWithView:(view) newCX:(cx) newCY:(cy)])

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
 @param enumerateIncludeView  set YES, the block's subview parameter consider the view. set NO, the block's subview parameter ignore the view
 @param block the callback
    - subview child of the view, or child...child of the view
    - stop set *stop = YES to stop traversing
 @return YES if the operation is success. NO if the parameters are not correct.
 
 @discussion the block not called if the view has no subviews
 @warning be careful when view hierarchy is changing (addSubview or removeFromSuperview...)
 
 @see http://stackoverflow.com/questions/2746478/how-can-i-loop-through-all-subviews-of-a-uiview-and-their-subviews-and-their-su
 @see http://stackoverflow.com/questions/7243888/how-to-list-out-all-the-subviews-in-a-uiviewcontroller-in-ios
 @see https://stackoverflow.com/questions/22463017/recursive-method-with-block-and-stop-arguments
 */
+ (BOOL)enumerateSubviewsInView:(UIView *)view enumerateIncludeView:(BOOL)enumerateIncludeView usingBlock:(void (^)(UIView *subview, BOOL *stop))block;

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

/**
 Climbs up the view hierarchy to find the first which has clipToBounds = YES
 
 @param view the start view to look up its parent view which is clipping or not
 @return UIView with clipToBounds = YES, or the topmost view which is not clipping
 */
+ (UIView *)clippingParentViewWithView:(UIView *)view;

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

/**
 Change frame with the view. See +[WCViewTool changeFrame:newX:newY:newWidth:newHeight:] for detail.
 
 @param view the view
 @param newX the new x to set. Set NAN to not change
 @param newY the new y to set. Set NAN to not change
 @param newWidth the new width to set. Set NAN to not change
 @param newHeight the new height to set. Set NAN to not change
 @return YES if the operation is success, or return NO.
 */
+ (BOOL)changeFrameWithView:(UIView *)view newX:(CGFloat)newX newY:(CGFloat)newY newWidth:(CGFloat)newWidth newHeight:(CGFloat)newHeight;

/**
 Change center with the view. See +[WCViewTool changeCenter:newCX:newCY:] for detail.
 
 @param view the view
 @param newCX the new cx to set. Set NAN to not change
 @param newCY the new cy to set. Set NAN to not change
 @return YES if the operation is success, or return NO.
 */
+ (BOOL)changeCenterWithView:(UIView *)view newCX:(CGFloat)newCX newCY:(CGFloat)newCY;

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
 @param startColor the start color
 @param endColor the end color
 @param startPoint the start point
 @param endPoint the end point
 @param addToTop YES if add the top layer, NO if add as the lowest layer
 @param observeViewBoundsChange YES if need to observe the view bounds change, or NO if not need
 
 @return YES if operate successfully, or NO if failed
 @discussion This method only add a gradient layer once when called mutiple times. To remove it use +[WCViewTool removeGradientLayerWithView:]
 */
+ (BOOL)addGradientLayerWithView:(UIView *)view startColor:(UIColor *)startColor endColor:(UIColor *)endColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint addToTop:(BOOL)addToTop observeViewBoundsChange:(BOOL)observeViewBoundsChange;

/**
 Remove gradient layer which added by +[WCViewTool addGradientLayerWithView:startLeftColor:endRightColor:]

 @param view the view to remove
 @return YES if operate successfully, or NO if failed
 */
+ (BOOL)removeGradientLayerWithView:(UIView *)view;

#pragma mark - View State

/**
 Store all subviews' properties of the view
 
 @param view the root view
 @param properties the properties should be stored
 @return the stored record map, the format is { view pointer => { property key => value } }.
 @see https://stackoverflow.com/questions/14468449/the-selectedbackgroundview-modifies-the-contentview-subviews
 */
+ (nullable NSDictionary<NSString *, NSDictionary *> *)storeAllSubviewStatesWithView:(UIView *)view properties:(NSArray<NSString *> *)properties;

/**
 Restore all subviews' properties of the view
 
 @param view the root view
 @param properties the properties should be restored. If nil or emtpy array,
 restore all properties which stored by +[WCViewTool storeAllSubviewStatesWithView:properties:]
 @return the stored record map. See +[WCViewTool storeAllSubviewStatesWithView:properties:] for detail.
 */
+ (nullable NSDictionary<NSString *, NSDictionary *> *)restoreAllSubviewStatesWithView:(UIView *)view properties:(nullable NSArray<NSString *> *)properties;

#pragma mark - View Snapshot

/**
 Create a snapshot of UIView
 
 @param view the view to take snapshot
 @return the snapshot UIImage. If failed, return nil
 @discussion This method internally use +[WCViewTool snapshotWithView:afterScreenUpdates:]. And set afterScreenUpdates
 to YES because snapshot the view both onscreen and offscreen
 */
+ (nullable UIImage *)snapshotWithView:(UIView *)view;

/**
 Create a snapshot of UIView
 
 @param view the view to take snapshot
 @param afterScreenUpdates NO if consider the current state (e.g. UIButton pressed state), or NO if not consider
 @return the snapshot UIImage. If failed, return nil
 @discussion If consider the current state and view must not offscreen, set afterScreenUpdates to NO
 */
+ (nullable UIImage *)snapshotWithView:(UIView *)view afterScreenUpdates:(BOOL)afterScreenUpdates;

/**
 Create a snapshot of UIWindow
 
 @param window the UIWindow
 @param includeStatusBar YES if also snapshot status bar, NO if ignore status bar
 @param afterScreenUpdates NO if consider the current state (e.g. UIButton pressed state), or NO if not consider
 @return the snapshot UIImage. If failed, return nil
 */
+ (nullable UIImage *)snapshotWithWindow:(UIWindow *)window includeStatusBar:(BOOL)includeStatusBar afterScreenUpdates:(BOOL)afterScreenUpdates;

/**
 Create a snapshot of UIScrollView
 
 @param scrollView the UIScrollView
 @param shouldConsiderContent YES if only snapshot the content, NO if only snapshot the area of scrollView
 @return the snapshot UIImage. If failed, return nil
 */
+ (nullable UIImage *)snapshotWithScrollView:(UIScrollView *)scrollView shouldConsiderContent:(BOOL)shouldConsiderContent;

/**
 Create a snapshot of current screen not include special window (alert, action sheet, keyboard...)
 
 @param includeStatusBar YES if also snapshot status bar, NO if ignore status bar
 @param afterScreenUpdates NO if consider the current state (e.g. UIButton pressed state), or NO if not consider
 @return the snapshot UIImage. If failed, return nil
 */
+ (nullable UIImage *)snapshotScreenIncludeStatusBar:(BOOL)includeStatusBar afterScreenUpdates:(BOOL)afterScreenUpdates;

/**
 Create a snapshot of current screen include special window (alert, action sheet, keyboard...)
 
 @param includeStatusBar YES if also snapshot status bar, NO if ignore status bar
 @param afterScreenUpdates NO if consider the current state (e.g. UIButton pressed state), or NO if not consider
 @return the snapshot UIImage. If failed, return nil
 */
+ (nullable UIImage *)snapshotScreenAfterOtherWindowsHasShownIncludeStatusBar:(BOOL)includeStatusBar afterScreenUpdates:(BOOL)afterScreenUpdates;

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
 For convenience, use macro FrameSet(frame, x, y, width, height) instead.
 
 @param frame the frame
 @param newX the new x to set. Set NAN to not change
 @param newY the new y to set. Set NAN to not change
 @param newWidth the new width to set. Set NAN to not change
 @param newHeight the new height to set. Set NAN to not change
 @return the new frame
 */
+ (CGRect)changeFrame:(CGRect)frame newX:(CGFloat)newX newY:(CGFloat)newY newWidth:(CGFloat)newWidth newHeight:(CGFloat)newHeight;

/**
 Get padded rect with insets
 
 @param frame the original frame
 @param insets the insets  to set. Set UIEdgeInsetsZero to not change.
 @return the new rect. Return CGRectZero if calculate the wrong result by insets
 @note insets need positive values
 */
+ (CGRect)paddedRectWithFrame:(CGRect)frame insets:(UIEdgeInsets)insets;

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

#pragma mark > CGPoint

/**
 Change center with new x, y
 For convenience, use macro FrameSet(frame, x, y, width, height) instead.
 
 @param center the center
 @param newCX the new cx to set. Set NAN to not change
 @param newCY the new cy to set. Set NAN to not change
 @return the new center
 */
+ (CGPoint)changeCenter:(CGPoint)center newCX:(CGFloat)newCX newCY:(CGFloat)newCY;

#pragma mark > UIEdgeInsets

/**
 check the UIEdgeInsets if contains the other UIEdgeInsets

 @param edgeInsets the first UIEdgeInsets
 @param otherEdgeInsets the second UIEdgeInsets
 @return Return YES if the  first UIEdgeInsets contains the second UIEdgeInsets
 @discussion the edgeInsets and otherEdgeInsets allow positve values and negative values.
*/
+ (BOOL)checkEdgeInsets:(UIEdgeInsets)edgeInsets containsOtherEdgeInsets:(UIEdgeInsets)otherEdgeInsets;

#pragma mark > SafeArea

/**
 Get safeAreaInsets of the view. Wrapper of the view.safeAreaInsets
  
 @param view the view. Pass nil will treat as pass [[UIApplication sharedApplication] keyWindow]
 @return the safeAreaInsets.  iOS 11+, return by view.safeAreaInsets. iOS 10-, return UIEdgeInsetsZero.
*/
+ (UIEdgeInsets)safeAreaInsetsWithView:(nullable UIView *)view;

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
