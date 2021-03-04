//
//  WCTableViewTool.m
//  HelloUITableView
//
//  Created by wesley_chen on 2018/11/19.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCTableViewTool.h"

// >= `11.0`
#ifndef IOS11_OR_LATER
#define IOS11_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@implementation WCTableViewTool

#pragma mark - Update TableView

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

+ (BOOL)performBatchUpdatesWithTableView:(UITableView *)tableView batchUpdates:(void (^)(void))updates completion:(void (^)(BOOL finished))completion {
    if (![tableView isKindOfClass:[UITableView class]] || !tableView.dataSource) {
        return NO;
    }
    
    if (IOS11_OR_LATER) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
        [tableView performBatchUpdates:updates completion:completion];
#pragma GCC diagnostic pop
    }
    else {
        [tableView beginUpdates];
        !updates ?: updates();
        [tableView endUpdates];
        
        !completion ?: completion(YES);
    }
    
    return YES;
}

#pragma mark - NSIndexPath

#pragma mark > Check NSIndexPath

+ (BOOL)checkIndexPathsValidWithTableView:(UITableView *)tableView indexPaths:(NSArray *)indexPaths {
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

#pragma mark > Query NSIndexPath

+ (nullable NSIndexPath *)indexPathForSubviewInTableViewCell:(UIView *)subview tableView:(UITableView *)tableView {
    if (![subview isKindOfClass:[UIView class]] || ![tableView isKindOfClass:[UITableView class]]) {
        return nil;
    }
    
    UIView *cell = subview;
    static const NSUInteger sMaxCount = 30;
    NSUInteger count = 0;
    while (![cell isKindOfClass:[UITableViewCell class]] || count <= sMaxCount) {
        cell = (UIView *)[cell nextResponder];
        if (![cell isKindOfClass:[UIView class]]) {
            break;
        }
        
        ++count;
    }
    
    if ([cell isKindOfClass:[UITableViewCell class]]) {
        return [tableView indexPathForCell:(UITableViewCell *)cell];
    }
    else {
        return nil;
    }
}

@end


