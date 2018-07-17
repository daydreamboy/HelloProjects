//
//  WCHorizontalSliderViewLayout.m
//  WCEmotionPanelView
//
//  Created by wesley_chen on 2018/6/12.
//

#import "WCHorizontalSliderViewLayout.h"

@implementation WCHorizontalSliderViewBaseCellSeparator

@dynamic color;

static UIColor *sColor;

+ (UIColor *)color {
    return sColor;
}

+ (void)setColor:(UIColor *)color {
    sColor = color;
}

#pragma mark -

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = self.class.color;
    }
    
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    self.frame = layoutAttributes.frame;
    self.backgroundColor = self.class.color;
}

@end

@implementation WCHorizontalSliderViewLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *layoutAttributes = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
    
    NSMutableArray *decorationAttrs = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *cellAttr in layoutAttributes) {
        NSIndexPath *indexPath = cellAttr.indexPath;
        NSInteger numberOfItemsInSection = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:indexPath.section];
        
        if (indexPath.row < numberOfItemsInSection - 1) {
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForDecorationViewOfKind:@"Separator" atIndexPath:indexPath];
            [decorationAttrs addObject:attributes];
        }
    }
    [layoutAttributes addObjectsFromArray:decorationAttrs];
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *cellAttr = [self layoutAttributesForItemAtIndexPath:indexPath];
    
    UICollectionViewLayoutAttributes *decorationAttr = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        CGFloat minimumLineSpacing = self.minimumLineSpacing;
        
        id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
        if ([delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
            minimumLineSpacing = [delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:indexPath.section];
        }
        
        decorationAttr.frame = CGRectMake(CGRectGetMinX(cellAttr.frame), CGRectGetMaxY(cellAttr.frame), cellAttr.size.width, minimumLineSpacing);
    }
    else {
        CGFloat minimumInteritemSpacing = self.minimumInteritemSpacing;
        
        id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
        if ([delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
            minimumInteritemSpacing = [delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:indexPath.section];
        }
        
        decorationAttr.frame = CGRectMake(CGRectGetMaxX(cellAttr.frame), CGRectGetMinY(cellAttr.frame), minimumInteritemSpacing, cellAttr.size.height);
    }
    decorationAttr.zIndex = 1000;
    
    return decorationAttr;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingDecorationElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)decorationIndexPath {
    UICollectionViewLayoutAttributes *layoutAttributes =  [self layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:decorationIndexPath];
    return layoutAttributes;
}

@end
