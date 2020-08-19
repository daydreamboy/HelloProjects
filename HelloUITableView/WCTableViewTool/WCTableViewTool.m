//
//  WCTableViewTool.m
//  HelloUITableView
//
//  Created by wesley_chen on 2018/11/19.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCTableViewTool.h"

@implementation WCTableViewTool

+ (BOOL)performOperationKeepStaticWithTableView:(UITableView *)tableView block:(void (^)(void))block {
    if (![tableView isKindOfClass:[UITableView class]] || !block) {
        return NO;
    }
    
    CGSize beforeContentSize = tableView.contentSize;
    
    block();

    CGSize afterContentSize = tableView.contentSize; 
    CGPoint afterContentOffset = tableView.contentOffset;
    CGPoint newContentOffset = CGPointMake(afterContentOffset.x, afterContentOffset.y + afterContentSize.height - beforeContentSize.height);
    
    tableView.contentOffset = newContentOffset;
    
    return YES;
}

@end


