//
//  WCNavigationBarTool.h
//  HelloUINavigationBar
//
//  Created by wesley_chen on 2018/4/26.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

@import Foundation;
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface WCNavigationBarTool : NSObject

/**
 Change color of hair line (below NavBar)

 @param navigationBar the nav bar (from viewController.navigationController.navigationBar)
 @param color the color. If nil, set it to system-default. If clearColor, will hide the hair line
 */
+ (void)setNavBar:(UINavigationBar *)navigationBar hairLineColor:(UIColor *)color;

/**
 Set background and hair line to transparent

 @param navigationBar the nav bar
 @param transparent YES if set transparent, NO if resume the system style
 @discussion This method will set barTintColor to nil and translucent to YES
 */
+ (void)setNavBar:(UINavigationBar *)navigationBar transparent:(BOOL)transparent;

@end

NS_ASSUME_NONNULL_END
