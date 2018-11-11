//
//  WCViewControllerTool.h
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2018/11/11.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCViewControllerTool : NSObject

@end

@interface WCViewControllerTool ()
/**
 Get the top most view controller on the specific window
 
 @param window the window
 @return the top most view controller
 */
+ (nullable UIViewController *)topViewControllerOnWindow:(UIWindow *)window;
@end

NS_ASSUME_NONNULL_END
