//
//  TableViewSectionItem.h
//  HelloUIView
//
//  Created by wesley_chen on 2019/11/17.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TableViewCellItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface TableViewSectionItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, strong) NSMutableArray<TableViewCellItem *> *cellItems;
@end

NS_ASSUME_NONNULL_END
