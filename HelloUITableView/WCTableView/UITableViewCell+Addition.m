//
//  UITableViewCell+Addition.m
//  WCTableView
//
//  Created by wesley chen on 15/4/12.
//  Copyright (c) 2015年 wesley chen. All rights reserved.
//

#import "UITableViewCell+Addition.h"

@implementation UITableViewCell (Addition)

/*!
 *  Get its tableView from the cell
 *
 *  @sa http://stackoverflow.com/questions/15711645/how-to-get-uitableview-from-uitableviewcell
 */
- (UITableView *)superTableView {
    
    id view = [(UIView *)self superview];
    while (view && [view isKindOfClass:[UITableView class]] == NO) {
        view = [view superview];
    }
    UITableView *tableView = (UITableView *)view;
    
    return tableView;
}

@end
