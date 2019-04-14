//
//  MyTableViewCell.m
//  HelloUIResponder
//
//  Created by wesley_chen on 2019/4/14.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

- (void)deleteCell:(id)sender {
    if ([self.delegate respondsToSelector:@selector(myTableViewCellMenuItemDeleteDidClick:)]) {
        [self.delegate myTableViewCellMenuItemDeleteDidClick:self];
    }
}

- (void)reloadTable:(id)sender {
    if ([self.delegate respondsToSelector:@selector(myTableViewCellMenuItemReloadTableDidClick:)]) {
        [self.delegate myTableViewCellMenuItemReloadTableDidClick:self];
    }
}

@end
