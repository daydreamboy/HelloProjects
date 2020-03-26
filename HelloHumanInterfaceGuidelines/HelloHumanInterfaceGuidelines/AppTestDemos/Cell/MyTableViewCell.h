//
//  MyTableViewCell.h
//  HelloUIResponder
//
//  Created by wesley_chen on 2019/4/14.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MyTableViewCell;

@protocol MyTableViewCellDelete <NSObject>

- (void)myTableViewCellMenuItemDeleteDidClick:(MyTableViewCell *)cell;
- (void)myTableViewCellMenuItemReloadTableDidClick:(MyTableViewCell *)cell;

@end

@interface MyTableViewCell : UITableViewCell
@property (nonatomic, weak) id<MyTableViewCellDelete> delegate;
- (void)deleteCell:(id)sender;
- (void)reloadTable:(id)sender;
@end

NS_ASSUME_NONNULL_END
