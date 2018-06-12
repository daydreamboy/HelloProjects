//
//  SeparatorsBetweenCell2ViewController.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/6/12.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "SeparatorsBetweenCell2ViewController.h"
#import "MyCustomCollectionViewCell.h"
#import "CellSeparator.h"

#ifndef UICOLOR_randomColor
#define UICOLOR_randomColor [UIColor colorWithRed:(arc4random() % 255 / 255.0f) green:(arc4random() % 255 / 255.0f) blue:(arc4random() % 255 / 255.0f) alpha:1]
#endif

#define kTitle  @"title"
#define kColor  @"color"

@interface SeparatorsBetweenCell2ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray<NSDictionary *> *collectionData;
@property (nonatomic, strong) UICollectionView *collectionView1;
@end

@implementation SeparatorsBetweenCell2ViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSInteger i = 0; i < 4; i++) {
            [arrM addObject:@{ kTitle: [NSString stringWithFormat:@"%d", (int)i], kColor: [UIColor whiteColor] }];
        }
        
        _collectionData = arrM;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView1];
}

#pragma mark - Getters

#define spaceV 30

- (UICollectionView *)collectionView1 {
    if (!_collectionView1) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [layout registerClass:[CellSeparator class] forDecorationViewOfKind:@"Separator"];
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 + 10, screenSize.width, 50) collectionViewLayout:layout];
        view.dataSource = self;
        view.delegate = self;
        // @see https://stackoverflow.com/questions/18390972/uicollectionview-doesnt-bounce-when-datasource-has-only-1-item
        view.alwaysBounceHorizontal = YES;
        view.backgroundColor = [UIColor lightGrayColor];
        
        [view registerClass:[MyCustomCollectionViewCell class] forCellWithReuseIdentifier:@"sCellIdentifier"];
        
        _collectionView1 = view;
    }
    
    return _collectionView1;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sCellIdentifier" forIndexPath:indexPath];
    NSDictionary *dict = self.collectionData[indexPath.row];
    cell.contentView.backgroundColor = dict[kColor];
    cell.textLabel.text = dict[kTitle];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

#define cell_height 100
#define cell1_width 60
#define cell2_width 120

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0 / [UIScreen mainScreen].scale;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize newSize = CGSizeZero;
    newSize.height = CGRectGetHeight(self.collectionView1.bounds);
    
    if(indexPath.item % 4 == 0 || indexPath.item % 4 == 3) {
        newSize.width = cell1_width;
    }
    else {
        newSize.width = cell2_width;
    }
    return newSize;
}

@end
