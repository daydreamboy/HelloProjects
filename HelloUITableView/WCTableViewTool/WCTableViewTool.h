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

@end



NS_ASSUME_NONNULL_END
