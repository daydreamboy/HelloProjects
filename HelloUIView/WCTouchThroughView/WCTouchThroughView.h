//
//  WCTouchThroughView.h
//  HelloUIView
//
//  Created by wesley_chen on 05/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 A super view for allowing touch pass through to its underneath views
 
 @see https://stackoverflow.com/questions/3834301/ios-forward-all-touches-through-a-view
 */
@interface WCTouchThroughView : UIView

/**
 Allow all touch through this view. Default is YES
 
 @discussion Set NO will make it behavior as normal UIView
 */
@property (nonatomic, assign) BOOL touchThrough;

/**
 The subviews of this WCTouchThroughView which make touch through intercepted, so those subviews handle the touch event
 
 @discussion The order of array is the respond priority of the subviews.
 @warning The subviews are weakly hold in this array
 */
@property (nonatomic, strong) NSArray<UIView *> *interceptedSubviews;

/**
 Ask the background region exclude interceptedSubviews should pass touch through.
 
 @discussion If not set this block, by default pass touch through
 @warning maybe called many times
 */
@property (nonatomic, copy) BOOL (^backgroundRegionShouldTouchThrough)(void);

@end
