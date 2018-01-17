//
//  WCTableView.h
//  LotteryMate
//
//  Created by chenliang-xy on 15/6/2.
//  Copyright (c) 2015年 Qihoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCTableView : UITableView

/*!
 *  Compatible with iOS 7+
 */
@property (nonatomic, assign) UIEdgeInsets separatorInset;
/*!
 *  If WCTableView has table view header, make the area that scrolled-over down same color as <tableView>.tableHeaderView
 */
@property (nonatomic, assign) BOOL extendTableViewHeaderColor;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
- (void)registerCellClass:(Class)cellClass;

@end
