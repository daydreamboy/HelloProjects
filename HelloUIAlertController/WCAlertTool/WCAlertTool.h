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

/**
 Show alert or action sheet

 @param style the style of alert or action sheet
 @param title the title
 @param message the message
 @param buttonTitles the array of button titles. The first title is the canel button's.
 @param buttonDidClickBlocks the array of button click blocks. The first block is the canel button's.
 - the signature of block is void (^block)(void).
 */
+ (void)presentAlertWithStyle:(UIAlertControllerStyle)style title:(NSString *)title message:(nullable NSString *)message buttonTitles:(NSArray<NSString *> *)buttonTitles buttonDidClickBlocks:(NSArray *)buttonDidClickBlocks;

/**
 Show alert or action sheet

 @param style the style of alert or action sheet
 @param title the title
 @param message the message
 @param cancelButtonTitle the title of cancel button
 @param cancelButtonDidClickBlock the callback when cancel button did click
 @param ... the pair list terminated by nil
 - The first object is NSString which is button title
 - The second object is block which called when button clicked
 */
+ (void)presentAlertWithStyle:(UIAlertControllerStyle)style title:(NSString *)title message:(nullable NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle cancelButtonDidClickBlock:(void (^)(void))cancelButtonDidClickBlock, ... NS_REQUIRES_NIL_TERMINATION;

@end

NS_ASSUME_NONNULL_END
