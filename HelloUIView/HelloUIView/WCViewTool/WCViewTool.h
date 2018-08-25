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
@end
