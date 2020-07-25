//
//  WCViewTool.h
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2020/4/30.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCViewTool : NSObject
@end

@interface WCViewTool ()
+ (BOOL)enumerateSubviewsInView:(UIView *)view enumerateIncludeView:(BOOL)enumerateIncludeView usingBlock:(void (^)(UIView *subview, BOOL *stop))block;

/**
 Climbs up the view hierarchy to find the first which has clipToBounds = YES
 
 @param view the start view to look up its parent view which is clipping or not
 @return UIView with clipToBounds = YES, or the topmost view which is not clipping
 */
+ (UIView *)clippingParentViewWithView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
