//
//  ToggleOptionPriorViewController.h
//  HelloKeyValueObserving
//
//  Created by wesley chen on 17/2/12.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToggleOptionPriorViewController : UIViewController
- (instancetype)initWithSwitcherOn:(BOOL)isOn switcherToggled:(void (^)(BOOL isOn))block;
@end
