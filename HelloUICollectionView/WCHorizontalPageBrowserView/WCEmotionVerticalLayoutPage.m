//
//  WCEmotionVerticalLayoutPage.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/7/11.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCEmotionVerticalLayoutPage.h"

#ifndef UICOLOR_randomColor
#define UICOLOR_randomColor [UIColor colorWithRed:(arc4random() % 255 / 255.0f) green:(arc4random() % 255 / 255.0f) blue:(arc4random() % 255 / 255.0f) alpha:1]
#endif

@implementation WCEmotionGroupInfo
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}
@end

@interface TouchableCollectionView : UICollectionView

@end

#define DEBUG_LOG 0

@implementation TouchableCollectionView
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    
    #if DEBUG_LOG
    NSLog(@"began pt: %@", NSStringFromCGPoint(pt));
    #endif
    
    //    NSInteger index = [self indexFromPoint:pt];
    //
    //    if (!_scrollView.decelerating) {
    //        __weak typeof(self) weakSelf = self;
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            [weakSelf addMagnifierAtIndex:index];
    //        });
    //    }
    //
    //    if (!_scrollView.decelerating && index != -1) {
    //        [[UIDevice currentDevice] playInputClick];
    //    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];

    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];

#if DEBUG_LOG
    NSLog(@"moved pt: %@", NSStringFromCGPoint(pt));
#endif

//    NSInteger index = [self indexFromPoint:pt];
//    [self addMagnifierAtIndex:index];
//    if (index == -1) {
//        [self touchesCancelled:touches withEvent:event];
//    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];

#if DEBUG_LOG
    NSLog(@"ended pt: %@", NSStringFromCGPoint(pt));
#endif

//    NSInteger index = [self indexFromPoint:pt];
//
//    if (index >= 0 && index < _numberOfEmotion) {
//
//        if (_delegate && [_delegate respondsToSelector:@selector(keyTapped:)]) {
//            [_delegate keyTapped:_keyBeans[index]];
//        }
//    }
//
//    __weak typeof (self) weakSelf = self;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [weakSelf resetMagnifier];
//    });
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];

    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];

#if DEBUG_LOG
    NSLog(@"cancelled pt: %@", NSStringFromCGPoint(pt));
#endif

//    [self indexFromPoint:pt];
//    [self resetMagnifier];
}
@end

@interface WCEmotionVerticalLayoutPage () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) TouchableCollectionView *collectionView;
@property (nonatomic, strong, readwrite) WCEmotionGroupInfo *groupInfo;
@end

@implementation WCEmotionVerticalLayoutPage

#pragma mark - Public Methods

- (void)configurePage:(WCEmotionGroupInfo *)groupInfo {
    _groupInfo = groupInfo;
}

- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)reuseIdentifier forIndexPath:(NSIndexPath *)indexPath {
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
}

- (UICollectionReusableView *)dequeueReusableHeaderViewWithReuseIdentifier:(NSString *)reuseIdentifier forIndexPath:(NSIndexPath *)indexPath {
    return [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
}

- (UICollectionReusableView *)dequeueReusableFooterViewWithReuseIdentifier:(NSString *)reuseIdentifier forIndexPath:(NSIndexPath *)indexPath {
    return [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
}

- (CGRect)visibleCellRectInPageAtIndexPath:(NSIndexPath *)indexPath {
    CGRect rect = CGRectZero;
    UICollectionViewCell *cell;
    if (indexPath) {
        cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        
        if (cell) {
            // @see https://stackoverflow.com/a/18673842
            rect = [self.collectionView convertRect:cell.frame toView:[self.collectionView superview]];
        }
    }

    return rect;
}

#pragma mark -

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self addSubview:self.collectionView];
    }
}

#pragma mark - Getters

