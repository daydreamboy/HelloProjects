//
//  CollectionViewFlowLayoutDraggable.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/12/10.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "CollectionViewFlowLayoutDraggable.h"

@interface CollectionViewFlowLayoutDraggable ()
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong) NSIndexPath *originalIndexPath;
@property (nonatomic, strong) NSIndexPath *draggingIndexPath;
@property (nonatomic, strong) UIView *draggingView;
@property (nonatomic, assign) CGPoint dragOffset;
@end

@implementation CollectionViewFlowLayoutDraggable

- (void)prepareLayout {
    [super prepareLayout];
    [self installGestureRecognizer];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray<UICollectionViewLayoutAttributes *> *attributes = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        if (attribute.indexPath == self.draggingIndexPath) {
            [self applyDraggingAttributes:attribute];
        }
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = [super layoutAttributesForItemAtIndexPath:indexPath];
    if (attribute && indexPath == self.draggingIndexPath) {
        if (attribute.representedElementCategory == UICollectionElementCategoryCell) {
            [self applyDraggingAttributes:attribute];
        }
    }
    return attribute;
}

#pragma mark -

- (void)installGestureRecognizer {
    if (!self.longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecogized:)];
        _longPressGesture.minimumPressDuration = 0.2;
        [self.collectionView addGestureRecognizer:_longPressGesture];
    }
}

- (void)applyDraggingAttributes:(UICollectionViewLayoutAttributes *)attribute {
    attribute.alpha = 0;
}

- (void)startDragAtLocation:(CGPoint)location {
    if (!self.collectionView) {
        return;
    }
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    if (!indexPath) {
        return;
    }
    
    if (![self.collectionView.dataSource collectionView:self.collectionView canMoveItemAtIndexPath:indexPath]) {
        return;
    }
    
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    if (!cell) {
        return;
    }
    
    self.originalIndexPath = indexPath;
    self.draggingIndexPath = indexPath;
    
    self.draggingView = [cell snapshotViewAfterScreenUpdates:YES];
    self.draggingView.frame = cell.frame;
    self.draggingView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.draggingView.bounds].CGPath;
    self.draggingView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.draggingView.layer.shadowOpacity = 0.8;
    self.draggingView.layer.shadowRadius = 10;
    [self.collectionView addSubview:self.draggingView];
    
    self.dragOffset = CGPointMake(self.draggingView.center.x - location.x, self.draggingView.center.y - location.y);
    
    [self invalidateLayout];
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:kNilOptions animations:^{
        self.draggingView.alpha = 0.95;
        self.draggingView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:nil];
}

- (void)updateDragAtLocation:(CGPoint)location {
    if (!self.draggingView) {
        return;
    }
    
    if (!self.collectionView) {
        return;
    }
    
    self.draggingView.center = CGPointMake(location.x + self.dragOffset.x, location.y + self.dragOffset.y);
    
    NSIndexPath *newIndexPath = [self.collectionView indexPathForItemAtPoint:location];
    if (newIndexPath) {
        [self.collectionView moveItemAtIndexPath:self.draggingIndexPath toIndexPath:newIndexPath];
        self.draggingIndexPath = newIndexPath;
    }
}

- (void)endDragAtLocation:(CGPoint)location {
    if (!self.draggingView) {
        return;
    }
    
    if (!self.draggingIndexPath) {
        return;
    }
    
    if (!self.collectionView) {
        return;
    }
    
    if (!self.collectionView.dataSource) {
        return;
    }
    
    CGPoint targetCenter = [self.collectionView.dataSource collectionView:self.collectionView cellForItemAtIndexPath:self.draggingIndexPath].center;
    
    CABasicAnimation *shadowFade = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    shadowFade.fromValue = @(0.8);
    shadowFade.toValue = @(0.0);
    shadowFade.duration = 0.4;
    [self.draggingView.layer addAnimation:shadowFade forKey:@"shadowFade"];
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:kNilOptions animations:^{
        self.draggingView.center = targetCenter;
        self.draggingView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if (![self.draggingIndexPath isEqual:self.originalIndexPath]) {
            [self.collectionView.dataSource collectionView:self.collectionView moveItemAtIndexPath:self.originalIndexPath toIndexPath:self.draggingIndexPath];
        }
        
        [self.draggingView removeFromSuperview];
        self.draggingIndexPath = nil;
        self.draggingView = nil;
        
        [self invalidateLayout];
    }];
}

#pragma  mark - Actions

- (void)longPressGestureRecogized:(UILongPressGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.collectionView];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            [self startDragAtLocation:location];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self updateDragAtLocation:location];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self endDragAtLocation:location];
            break;
        }
        default:
            break;
    }
}

@end
