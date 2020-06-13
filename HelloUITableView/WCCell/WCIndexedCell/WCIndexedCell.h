//
//  WCIndexedCell.h
//  HelloUITableView
//
//  Created by wesley_chen on 2020/6/13.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A indexed cell which holds its index path
 */
@interface WCIndexedCell : UITableViewCell

/**
 Configure the attributes of cell
 
 @param tableView the table view
 @param indexPath the index path
 @param configureBlock call setAttributeValue:forAttributeKey method in this block
 @warning This method should be only used in -tableView:cellForRowAtIndexPath:
 */
- (void)configureCellWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath configureBlock:(void (^)(void))configureBlock;

/**
 Set attribute value for key
 
 @param value the value
 @param key the key
 @return Return YES if set value successfully, or NO if fails
 @warning This method only take effective in the configureBlock of -configureCellAtIndexPath:configureBlock: method
 */
- (BOOL)setAttributeValue:(id)value forAttributeKey:(NSString *)key;

/**
 Get attribute value for key

 @param key the key
 @return the attribute value
 */
- (nullable id)attributeValueForAttributeKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
