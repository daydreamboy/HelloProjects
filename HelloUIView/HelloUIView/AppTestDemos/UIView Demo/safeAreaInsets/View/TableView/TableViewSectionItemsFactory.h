//
//  TableViewSectionItemsFactory.h
//  HelloUIView
//
//  Created by wesley_chen on 2019/11/17.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TableViewSectionItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface TableViewSectionItemsFactory : NSObject
+ (NSArray<TableViewSectionItem *> *)sectionItemsWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
