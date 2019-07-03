//
//  WCMenuItem.h
//  HelloUIResponder
//
//  Created by wesley_chen on 2019/6/26.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WCMenuItemState) {
    WCMenuItemStateNormal,
    WCMenuItemStateSelected,
};

/**
 A subclass of UIMenuItem with following features
   - action block
   - togglable menu item
 
 @discussion This class used with WCMenuController in company
 
 @see https://stackoverflow.com/a/9874092,
 @see https://github.com/steipete/PSMenuItem
 */
@interface WCMenuItem : UIMenuItem

/**
 The block for action
 */
@property (nonatomic, copy) void (^block)(WCMenuItem *meuItem);

/**
 The target view to show menu controller
 */
@property (nonatomic, weak, readonly, nullable) UIView *targetView;

/**
 The menu controller
 
 @discussion Can get menuItems array from the the menu controller
 */
@property (nonatomic, weak, readonly, nullable) UIMenuController *menuController;

/**
 The selector prefix internally used. Use it in -[UIResponder canPerformAction:withSender:] method.
 
 @code
 - (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
     return (action == @selector(copy:) ||
             action == @selector(customAction:) ||
             [NSStringFromSelector(action) hasPrefix:[WCMenuItem actionPrefix]]);
 }
 @endcode
 */
@property (nonatomic, copy, class, readonly) NSString *actionPrefix;

/**
 The state of the menu item. See WCMenuItemState type
 
 @discussion The state won't change internally, and set the state before call
 -[WCMenuController setMenuVisible:animated:]
 */
@property (nonatomic, assign) WCMenuItemState state;

/**
 The initialize method

 @param title the title
 @param block the action block
 @return the instance
 */
- (instancetype)initWithTitle:(NSString *)title block:(void (^)(WCMenuItem *menuItem))block;

#pragma mark > State

/**
 Set the title for the state

 @param title the title when the menu item is on some state
 @param state the state
 */
- (void)setTitle:(NSString *)title forState:(WCMenuItemState)state;

/**
 Get the title for the state

 @param state the state
 @return the title for the state
 */
- (NSString *)titleForState:(WCMenuItemState)state;

@end

NS_ASSUME_NONNULL_END
