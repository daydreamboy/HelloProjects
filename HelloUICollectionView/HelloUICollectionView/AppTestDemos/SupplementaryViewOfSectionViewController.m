//
//  SupplementaryViewOfSectionViewController.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/7/11.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "SupplementaryViewOfSectionViewController.h"
#import "SupplementaryViewHeader.h"
#import "SupplementaryViewFooter.h"

#ifndef UICOLOR_randomColor
#define UICOLOR_randomColor [UIColor colorWithRed:(arc4random() % 255 / 255.0f) green:(arc4random() % 255 / 255.0f) blue:(arc4random() % 255 / 255.0f) alpha:1]
#endif

@interface SupplementaryViewOfSectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray<NSArray<UIColor *> *> *collectionData;

@property (nonatomic, strong) UICollectionView *collectionView1;
@property (nonatomic, strong) UICollectionView *collectionView5;
@end

@implementation SupplementaryViewOfSectionViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        NSMutableArray *arrM2 = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 3; i++) {
            NSMutableArray *arrM = [NSMutableArray array];
            for (NSInteger i = 0; i < 10; i++) {
                [arrM addObject:UICOLOR_randomColor];
            }
            [arrM2 addObject:arrM];
        }

        _collectionData = arrM2;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView1];
    [self.view addSubview:self.collectionView5];
}

#pragma mark - Getters

#define spaceV 30
#define padding 10
#define cell_height 100
#define cell1_width 90
#define cell2_width 260

- (UICollectionView *)collectionView1 {
    if (!_collectionView1) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(44, 44);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 + 10, screenSize.width, 3 * padding + 2 * cell_height) collectionViewLayout:layout];
        view.dataSource = self;
        view.delegate = self;
        view.backgroundColor = [UIColor greenColor];
        
        [view registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"sCellIdentifier"];
        [view registerClass:[SupplementaryViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([SupplementaryViewHeader class])];
        [view registerClass:[SupplementaryViewFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([SupplementaryViewFooter class])];
        
        _collectionView1 = view;
    }
    
    return _collectionView1;
}

- (UICollectionView *)collectionView5 {
    if (!_collectionView5) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(44, 44);
        layout.minimumLineSpacing = 20; // Note: default is 10
        layout.minimumInteritemSpacing = 0; // Note: default is 10
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView1.frame) + spaceV, 3 * padding + cell1_width + cell2_width, 300) collectionViewLayout:layout];
        view.dataSource = self;
        view.delegate = self;
        view.backgroundColor = [UIColor greenColor];
        
        [view registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"sCellIdentifier"];
        [view registerClass:[SupplementaryViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([SupplementaryViewHeader class])];
        [view registerClass:[SupplementaryViewFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([SupplementaryViewFooter class])];
        
        _collectionView5 = view;
    }
    
    return _collectionView5;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.collectionData.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.collectionData[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sCellIdentifier" forIndexPath:indexPath];
    UIColor *color = self.collectionData[indexPath.section][indexPath.row];
    cell.contentView.backgroundColor = color;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        SupplementaryViewHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([SupplementaryViewHeader class]) forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor orangeColor];
        
        reusableview = headerView;
    }
    else if (kind == UICollectionElementKindSectionFooter) {
        SupplementaryViewFooter *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([SupplementaryViewFooter class]) forIndexPath:indexPath];
        footerview.backgroundColor = [UIColor brownColor];
        
        reusableview = footerview;
    }
    
    return reusableview;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return padding;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return padding;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize newSize = CGSizeZero;
    newSize.height = cell_height;
    
    if(indexPath.item % 4 == 0 || indexPath.item % 4 == 3) {
        newSize.width = cell1_width;
    }
    else {
        newSize.width = cell2_width;
    }
    return newSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(padding, padding, padding, padding);
}

// @see https://stackoverflow.com/a/18174257
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    // Note: width for horizontal layout, height for vertical layout
    return CGSizeMake(100, 30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    // Note: width for horizontal layout, height for vertical layout
    return CGSizeMake(80, 10);
}

@end
