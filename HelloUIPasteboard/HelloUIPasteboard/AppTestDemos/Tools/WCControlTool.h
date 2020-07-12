//
//  WCControlTool.h
//  HelloUIPasteboard
//
//  Created by wesley_chen on 2020/7/11.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCControlTool : NSObject

#pragma mark - Target-Action Block/Normal Style

#pragma mark > Add

/**
 Add the handle block to UIControl for the specific UIControlEvents
 
 @param control the UIControl
 @param events the UIControlEvents
 @param block the block
 - sender the sender (UIControl)
 
 @return YES if operate successfully, NO if parameters are not correct.
 @see https://github.com/ibireme/YYKit/blob/master/YYKit/Base/UIKit/UIControl%2BYYAdd.m
 */
+ (BOOL)addBlockForControl:(UIControl *)control events:(UIControlEvents)events block:(void (^)(id sender))block;

#pragma mark > Replace

/**
 Reset the handle block to UIControl for the specific UIControlEvents
 
 @param control the UIControl
 @param events the UIControlEvents
 @param block the block
 - sender the sender (UIControl)
 
 @return YES if operate successfully, NO if parameters are not correct.
 
 @discussion This method not affects the target added by target-action style
 @warning This method will remove the blocks added by +[WCControlTool addBlockForControl:events:block:]
 */
+ (BOOL)setBlockForControl:(UIControl *)control events:(UIControlEvents)events block:(void (^)(id sender))block;

/**
 Reset the targets of UIControl for the specific UIControlEvents
 
 @param control the UIControl
 @param target the target (id)
 @param action the action (SEL)
 @param events the UIControlEvents
 
 @return YES if operate successfully, NO if parameters are not correct.
 @warning This method will affects the blocks added by +[WCControlTool addBlockForControl:events:block:] or
 setted by +[WCControlTool setBlockForControl:events:block:]
 */
+ (BOOL)setTargetToContorl:(UIControl *)control target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)events;

#pragma mark > Remove

/**
 Remove the handle blocks only not affects the target-action style
 
 @param control the UIControl
 @param events the UIControlEvents
 
 @return YES if operate successfully, NO if parameters are not correct.
 */
+ (BOOL)removeAllBlocksForControl:(UIControl *)control events:(UIControlEvents)events;

/**
 Remove all targets includes blocks
 
 @param control the UIControl
 
 @return YES if operate successfully, NO if parameters are not correct.
 */
+ (BOOL)removeAllTargetsForControl:(UIControl *)control;

@end

NS_ASSUME_NONNULL_END
