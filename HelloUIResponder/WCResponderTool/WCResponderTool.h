//
//  WCResponderTool.h
//  HelloUIResponder
//
//  Created by wesley_chen on 2019/4/14.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCResponderTool : NSObject

/**
 Get the current first responder by send action

 @return the current first responder
 @discussion Don't strongly retain the current first responder
 @note Recommend to use +[WCResponderTool findFirstResponder] instead
 */
+ (nullable id)currentFirstResponder;

/**
 Get the current first responder by check isFirstResponder recursively
 
 @return the current first responder
 @discussion
 1. Don't strongly retain the current first responder
 2. This method consumes more time than +[WCResponderTool currentFirstResponder], but more accurate,
    e.g. the custom view called becomeFirstResponder, the +[WCResponderTool currentFirstResponder] get the wrong responder
 @see https://stackoverflow.com/questions/1823317/get-the-current-first-responder-without-using-a-private-api
 */
+ (nullable id)findFirstResponder;

+ (nullable NSArray<UIResponder *> *)responderChainWithResponder:(UIResponder *)responder;

@end

NS_ASSUME_NONNULL_END
