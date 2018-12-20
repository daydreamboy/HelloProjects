//
//  WCNavigationBar.m
//  HelloUINavigationBar
//
//  Created by wesley_chen on 2018/12/20.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCNavigationBar.h"

// >= `11.0`
#ifndef IOS11_OR_LATER
#define IOS11_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@implementation WCNavigationBar

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (IOS11_OR_LATER) {
        if (self.allowBarButtonSystemItemFixedSpaceNegativeWidth) {
            for (UIView *subview in [self subviews]) {
                subview.layoutMargins = UIEdgeInsetsZero;
            }
        }
    }
}

@end
