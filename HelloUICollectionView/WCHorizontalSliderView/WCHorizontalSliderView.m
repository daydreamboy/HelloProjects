//
//  WCHorizontalSliderView.m
//  WCEmotionPanelView
//
//  Created by wesley_chen on 2018/6/9.
//

#import "WCHorizontalSliderView.h"
#import "WCHorizontalSliderViewBaseCell.h"
#import "WCHorizontalSliderViewLayout.h"
#import "WCHorizontalSliderViewUtility.h"

#ifndef UNSPECIFIED
#define UNSPECIFIED 0
#endif

@interface WCHorizontalSliderView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) id<WCHorizontalSliderItem> selectedGroupItem;
@end

@implementation WCHorizontalSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _sliderData = [NSMutableArray array];
        
        _separatorColor = [UIColor lightGrayColor];
        _itemSelectedColor = [UIColor lightGrayColor];
        _itemNormalColor = [UIColor whiteColor];
        
        _autoScrollItemToFullVisbleWhenSelected = YES;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self addSubview:self.collectionView];
    }
}

/*
- (void)insertGroup:(WCEmotionGroup *)group atIndex:(NSUInteger)index {
    if (index <= self.sliderData.count) {
        if (self.selectedGroupItem == nil) {
            self.selectedGroupItem = group;
        }
        
        [self.sliderData insertObject:group atIndex:index];
        [self.collectionView reloadData];
    }
}

- (void)removeGroupAtIndex:(NSUInteger)index {
    if (index < self.sliderData.count) {
        [self.sliderData removeObjectAtIndex:index];
        [self.collectionView reloadData];
    }
}

- (void)updateGroup:(WCEmotionGroup *)group atIndex:(NSUInteger)index {
    if (index < self.sliderData.count) {
        self.sliderData[index] = group;
        [self.collectionView reloadData];
    }
}

- (void)selectGroupAtIndex:(NSInteger)index animated:(BOOL)animated {
    if (0 <= index && index < self.sliderData.count) {
        self.selectedGroup = self.sliderData[index];
        [self.collectionView reloadData];
        
        if (animated) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        }
    }
}
 */

#pragma mark - Public Methods

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)selectItemAtIndex:(NSInteger)index {
    if (0 <= index && index < self.sliderData.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
    }
}

- (void)scrollItemToVisibleForIndex:(NSInteger)index animated:(BOOL)animated {
    if (0 <= index && index < self.sliderData.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
    }
}

#pragma mark - Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        WCHorizontalSliderViewLayout *layout = [[WCHorizontalSliderViewLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = self.separatorWidth;
        layout.minimumLineSpacing = 0;
        [layout registerClass:[WCHorizontalSliderViewBaseCellSeparator class] forDecorationViewOfKind:@"Separator"];
        WCHorizontalSliderViewBaseCellSeparator.color = self.separatorColor;
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) collectionViewLayout:layout];
        view.dataSource = self;
        view.delegate = self;
        view.alwaysBounceHorizontal = YES;
        view.showsHorizontalScrollIndicator = NO;
        view.backgroundColor = [UIColor clearColor];
        
        [view registerClass:[WCHorizontalSliderViewBaseCell class] forCellWithReuseIdentifier:NSStringFromClass([WCHorizontalSliderViewBaseCell class])];
        
        _collectionView = view;
    }
    
    return _collectionView;
}

#pragma mark -

- (void)configureCell:(WCHorizontalSliderViewBaseCell *)cell forItem:(id<WCHorizontalSliderItem>)item {
    CGSize size = !CGSizeEqualToSize(item.iconSize, CGSizeZero) ? item.iconSize : cell.bounds.size;
    cell.imageView.frame = CGRectMake((CGRectGetWidth(cell.bounds) - size.width) / 2.0, (CGRectGetHeight(cell.bounds) - size.height) / 2.0, size.width, size.height);
    
    NSData *data = [NSData dataWithContentsOfURL:item.iconURL];
    cell.imageView.image = [UIImage imageWithData:data];
    
//    UIView *backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
//    backgroundView.backgroundColor = [UIColor whiteColor];
//    cell.backgroundView = backgroundView;
    
    UIImage *backgroundImageForNormal = self.itemNormalColor ? [WCHorizontalSliderViewUtility imageWithColor:self.itemNormalColor size:CGSizeMake(1, 1)] : nil;
    [cell.button setBackgroundImage:backgroundImageForNormal forState:UIControlStateNormal];
    
    UIImage *backgroundImageForSelected = self.itemSelectedColor ? [WCHorizontalSliderViewUtility imageWithColor:self.itemSelectedColor size:CGSizeMake(1, 1)] : nil;
    [cell.button setBackgroundImage:backgroundImageForSelected forState:UIControlStateSelected];
    
    cell.button.selected = item == self.selectedGroupItem ? YES : NO;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sliderData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WCHorizontalSliderViewBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WCHorizontalSliderViewBaseCell class]) forIndexPath:indexPath];
    id<WCHorizontalSliderItem> item = self.sliderData[indexPath.row];
    
    [self configureCell:cell forItem:item];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    id<WCHorizontalSliderItem> item;
    if (0 <= indexPath.item && indexPath.item < self.sliderData.count) {
        item = self.sliderData[indexPath.item];
    }
    
    return CGSizeMake(item.width, CGRectGetHeight(self.bounds));
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (0 <= indexPath.item && indexPath.item < self.sliderData.count) {
        id<WCHorizontalSliderItem> item = self.sliderData[indexPath.item];
        
        BOOL shouldSelectItem = YES;
        if ([self.delegate respondsToSelector:@selector(WCEmotionSliderView:shouldSelectItem:atIndex:)]) {
            shouldSelectItem = [self.delegate WCEmotionSliderView:self shouldSelectItem:item atIndex:indexPath.item];
        }

        if (shouldSelectItem && item != self.selectedGroupItem) {
            self.selectedGroupItem = item;
            [self.collectionView reloadData];
            
            if ([self.delegate respondsToSelector:@selector(WCEmotionSliderView:didSelectItem:atIndex:)]) {
                [self.delegate WCEmotionSliderView:self didSelectItem:item atIndex:indexPath.item];
            }
            
            if (self.autoScrollItemToFullVisbleWhenSelected) {
                [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }
        }
    }
}

@end
