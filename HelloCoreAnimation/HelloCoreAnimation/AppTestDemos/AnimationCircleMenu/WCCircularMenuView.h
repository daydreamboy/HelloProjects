//
//  ALPHACircleMenuView.h
//
//  Created by Christian Klaproth on 31.08.14.
//  Copyright © 2014 Christian Klaproth. All rights reserved.
//

@import UIKit;

@class WCCircularMenuView;

@protocol ALPHACircleMenuDelegate <NSObject>

@optional

/*!
 * Gets called when the CircleMenu has shown up.
 */
- (void)circleMenuDidOpened:(WCCircularMenuView *)menuView;
/*!
 * Informs the delegate that the menu is going to be closed with
 * the button specified by the index being activated.
 */
- (void)circleMenuActivatedButtonWithIndex:(int)anIndex;

/*!
 *  Informs the delegate that the menu hovered on button with index.
 *
 *  @param anIndex index of button
 */
- (void)circleMenuHoverOnButtonWithIndex:(int)anIndex;
/*!
 * Gets called when the CircleMenu has been closed. This is usually
 * sent immediately after circleMenuActivatedButtonWithIndex:.
 */
- (void)circleMenuDidClosed:(WCCircularMenuView *)menuView;

@end

typedef enum {
    ALPHACircleMenuDirectionUp = 1,
    ALPHACircleMenuDirectionRight,
    ALPHACircleMenuDirectionDown,
    ALPHACircleMenuDirectionLeft
} ALPHACircleMenuDirection;

@interface WCCircularMenuViewSetting : NSObject

@property (nonatomic, strong) UIColor *menuButtonNormalColor;
@property (nonatomic, strong) UIColor *menuButtonActiveColor;
@property (nonatomic, strong) UIColor *menuButtonBorderColor;
@property (nonatomic, assign) BOOL menuButtonShowShadow;
@property (nonatomic, assign) CGFloat menuButtonRadius;
@property (nonatomic, assign) CGFloat menuButtonBorderWidth;

@property (nonatomic, assign) CGFloat menuOpenDuration;
@property (nonatomic, assign) CGFloat menuCloseDuration;
@property (nonatomic, assign) CGFloat menuOpenDelay;

@property (nonatomic, assign) CGFloat menuRadius;
@property (nonatomic, assign) CGFloat menuMaxAngle;
@property (nonatomic, assign) ALPHACircleMenuDirection menuDirection;

@property (nonatomic, assign, readonly) CGFloat menuTotalRadius;

+ (instancetype)preset;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;

@end

@interface WCCircularMenuView : UIView

@property (weak, nonatomic) id<ALPHACircleMenuDelegate> delegate;

/*!
 * Initializes the ALPHACircleMenuView.
 * @param aPoint the center of the menu's circle
 * @param anOptionsDictionary optional configuration, may be nil
 * @param anImageArray array of images to be used for the buttons,
 *                     currently icon images should be 32x32 points
 *                     (64x64 px for retina)
 */
- (id)initWithSetting:(WCCircularMenuViewSetting *)setting atCenter:(CGPoint)aPoint menuButtonImages:(NSArray*)anImageArray;

/*!
 * Opens the menu with the buttons and settings specified in the
 * initializer.
 * @param aRecognizer the UILongPressGestureRecognizer that has been
 *                    used to detect the long press. This recognizer
 *                    will be used to track further drag gestures to
 *                    select a button and to close the menu, once the 
 *                    gesture ends.
 */
- (void)openMenuWithTapGesture:(UIGestureRecognizer*)aRecognizer;

/*!
 * Offers the possibility to close the menu externally.
 */
- (void)closeMenu;

- (void)updateWithSetting:(WCCircularMenuViewSetting *)setting;

@end

@interface ALPHARoundView : UIView

@end

