//
//  TableViewSectionItem.m
//  HelloUIView
//
//  Created by wesley_chen on 2019/11/17.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "TableViewSectionItem.h"

@implementation TableViewSectionItem
- (instancetype)init {
    self = [super init];
    if (self) {
        _headerHeight = 44;
        _cellItems = [NSMutableArray array];
    }
    return self;
}
@end
