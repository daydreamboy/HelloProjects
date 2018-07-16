//
//  WCHorizontalPageBrowserView.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/6/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCHorizontalPageBrowserView.h"
#import "WCBaseHorizontalPage.h"
#import "WCBaseHorizontalPage_Internal.h"
#import "WCSeparatorFlowLayout.h"

typedef NS_ENUM(NSUInteger, WCHorizontalPageBrowserViewScrollDirection) {
    WCHorizontalPageBrowserViewScrollDirectionNone,
    WCHorizontalPageBrowserViewScrollDirectionRight,
    WCHorizontalPageBrowserViewScrollDirectionLeft,
    WCHorizontalPageBrowserViewScrollDirectionUp,
    WCHorizontalPageBrowserViewScrollDirectionDown,
};

@interface WCHorizontalPageBrowserView () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableDictionary<NSString *, Class> *registeredCells;
@property (nonatomic, assign) NSInteger indexOfCurrentPage;
@property (nonatomic, assign) CGFloat lastContentOffset;
@end

@implementation WCHorizontalPageBrowserView

#pragma mark - Public Methods

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // defaults
        _pageSpace = 16;
        _pagable = YES;
        _registeredCells = [NSMutableDictionary dictionary];
        _separatorColor = [UIColor lightGrayColor];
        
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)registerPageClass:(Class)cellClass forPageWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (reuseIdentifier) {
        _registeredCells[reuseIdentifier] = cellClass;
    }
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)reloadItemsAtIndexes:(NSArray<NSNumber *> *)indexes {
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
    for (NSNumber *index in indexes) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:[index integerValue] inSection:0]];
    }
    if (indexPaths.count) {
        [self.collectionView reloadItemsAtIndexPaths:indexPaths];
    }
}

- (WCBaseHorizontalPage *)dequeueReusablePageWithReuseIdentifier:(NSString *)reuseIdentifier forIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    WCBaseHorizontalPage *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (void)setCurrentPage:(NSInteger)index animated:(BOOL)animated {
    NSInteger numberOfPages = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfPagesHorizontalPageBrowserView:)]) {
        numberOfPages = [self.dataSource numberOfPagesHorizontalPageBrowserView:self];
    }
    if (index >= 0 && index < numberOfPages) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    }
}

#pragma mark -

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        WCBaseHorizontalPage.pageSpace = self.pageSpace;
        [self addSubview:self.collectionView];
    }
}

#pragma mark - Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        // @see https://stackoverflow.com/a/42487721
        // Note: make UICollectionView wider than its container view
        CGRect frame = CGRectMake(-self.pageSpace / 2.0, 0, self.bounds.size.width + self.pageSpace, self.bounds.size.height);
        
        UICollectionViewFlowLayout *layout;
        
        if (self.separatorWidth > 0) {
            layout = [[WCSeparatorFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout.minimumInteritemSpacing = 0;
            layout.minimumLineSpacing = self.separatorWidth;
            [layout registerClass:[WCCollectionViewCellSeparator class] forDecorationViewOfKind:@"Separator"];
            WCCollectionViewCellSeparator.color = self.separatorColor;
        }
        else {
            layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout.minimumLineSpacing = 0;
            layout.minimumInteritemSpacing = 0;
        }
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        view.dataSource = self;
        view.delegate = self;
        view.pagingEnabled = _pagable;
        view.alwaysBounceHorizontal = YES;
        view.showsHorizontalScrollIndicator = NO;
        
        if (_registeredCells.count == 0) {
            [view registerClass:[WCBaseHorizontalPage class] forCellWithReuseIdentifier:NSStringFromClass([WCBaseHorizontalPage class])];
        }
        else {
            for (NSString *identifier in _registeredCells) {
                [view registerClass:_registeredCells[identifier] forCellWithReuseIdentifier:identifier];
            }
        }
        
        _collectionView = view;
    }
    
    return _collectionView;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger numberOfItems = 0;
    
    if ([self.dataSource respondsToSelector:@selector(numberOfPagesHorizontalPageBrowserView:)]) {
        numberOfItems = [self.dataSource numberOfPagesHorizontalPageBrowserView:self];
    }
    
    return numberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WCBaseHorizontalPage *cell = nil;
    
    if ([self.dataSource respondsToSelector:@selector(horizontalPageBrowserView:pageForItemAtIndex:)]) {
        cell = [self.dataSource horizontalPageBrowserView:self pageForItemAtIndex:indexPath.item];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionView.bounds.size;
}

#pragma mark - UICollectionViewDelegateFlowLayout

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 0;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 0;//self.pageSpace / 2.0;
//}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(horizontalPageBrowserView:willDisplayPage:forItemAtIndex:)]) {
        [self.delegate horizontalPageBrowserView:self willDisplayPage:(WCBaseHorizontalPage *)cell forItemAtIndex:indexPath.item];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(horizontalPageBrowserView:didEndDisplayingPage:forItemAtIndex:)]) {
        [self.delegate horizontalPageBrowserView:self didEndDisplayingPage:(WCBaseHorizontalPage *)cell forItemAtIndex:indexPath.item];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(horizontalPageBrowserViewWillBeginDragging:)]) {
        [self.delegate horizontalPageBrowserViewWillBeginDragging:self];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = CGRectGetWidth(self.collectionView.frame);
    self.indexOfCurrentPage = floor((self.collectionView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    NSLog(@"scrollViewDidScroll: %ld", self.indexOfCurrentPage);
    
    //[self updateLastContentOffsetWithScrollView:scrollView];
}

- (void)updateLastContentOffsetWithScrollView:(UIScrollView *)scrollView {
    WCHorizontalPageBrowserViewScrollDirection scrollDirection;
    
    if (self.lastContentOffset > scrollView.contentOffset.x) {
        scrollDirection = WCHorizontalPageBrowserViewScrollDirectionRight;
        NSLog(@"right");
    }
    else if (self.lastContentOffset < scrollView.contentOffset.x) {
        scrollDirection = WCHorizontalPageBrowserViewScrollDirectionLeft;
        NSLog(@"left");
    }
    
    self.lastContentOffset = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger numberOfPages = [self collectionView:self.collectionView numberOfItemsInSection:0];
    if ([self.delegate respondsToSelector:@selector(horizontalPageBrowserView:didScrollToPage:forItemAtIndex:)]) {
        if (0 <= _indexOfCurrentPage && _indexOfCurrentPage < numberOfPages) {
            WCBaseHorizontalPage *page = (WCBaseHorizontalPage *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_indexOfCurrentPage inSection:0]];
            [self.delegate horizontalPageBrowserView:self didScrollToPage:page forItemAtIndex:self.indexOfCurrentPage];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

@end