- (TouchableCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = self.groupInfo.itemSize;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        TouchableCollectionView *view = [[TouchableCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) collectionViewLayout:layout];
        view.dataSource = self;
        view.delegate = self;
        view.backgroundColor = [UIColor clearColor];
        
        for (Class cellClass in self.groupInfo.itemViewClasses) {
            [view registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
        }
        
        if (self.groupInfo.headerViewClass) {
            [view registerClass:self.groupInfo.headerViewClass forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(self.groupInfo.headerViewClass)];
        }
        
        if (self.groupInfo.footerViewClass) {
            [view registerClass:self.groupInfo.footerViewClass forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(self.groupInfo.footerViewClass)];
        }
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
        tapGesture.cancelsTouchesInView = NO;
//        [tapGesture requireGestureRecognizerToFail:view.panGestureRecognizer];
        [view addGestureRecognizer:tapGesture];
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
        longPressGesture.cancelsTouchesInView = NO;
//        [longPressGesture requireGestureRecognizerToFail:view.panGestureRecognizer];
        [view addGestureRecognizer:longPressGesture];

        
        _collectionView = view;
    }
    
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.groupInfo.groupData count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.groupInfo.groupData[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    if ([self.dataSource respondsToSelector:@selector(WCEmotionVerticalPage:cellForGroupInfo:atIndexPath:)]) {
        cell = [self.dataSource WCEmotionVerticalPage:self cellForGroupInfo:self.groupInfo atIndexPath:indexPath];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        if ([self.dataSource respondsToSelector:@selector(WCEmotionVerticalPage:headerViewForGroupInfo:atIndexPath:)]) {
            reusableview = [self.dataSource WCEmotionVerticalPage:self headerViewForGroupInfo:self.groupInfo atIndexPath:indexPath];
        }
    }
    else if (kind == UICollectionElementKindSectionFooter) {
        if ([self.dataSource respondsToSelector:@selector(WCEmotionVerticalPage:footerViewForGroupInfo:atIndexPath:)]) {
            reusableview = [self.dataSource WCEmotionVerticalPage:self footerViewForGroupInfo:self.groupInfo atIndexPath:indexPath];
        }
    }
    
    return reusableview;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    // Note: width for horizontal layout, height for vertical layout
    if (self.groupInfo.headerViewClass) {
        CGFloat height = 0;
        if ([self.dataSource respondsToSelector:@selector(WCEmotionVerticalPage:heightOfHeaderForGroupInfo:inSection:)]) {
            height = [self.dataSource WCEmotionVerticalPage:self heightOfHeaderForGroupInfo:self.groupInfo inSection:section];
        }
        
        return CGSizeMake(1, height);
    }
    else {
        return CGSizeZero;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    // Note: width for horizontal layout, height for vertical layout
    if (self.groupInfo.footerViewClass) {
        CGFloat height = 0;
        if ([self.dataSource respondsToSelector:@selector(WCEmotionVerticalPage:heightOfFooterForGroupInfo:inSection:)]) {
            height = [self.dataSource WCEmotionVerticalPage:self heightOfFooterForGroupInfo:self.groupInfo inSection:section];
        }
        
        return CGSizeMake(1, height);
    }
    else {
        return CGSizeZero;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

#pragma mark -

//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"selected: %ld, %ld", indexPath.section, indexPath.item);
//}
//
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"highlight: %ld, %ld", indexPath.section, indexPath.item);
//    return NO;
//}

#pragma mark - Actions

- (void)tapGestureRecognized:(UIPanGestureRecognizer *)recognizer {
    // @see https://stackoverflow.com/a/35182891
    CGPoint location = [recognizer locationInView:recognizer.view];
    NSLog(@"location: %@, state: %@", NSStringFromCGPoint(location), [self stringFromUIGestureRecognizerState:recognizer.state]);
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    if (indexPath) {
        NSLog(@"tapped: %ld, %ld", indexPath.section, indexPath.item);
    }
    else {
        NSLog(@"indexPath is nil");
    }
    
    if ([self.delegate respondsToSelector:@selector(WCEmotionVerticalPage:groupInfo:touchDownAtIndexPath:)]) {
        [self.delegate WCEmotionVerticalPage:self groupInfo:self.groupInfo touchDownAtIndexPath:indexPath];
    }
    
//    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        NSLog(@"begin: %@", NSStringFromCGPoint(location));
//    }
//    else if (recognizer.state == UIGestureRecognizerStateChanged) {
//        NSLog(@"change: %@", NSStringFromCGPoint(location));
//    }
//    else if (recognizer.state == UIGestureRecognizerStateCancelled) {
//        NSLog(@"cancel: %@", NSStringFromCGPoint(location));
//    }
//    else if (recognizer.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"ended: %@", NSStringFromCGPoint(location));
//    }
}

- (NSString *)stringFromUIGestureRecognizerState:(UIGestureRecognizerState)state {
    switch (state) {
        case UIGestureRecognizerStatePossible:
            return @"possible";
        case UIGestureRecognizerStateBegan:
            return @"began";
        case UIGestureRecognizerStateChanged:
            return @"changed";
        case UIGestureRecognizerStateFailed:
            return @"failed";
        // a.k.a UIGestureRecognizerStateRecognized
        case UIGestureRecognizerStateEnded:
            return @"ended";
        case UIGestureRecognizerStateCancelled:
            return @"cancelled";
    }
}

- (void)longPressGestureRecognized:(UILongPressGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:recognizer.view];
    NSLog(@"location: %@, state: %@", NSStringFromCGPoint(location), [self stringFromUIGestureRecognizerState:recognizer.state]);
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    if (indexPath) {
        NSLog(@"pressed: %ld, %ld", indexPath.section, indexPath.item);
    }
    else {
        NSLog(@"indexPath is nil");
    }
    
    if ([self.delegate respondsToSelector:@selector(WCEmotionVerticalPage:groupInfo:touchDownAtIndexPath:)]) {
        [self.delegate WCEmotionVerticalPage:self groupInfo:self.groupInfo touchDownAtIndexPath:indexPath];
    }
    
//    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        NSLog(@"begin: %@", NSStringFromCGPoint(location));
//    }
//    else if (recognizer.state == UIGestureRecognizerStateChanged) {
//        NSLog(@"change: %@", NSStringFromCGPoint(location));
//    }
//    else if (recognizer.state == UIGestureRecognizerStateCancelled) {
//        NSLog(@"cancel: %@", NSStringFromCGPoint(location));
//    }
//    else if (recognizer.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"ended: %@", NSStringFromCGPoint(location));
//    }
}

@end
