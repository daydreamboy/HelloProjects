//
//  WCApplicationTool.h
//  HelloUIApplication
//
//  Created by wesley_chen on 2019/2/25.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCApplicationTool : NSObject

/**
 Get the window which owns the presented keyboard

 @return the window which presenting the keyboard. Return nil if the keyboard not show
 @discussion Use this method on your risk for it uses private class
 */
+ (nullable UIWindow *)currentKeyboardWindow;

@end

NS_ASSUME_NONNULL_END
