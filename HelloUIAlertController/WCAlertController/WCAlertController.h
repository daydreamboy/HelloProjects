//
//  WCAlertController.h
//  HelloUIAlertController
//
//  Created by wesley_chen on 2018/8/15.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 A alert controller for show without UIViewController
 
 @see https://stackoverflow.com/a/30941356
 */
@interface WCAlertController : UIAlertController
- (void)show;
- (void)show:(BOOL)animated;
@end
