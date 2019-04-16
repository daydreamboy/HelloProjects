//
//  WCAlertController.h
//  HelloUIAlertController
//
//  Created by wesley_chen on 2018/8/15.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 A subclass of UIAlertController which supports to show without presented on a view controller
 
 @see https://stackoverflow.com/a/30941356
 @discussion The alert controller presented on an internal window
 */
@interface WCAlertController : UIAlertController

/**
 Show the alert controller with animation
 */
- (void)show;

/**
 Show the alert controller

 @param animated YES if animated
 */
- (void)show:(BOOL)animated;
@end
