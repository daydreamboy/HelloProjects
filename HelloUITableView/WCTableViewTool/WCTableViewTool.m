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

+ (BOOL)checkWithTableView:(UITableView *)tableView canReloadRowsAtIndexPaths:(NSArray *)indexPaths {
    if (![tableView isKindOfClass:[UITableView class]] || !tableView.dataSource) {
        return NO;
    }
    
    if (![tableView.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return NO;
    }
    
    NSUInteger numberOfSections = [tableView.dataSource numberOfSectionsInTableView:tableView];
    
    __block BOOL indexPathsAreValid = YES;
    
    for (NSIndexPath *indexPath in indexPaths) {
        if (indexPath.section >= numberOfSections || indexPath.section < 0) {
            indexPathsAreValid = NO;
            break;
        }
    }
    
    if (!indexPathsAreValid) {
        return NO;
    }
        
    NSMutableDictionary<NSNumber *, NSMutableArray *> *indexPathsGroupedBySection = [NSMutableDictionary dictionaryWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        NSMutableArray *indexPaths = indexPathsGroupedBySection[@(indexPath.section)];
        
        if (!indexPaths) {
            indexPaths = [NSMutableArray array];
        }
        
        [indexPaths addObject:indexPath];
    }
    
    [indexPathsGroupedBySection enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSMutableArray * _Nonnull indexPaths, BOOL * _Nonnull stop) {
        NSUInteger numberOfRowsInSection = [tableView.dataSource tableView:tableView numberOfRowsInSection:[key unsignedIntegerValue]];
        
        for (NSIndexPath *indexPath in indexPaths) {
            if (indexPath.row >= numberOfRowsInSection || indexPath.row < 0) {
                indexPathsAreValid = NO;
                *stop = YES;
                break;
            }
        }
    }];
    
    return indexPathsAreValid;
}

@end


