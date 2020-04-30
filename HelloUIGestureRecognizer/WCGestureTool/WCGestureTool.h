//
//  WCGestureTool.h
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2019/12/10.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCGestureTool : NSObject

#pragma mark - Mock Tap Gesture

/**
 Create a mocked tap gesture for the original one, and use the mocked gesture to trigger the selector of original one
 
 @param tapGesture the original UITapGestureRecognizer
 @param tapPosition the tap position in tapGesture.view
 @return YES if operate successfully, NO if parameters are not correct.
 
 @discussion the selector of original UITapGestureRecognizer, can get mocked tap gesture by parameter, and query the mocked tapPosition
 by -[UITapGestureRecognizer locationInView:] method.
 */
+ (BOOL)triggerTapGestureWithGesture:(UITapGestureRecognizer *)tapGesture atTapPosition:(CGPoint)tapPosition;

#pragma mark - Mirroring Tap Gesture

/**
 Create a mirroring tap gesture with target and action
 
 @param gesture the original UITapGestureRecognizer
 @param target the target
 @param action the action
 @return the mirroring tap gesture
 */
+ (nullable UITapGestureRecognizer *)createMirroringTapGestureWithGesture:(UITapGestureRecognizer *)gesture target:(id)target action:(SEL)action;

/**
 Add mirroring tap gestures for the specified view
 
 @param view the view to add mirroring tap gestures
 @param target the target
 @param action the action
 @param recursive YES if need to add mirroring tap gestures for all subviews. NO if only for the view
 @return YES if operate successfully, NO if parameters are not correct.
 */
+ (BOOL)addMirroredTapGesturesWithView:(UIView *)view target:(id)target action:(SEL)action recursive:(BOOL)recursive;

@end

NS_ASSUME_NONNULL_END
