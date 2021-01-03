//
//  WCTouchWindow.h
//  HelloUIApplication
//
//  Created by wesley_chen on 2021/1/3.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const WCTouchWindow_InterfaceEventNotification;

/**
 The window show touch indicator
 
 @see https://github.com/Legoless/Alpha
 */
@interface WCTouchWindow : UIWindow

/**
 The flag for showing the touch point indicator
 
 Default is YES
 */
@property (nonatomic, assign) BOOL shouldDisplayTouches;

/**
 Create a default window
 
 @return the default window
 
 @discussion This method create a window which registered the notification
 `WCTouchWindow_InterfaceEventNotification` and hidden = NO. You should post the notification in
 the sendEvent method as following
 
 @code
 - (void)sendEvent:(UIEvent *)event {
     [[NSNotificationCenter defaultCenter] postNotificationName:WCTouchWindow_InterfaceEventNotification object:event];
     
     [super sendEvent:event];
 }
 @endcode
 */
+ (instancetype)defaultTouchWindow;

/**
 Create a window
 
 @param frame the frame
 @return the window which not registered with WCTouchWindow_InterfaceEventNotification notification
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 Show touch indicator
 
 @discussion If the window created by +[WCTouchWindow defaultTouchWindow], you don't
 need to call this method. If the window create by +initXX Method, you should call this method
 */
- (void)displayTouchIndicatorWithEvent:(UIEvent *)event;

@end

NS_ASSUME_NONNULL_END
