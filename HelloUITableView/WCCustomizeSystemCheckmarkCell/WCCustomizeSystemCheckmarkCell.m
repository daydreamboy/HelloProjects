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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _shiftContentViewWhileEditing = YES;
        _checkmarkButtonSize = CGSizeZero;
    }
    return self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    // Note: when cell is editing, the subviews in contentView is not interactive
    self.contentView.userInteractionEnabled = editing ? NO : YES;
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
    [super willTransitionToState:state];
}

- (void)didTransitionToState:(UITableViewCellStateMask)state {
    [super didTransitionToState:state];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.checkmarkButton.selected = selected;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIView *cellEditControl;
    
    switch (self.style) {
        case WCTintSystemCheckmarkCellStyleDefault:
        default: {
            break;
        }
        case WCTintSystemCheckmarkCellStyleTintColor: {
            break;
        }
        case WCTintSystemCheckmarkCellStyleCustomized: {
            break;
        }
    }
    
    if (self.checkmarkButtonSize.width > 0 && self.checkmarkButtonSize.height > 0) {
        
    }
    else if ([self.checkmarkTintColor isKindOfClass:[UIColor class]]) {
        if (NSClassFromString(@"UITableViewCellEditControl")) {
            for (UIView *subview in self.subviews) {
                if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellEditControl"]) {
                    cellEditControl = subview;
                    break;
                }
            }
        }
        
        cellEditControl.tintColor = self.checkmarkTintColor;
        if (cellEditControl) {
            NSLog(@"1");
        }
        else {
            NSLog(@"2");
        }
    }

    if (self.checkmarkButton) {
//        cellEditControl.hidden = YES;

        if (cellEditControl) {

        }

        BOOL isFirstLayoutSubviews = NO;
        if (!self.checkmarkButton.superview) {
            [self addSubview:self.checkmarkButton];
            isFirstLayoutSubviews = YES;
        }

        UIEdgeInsets paddings = UIEdgeInsetsEqualToEdgeInsets(self.checkmarkButtonInsets, UIEdgeInsetsZero)
                                ? UIEdgeInsetsMake(
                                                   (CGRectGetHeight(self.bounds) - CGRectGetHeight(self.checkmarkButton.bounds)) / 2.0,
                                                   (CGRectGetWidth(cellEditControl.bounds) - CGRectGetWidth(self.checkmarkButton.bounds)) / 2.0,
                                                   (CGRectGetHeight(self.bounds) - CGRectGetHeight(self.checkmarkButton.bounds)) / 2.0,
                                                   (CGRectGetWidth(cellEditControl.bounds) - CGRectGetWidth(self.checkmarkButton.bounds)) / 2.0
                                                   )
                                : self.checkmarkButtonInsets;

        CGFloat offsetXForCheckmarkButton = self.isEditing ? paddings.left : (-(paddings.right + CGRectGetWidth(self.checkmarkButton.bounds)));
        if (isFirstLayoutSubviews) {
            offsetXForCheckmarkButton = 0;//(-(paddings.right + CGRectGetWidth(self.checkmarkButton.bounds)));
        }

        CGFloat offsetXForContentView = (self.isEditing && self.shiftContentViewWhileEditing)
                                        ? (paddings.left + paddings.right + CGRectGetWidth(self.checkmarkButton.bounds))
                                        : 0;

        self.contentView.frame = CGRectMake(offsetXForContentView, 0, CGRectGetWidth(self.contentView.bounds), CGRectGetHeight(self.contentView.bounds));
        self.checkmarkButton.frame = CGRectMake(offsetXForCheckmarkButton, paddings.top, CGRectGetWidth(self.checkmarkButton.bounds), CGRectGetHeight(self.checkmarkButton.bounds));
    }
    else if (self.checkmarkTintColor) {
        
    }
}

#pragma mark - Getter

- (UIButton *)checkmarkButton {
    if (!_checkmarkButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsImageWhenHighlighted = NO;
        button.backgroundColor = [UIColor yellowColor];
        [button addTarget:self action:@selector(buttonCheckmarkClicked:) forControlEvents:UIControlEventTouchUpInside];

        _checkmarkButton = button;
    }

    return _checkmarkButton;
}

#pragma mark - Action

- (void)buttonCheckmarkClicked:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}

@end
