//
//  CollectionViewFlowLayoutLeftAligned.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/6/12.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "CollectionViewFlowLayoutLeftAligned.h"

@implementation CollectionViewFlowLayoutLeftAligned

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *attr in attributes) {
        if (attr.representedElementKind) {
            NSIndexPath *indexPath = attr.indexPath;
            attr.frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
        }
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    UIEdgeInsets sectionInset = [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout sectionInset];
    if (indexPath.item == 0) {
        CGRect frame = attr.frame;
        frame.origin.x = sectionInset.left;
        attr.frame = frame;
        
        return attr;
    }
    
    NSIndexPath *previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
    CGRect previousFrame = [self layoutAttributesForItemAtIndexPath:previousIndexPath].frame;
    CGFloat previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width + self.interitemSpacing;
    
    CGRect currentFrame = attr.frame;
    CGRect stretchedCurrentFrame = CGRectMake(0, currentFrame.origin.y, self.collectionView.frame.size.width, currentFrame.size.height);
    
    if (!CGRectIntersectsRect(previousFrame, stretchedCurrentFrame)) {
        CGRect frame = attr.frame;
        frame.origin.x = sectionInset.left;
        attr.frame = frame;
        
        return attr;
    }
    
    CGRect frame = attr.frame;
    frame.origin.x = previousFrameRightPoint;
    attr.frame = frame;
    
    return attr;
}

@end
