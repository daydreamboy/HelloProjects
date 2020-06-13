//
//  WCCheckmarkCell.m
//  HelloUITableView
//
//  Created by wesley_chen on 2020/6/12.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCCustomizeSystemCheckmarkCell.h"

@interface WCCustomizeSystemCheckmarkCell ()
@property (nonatomic, strong, readwrite) UIButton *checkmarkButton;
@end

@implementation WCCustomizeSystemCheckmarkCell

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    // Note: when cell is editing, the subviews in contentView is not interactive
    self.contentView.userInteractionEnabled = editing ? NO : YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _checkmarkButton.selected = selected;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [_checkmarkButton removeFromSuperview];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Note: If the cell height is 0, not need to add _checkmarkButton
    if (_checkmarkButton && CGRectGetHeight(self.bounds) > 0) {
        UIView *cellEditControl;
        
        if (NSClassFromString(@"UITableViewCellEditControl")) {
            for (UIView *subview in self.subviews) {
                if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellEditControl"]) {
                    cellEditControl = subview;
                    cellEditControl.hidden = YES;
                    break;
                }
            }
        }
        
        if (!_checkmarkButton.superview) {
            [self addSubview:_checkmarkButton];
        }

        UIEdgeInsets paddings = UIEdgeInsetsEqualToEdgeInsets(_checkmarkButtonInsets, UIEdgeInsetsZero)
            ? UIEdgeInsetsMake((CGRectGetHeight(self.bounds) - CGRectGetHeight(_checkmarkButton.bounds)) / 2.0, 0, (CGRectGetHeight(self.bounds) -  CGRectGetHeight(_checkmarkButton.bounds)) / 2.0, 0)
            : _checkmarkButtonInsets;
        
        CGFloat offsetXForCheckmarkButton = self.isEditing ? paddings.left : (-(paddings.left + CGRectGetWidth(_checkmarkButton.bounds)));
        if (self.disableShiftContentViewWhileEditing) {
            CGRect frame = self.contentView.frame;
            frame.origin.x = 0;
            self.contentView.frame = frame;
        }

        _checkmarkButton.frame = CGRectMake(offsetXForCheckmarkButton, paddings.top, CGRectGetWidth(_checkmarkButton.bounds), CGRectGetHeight(_checkmarkButton.bounds));
    }
}

#pragma mark - Getter

- (UIButton *)checkmarkButton {
    if (!_checkmarkButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

        _checkmarkButton = button;
    }

    return _checkmarkButton;
}

@end
