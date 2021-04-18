//
//  WCTableViewIndexView.h
//  HelloUITableView
//
//  Created by wesley_chen on 2021/4/19.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WCTableViewIndexView;

@protocol TableIndexViewDelegate <NSObject>

- (void)tableViewIndexView:(WCTableViewIndexView *)tableIndexView didSwipeToSection:(NSUInteger)section;

@end

// TODO
// @see https://stackoverflow.com/questions/5987399/custom-uitableview-section-index
@interface WCTableViewIndexView : UIView

@property (nonatomic, weak) id<TableIndexViewDelegate> delegate;
@property (nonatomic)         NSUInteger numberOfSections;

- (instancetype)initWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
