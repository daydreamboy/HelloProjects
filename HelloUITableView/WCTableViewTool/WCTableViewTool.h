//
//  WCTableViewTool.h
//  HelloUITableView
//
//  Created by wesley_chen on 2018/11/19.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCTableViewTool : NSObject

/**
 Perform operate table view and keep table view not scrolling (static)
 
 @param tableView the table view
 @param block the operation in the block
 
 @return YES if called successfully, or NO it failed
 @see https://stackoverflow.com/questions/4279730/keep-uitableview-static-when-inserting-rows-at-the-top
 */
+ (BOOL)performOperationKeepStaticWithTableView:(UITableView *)tableView block:(void (^)(void))block;

/**
 Check the index paths if safe to reload rows
 
 @param tableView the table view
 @param indexPaths the index paths to reload rows
 
 @return YES if the indexPaths are safe to reload rows, or NO if not
 
 @example
 if ([WCTableViewTool checkIndexPathsValidWithTableView:self.tableView indexPaths:indexPaths]) {
     [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
 }
 */
+ (BOOL)checkIndexPathsValidWithTableView:(UITableView *)tableView indexPaths:(NSArray *)indexPaths;

@end



NS_ASSUME_NONNULL_END
