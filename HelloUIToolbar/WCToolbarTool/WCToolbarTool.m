//
//  WCToolbarTool.m
//  HelloUIToolbar
//
//  Created by wesley_chen on 2020/6/16.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCToolbarTool.h"

@implementation WCToolbarTool

+ (CGRect)frameForBarButtonItemWithToolbar:(UIToolbar *)toolbar barButtonItem:(UIBarButtonItem *)barButtonItem {
    UIControl *button = nil;
    for (UIView *subview in toolbar.subviews) {
        if ([subview isKindOfClass:[UIControl class]]) {
            for (id target in [(UIControl *)subview allTargets]) {
                if (target == barButtonItem) {
                    button = (UIControl *)subview;
                    break;
                }
            }
            if (button != nil) break;
        }
    }
    
    return button == nil ? CGRectZero : button.frame;
}

@end
