//
//  WCWindowTool.h
//  HelloUIWindow
//
//  Created by wesley_chen on 2019/4/22.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCWindowTool : NSObject

/**
 Get the current visible view controller in the window

 @param window the window
 @return the view controler which visible in the window
 @see https://stackoverflow.com/questions/11637709/get-the-current-displaying-uiviewcontroller-on-the-screen-in-appdelegate-m
 */
+ (UIViewController *)visibleViewControllerWithWindow:(UIWindow *)window;
@end

NS_ASSUME_NONNULL_END
