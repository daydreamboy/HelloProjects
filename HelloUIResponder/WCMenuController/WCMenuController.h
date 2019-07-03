//
//  WCMenuController.h
//  HelloUIResponder
//
//  Created by wesley_chen on 2019/7/3.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCMenuItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface WCMenuController : UIMenuController

+ (instancetype)sharedMenuController;

/**
 The helper method for register menu items with the target view
 
 @param targetView the target view which will become first responder
 @param menuItems the array of UIMenuController.menuItems
 @return YES if registers all successfully. NO if registers failed for one or more menu items
 */
+ (BOOL)registerMenuItemsWithTargetView:(UIView *)targetView menuItems:(NSArray<WCMenuItem *> *)menuItems;

@end

NS_ASSUME_NONNULL_END
