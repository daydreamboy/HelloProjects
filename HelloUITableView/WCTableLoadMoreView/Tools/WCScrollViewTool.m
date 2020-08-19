//
//  WCScrollViewTool.m
//  HelloUITableView
//
//  Created by wesley_chen on 2020/8/19.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCScrollViewTool.h"

// >= `11.0`
#ifndef IOS11_OR_LATER
#define IOS11_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@implementation WCScrollViewTool

+ (BOOL)scrollToTopOfListWithTableView:(UITableView *)tableView animated:(BOOL)animated considerSafeArea:(BOOL)considerSafeArea {
    if (![tableView isKindOfClass:[UITableView class]]) {
        return NO;
    }
    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
    CGFloat safeAreaTopInset = (considerSafeArea && IOS11_OR_LATER) ? tableView.safeAreaInsets.bottom : 0;
#pragma GCC diagnostic pop
    
    CGPoint contentOffset = CGPointMake(tableView.contentOffset.x, 0 - safeAreaTopInset + tableView.tableHeaderView.bounds.size.height);
    [tableView setContentOffset:contentOffset animated:animated];
    
    return YES;
}

+ (BOOL)scrollToBottomOfListWithTableView:(UITableView *)tableView animated:(BOOL)animated considerSafeArea:(BOOL)considerSafeArea {
    if (![tableView isKindOfClass:[UITableView class]]) {
        return NO;
    }
    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
    CGFloat safeAreaBottomInset = (considerSafeArea && IOS11_OR_LATER) ? tableView.safeAreaInsets.bottom : 0;
#pragma GCC diagnostic pop
    
    CGPoint contentOffset = CGPointMake(tableView.contentOffset.x, tableView.contentSize.height - tableView.bounds.size.height - tableView.tableFooterView.bounds.size.height + safeAreaBottomInset);
    [tableView setContentOffset:contentOffset animated:animated];
    
    return YES;
}

+ (BOOL)scrollToBottomWithScrollView:(UIScrollView *)scrollView animated:(BOOL)animated {
    if (![scrollView isKindOfClass:[UIScrollView class]]) {
        return NO;
    }
    
    // @see https://stackoverflow.com/a/38241928
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
    CGPoint contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height - scrollView.bounds.size.height + (IOS11_OR_LATER ? scrollView.adjustedContentInset.bottom : scrollView.contentInset.bottom));
#pragma GCC diagnostic pop
    [scrollView setContentOffset:contentOffset animated:animated];
    
    return YES;
}


@end
