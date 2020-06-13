//
//  WCCheckmarkCell.h
//  HelloUITableView
//
//  Created by wesley_chen on 2020/6/12.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCCustomizeSystemCheckmarkCell : UITableViewCell
@property (nonatomic, strong, readonly) UIButton *checkmarkButton;
@property (nonatomic, assign) UIEdgeInsets checkmarkButtonInsets;
/// Decide if shift the content view when change to editing mode
@property (nonatomic, assign) BOOL disableShiftContentViewWhileEditing;
@end

NS_ASSUME_NONNULL_END
