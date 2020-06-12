//
//  WCTableViewCellTool.m
//  HelloUITableView
//
//  Created by wesley_chen on 2020/6/12.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCTableViewCellTool.h"

@implementation WCTableViewCellTool

+ (nullable UITableView *)superTableViewWithCell:(UITableViewCell *)cell {
    UITableView *tableView = nil;
    @try {
        tableView = [cell valueForKey:@"_tableView"];
    } @catch (NSException *exception) {
    }
    
    if (![tableView isKindOfClass:[UITableView class]]) {
        id view = [(UIView *)cell superview];
        while (view && [view isKindOfClass:[UITableView class]] == NO) {
            view = [view superview];
        }
        tableView = (UITableView *)view;
    }
    
    return tableView;
}

+ (BOOL)setCheckmarkTintColorWithCell:(UITableViewCell *)cell tintColor:(nullable UIColor *)tintColor {
    
    UIView *cellEditControl;
    if (NSClassFromString(@"UITableViewCellEditControl")) {
        for (UIView *subview in cell.subviews) {
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellEditControl"]) {
                cellEditControl = subview;
                break;
            }
        }
    }
    
    if (cellEditControl) {
#if __IPHONE_13_0
        UIColor *defaultColor = [UIColor systemBlueColor];
#else
        UIColor *defaultColor = [UIColor blueColor];
#endif
        cellEditControl.tintColor = tintColor ?: defaultColor;
    }
    
    return YES;
}

@end
