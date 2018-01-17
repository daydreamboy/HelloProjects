//
//  WCTableViewCell.h
//  LotteryMate
//
//  Created by wesley chen on 15/6/2.
//  Copyright (c) 2015年 Qihoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCTableViewCell : UITableViewCell

/*!
 *  Compatible with iOS 7+
 */
@property (nonatomic, assign) UIEdgeInsets separatorInset;
// Conflicted with private separatorColor setter method
//@property (nonatomic, strong) UIColor *separatorColor;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

// Subclass's super methods
+ (WCTableViewCell *)cellForTableView:(UITableView *)tableView cellClass:(Class)cellClass cellIdentifier:(NSString *)cellIdentifier;

// Subclass's override methods
+ (instancetype)cellForTableView:(UITableView *)tableView;
+ (CGFloat)cellHeight;
+ (CGFloat)cellDynamicHeightWithData:(id)object;
- (void)setData:(id)object;

@end
