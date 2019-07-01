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

/**
 A subclass of UIMenuItem with action block
 
 @discussion Other ways, see (1) https://stackoverflow.com/a/9874092,
    (2) https://github.com/steipete/PSMenuItem
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
 The initialize method

 @param title the title
 @param block the action block
 @return the instance
 */
- (instancetype)initWithTitle:(NSString *)title block:(void (^)(WCMenuItem *menuItem))block;

@end

/**
 The tool class with WCMenuItem in company
 */
@interface WCMenuItemTool : NSObject

/**
 The helper method for register menu items with the target view

 @param targetView the target view which will become first responder
 @param menuItems the array of UIMenuController.menuItems
 @return YES if registers all successfully. NO if registers failed for one or more menu items
 */
+ (BOOL)registerMenuItemsWithTargetView:(UIView *)targetView menuItems:(NSArray<WCMenuItem *> *)menuItems;

@end

NS_ASSUME_NONNULL_END
