//
//  WCTintSystemCheckmarkCell.m
//  HelloUITableView
//
//  Created by wesley_chen on 2020/6/13.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCTintSystemCheckmarkCell.h"

@implementation WCTintSystemCheckmarkCell

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    // Note: when cell is editing, the subviews in contentView is not interactive
    self.contentView.userInteractionEnabled = editing ? NO : YES;
}

- (void)setCheckmarkTintColor:(nullable UIColor *)checkmarkTintColor {
    [super setAttributeValue:(checkmarkTintColor ?: [NSNull null]) forAttributeKey:@"checkmarkTintColor"];
}

- (nullable UIColor *)checkmarkTintColor {
    return [super attributeValueForAttributeKey:@"checkmarkTintColor"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Note: indexPathForCell not works even though the cell is visible
    //NSIndexPath *indexPath = [tableView indexPathForCell:self];

    UIView *cellEditControl;
    UIColor *checkmarkTintColor = self.checkmarkTintColor;
    if (checkmarkTintColor) {
        if (NSClassFromString(@"UITableViewCellEditControl")) {
            for (UIView *subview in self.subviews) {
                if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellEditControl"]) {
                    cellEditControl = subview;
                    break;
                }
            }
        }

        if (cellEditControl) {
            cellEditControl.tintColor = [checkmarkTintColor isKindOfClass:[UIColor class]] ? checkmarkTintColor : [UIColor systemBlueColor];
        }
    }
}

@end
