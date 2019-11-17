//
//  TableViewSectionItemsFactory.m
//  HelloUIView
//
//  Created by wesley_chen on 2019/11/17.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "TableViewSectionItemsFactory.h"

@implementation TableViewSectionItemsFactory

+ (NSArray<TableViewSectionItem *> *)sectionItemsWithTableView:(UITableView *)tableView {
    return @[
        [self adjustmentBehaviorSectionItemWithTableView:tableView],
        [self insetsContentViewsToSafeAreaSectionItemWithTableView:tableView],
        [self customCellsSectionItemWithTableView:tableView],
    ];
}

#pragma mark - Private

+ (TableViewSectionItem *)adjustmentBehaviorSectionItemWithTableView:(UITableView *)tableView {
    TableViewSectionItem *item = [TableViewSectionItem new];
    
    return item;
}

+ (TableViewSectionItem *)insetsContentViewsToSafeAreaSectionItemWithTableView:(UITableView *)tableView {
    TableViewSectionItem *item = [TableViewSectionItem new];
    
    return item;
}

+ (TableViewSectionItem *)customCellsSectionItemWithTableView:(UITableView *)tableView {
    TableViewSectionItem *item = [TableViewSectionItem new];
    
    return item;
}

@end
