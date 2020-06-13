//
//  WCIndexedCell.h
//  HelloUITableView
//
//  Created by wesley_chen on 2020/6/13.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCIndexedCell : UITableViewCell

- (void)configureCellAtIndexPath:(NSIndexPath *)indexPath configureBlock:(void (^)(void))configureBlock;
- (BOOL)setAttributeValue:(id)value forAttributeKey:(NSString *)key;
- (nullable id)attributeValueForAttributeKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
