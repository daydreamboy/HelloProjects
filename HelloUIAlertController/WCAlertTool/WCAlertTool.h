//
//  WCAlertTool.h
//  HelloUIAlertController
//
//  Created by wesley_chen on 2019/1/16.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCAlertTool : NSObject

+ (void)presentAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle cancelButtonDidClickBlock:(nullable void (^)(void))cancelButtonDidClickBlock;


#pragma mark > Show Action Sheet

/**
 Show action sheet

 @param title the title
 @param message the message
 @param cancelButtonTitle the title of cancel button
 @param cancelButtonDidClickBlock the callback when cancel button did click
 @param ... the pair list terminated by nil
 - The first object is NSString which is button title
 - The second object is block which called when button clicked
 */
+ (void)presentActionSheetWithTitle:(NSString *)title message:(nullable NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle cancelButtonDidClickBlock:(nullable void (^)(void))cancelButtonDidClickBlock, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)presentActionSheetWithTitle:(NSString *)title message:(nullable NSString *)message buttonTitles:(NSArray<NSString *> *)buttonTitles buttonDidClickBlocks:(NSArray *)buttonDidClickBlocks;

@end

NS_ASSUME_NONNULL_END
