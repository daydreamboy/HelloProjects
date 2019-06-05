//
//  UITableView+Addition.h
//  LotteryMate
//
//  Created by wesley chen on 15/6/13.
//  Copyright (c) 2015年 Qihoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Addition)

@property (nonatomic, assign) BOOL removeRedudantSeparators;
@property (nonatomic, strong) UIView *emptyView;

- (NSIndexPath *)indexPathForRowContainsSubview:(UIView *)subview;

@end
