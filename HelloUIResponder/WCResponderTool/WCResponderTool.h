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
 Get the current first responder

 @return the current first responder
 @discussion Don't strongly retain the current first responder
 */
+ (nullable id)currentFirstResponder;

@end

NS_ASSUME_NONNULL_END
