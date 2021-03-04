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

#pragma mark - Update TableView

/**
 Perform operate table view and keep table view not scrolling (static)
 
 @param tableView the table view
 @param block the operation in the block
 
 @return YES if called successfully, or NO it failed
 @see https://stackoverflow.com/questions/4279730/keep-uitableview-static-when-inserting-rows-at-the-top
 */
+ (BOOL)performOperationKeepStaticWithTableView:(UITableView *)tableView block:(void (^)(void))block;

/**
 Safe perform table view update operations
 
 @param tableView the table view
 @param updates the block to perform update (insert, delete, move, reload)
 @param completion the block to completion when update finished
 
 @return YES if called successfully, or NO it failed
 @discussion If iOS >= 11, use -[UITableView performBatchUpdates:completion:] internally, otherwise use beginUpdates/endUpdates instead
 */
+ (BOOL)performBatchUpdatesWithTableView:(UITableView *)tableView batchUpdates:(void (^)(void))updates completion:(void (^)(BOOL finished))completion;

#pragma mark - NSIndexPath

#pragma mark > Check NSIndexPath

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

#pragma mark > Query NSIndexPath

/**
 Get index path for the subview in table view cell
 
 @param subview the subview which expected in UITableViewCell
 @param tableView the table view
 
 @return the index path for the subview. Return nil if the subview in the UITableViewCell, or the subview's hierarchy level nested in subview exceed 30
 */
+ (nullable NSIndexPath *)indexPathForSubviewInTableViewCell:(UIView *)subview tableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
