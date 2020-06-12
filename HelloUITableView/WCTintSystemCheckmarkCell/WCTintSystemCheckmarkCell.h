//
//  WCCheckmarkCell.h
//  HelloUITableView
//
//  Created by wesley_chen on 2020/6/12.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCTintSystemCheckmarkCell : UITableViewCell
@property (nonatomic, strong) UIColor *checkmarkTintColor;
@property (nonatomic, strong, readonly) UIButton *checkmarkButton;
@property (nonatomic, assign) CGSize checkmarkButtonSize;
@property (nonatomic, assign) UIEdgeInsets checkmarkButtonInsets;
@property (nonatomic, assign) BOOL shiftContentViewWhileEditing;
@end

NS_ASSUME_NONNULL_END
