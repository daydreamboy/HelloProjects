//
//  CollectionViewFlowLayoutSeparator.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/6/12.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "CollectionViewFlowLayoutSeparator.h"

@implementation CollectionViewFlowLayoutSeparator

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *layoutAttributesArray = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
    
    NSMutableArray *decorationAttributes = [NSMutableArray array];
    NSArray *visibleIndexPaths = [self indexPathsOfSeparatorsInRect:rect]; // will implement below
    
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForDecorationViewOfKind:@"Separator" atIndexPath:indexPath];
        [decorationAttributes addObject:attributes];
    }
    
    return [layoutAttributesArray arrayByAddingObjectsFromArray:decorationAttributes];
}

- (NSArray*)indexPathsOfSeparatorsInRect:(CGRect)rect {
    NSInteger firstCellIndexToShow = floorf(rect.origin.y / self.itemSize.height);
    NSInteger lastCellIndexToShow = floorf((rect.origin.y + CGRectGetHeight(rect)) / self.itemSize.height);
    NSInteger countOfItems = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    
    NSMutableArray* indexPaths = [NSMutableArray new];
    for (NSInteger i = MAX(firstCellIndexToShow, 0); i <= lastCellIndexToShow; i++) {
        if (i < countOfItems) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
    }
    return indexPaths;
}

@end
