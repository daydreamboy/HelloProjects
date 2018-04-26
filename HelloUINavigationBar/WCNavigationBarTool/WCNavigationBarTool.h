//
//  WCNavigationBarTool.h
//  HelloUINavigationBar
//
//  Created by wesley_chen on 2018/4/26.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface WCNavigationBarTool : NSObject

/**
 Change color of hair line (below NavBar)

 @param navigationBar the nav bar
 @param color the color. If nil, set it to system-default. If clearColor, will hide the hair line
 */
+ (void)setNavBar:(UINavigationBar *)navigationBar hairLineColor:(UIColor *)color;
@end
