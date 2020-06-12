//
//  WCTableViewCellTool.h
//  HelloUITableView
//
//  Created by wesley_chen on 2020/6/12.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCTableViewCellTool : NSObject

+ (nullable UITableView *)superTableViewWithCell:(UITableViewCell *)cell;
+ (BOOL)setCheckmarkTintColorWithCell:(UITableViewCell *)cell tintColor:(nullable UIColor *)tintColor;

@end

NS_ASSUME_NONNULL_END
