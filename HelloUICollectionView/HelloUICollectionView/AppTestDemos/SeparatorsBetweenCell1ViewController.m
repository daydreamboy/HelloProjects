//
//  SeparatorsBetweenCell1ViewController.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/6/12.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "SeparatorsBetweenCell1ViewController.h"
#import "MyCustomCollectionViewCell.h"

#ifndef UICOLOR_randomColor
#define UICOLOR_randomColor [UIColor colorWithRed:(arc4random() % 255 / 255.0f) green:(arc4random() % 255 / 255.0f) blue:(arc4random() % 255 / 255.0f) alpha:1]
#endif

#define kTitle  @"title"
#define kColor  @"color"

// Solution 1:
// use backgroundColor and minimumInteritemSpacing as separators,
// but bounces will reveal the backgroundColor which not same as cell background color (maybe an issue)
@interface SeparatorsBetweenCell1ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray<NSDictionary *> *collectionData;
@property (nonatomic, strong) UICollectionView *collectionView1;
@property (nonatomic, strong) UICollectionView *collectionView2;
@end

@implementation SeparatorsBetweenCell1ViewController

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
    [self.view addSubview:self.collectionView2];
}

#pragma mark - Getters

#define spaceV 30
#define cell_height 100
#define cell_width  60

// horizontal
#define cell1_width 60
#define cell2_width 120

// vertical
#define cell1_height 30
#define cell2_height 60

- (UICollectionView *)collectionView1 {
    if (!_collectionView1) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat padding = 10;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectMake(padding, 64 + 10, screenSize.width - 2 * padding, 50) collectionViewLayout:layout];
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

- (UICollectionView *)collectionView2 {
    if (!_collectionView2) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.collectionView1.frame) + spaceV, 50, 300) collectionViewLayout:layout];
        view.dataSource = self;
        view.delegate = self;
        // @see https://stackoverflow.com/questions/18390972/uicollectionview-doesnt-bounce-when-datasource-has-only-1-item
        view.alwaysBounceVertical = YES;
        view.backgroundColor = [UIColor lightGrayColor];
        
        [view registerClass:[MyCustomCollectionViewCell class] forCellWithReuseIdentifier:@"sCellIdentifier"];
        
        _collectionView2 = view;
    }
    
    return _collectionView2;
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

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.collectionView1) {
        return 1.0 / [UIScreen mainScreen].scale;
    }
    else if (collectionView == self.collectionView2) {
        return 0;
    }
    else {
        return 10;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.collectionView1) {
        return 0;
    }
    else if (collectionView == self.collectionView2) {
        return 1.0 / [UIScreen mainScreen].scale;
    }
    else {
        return 10;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize newSize = CGSizeZero;
    
    if (collectionView == self.collectionView1) {
        newSize.height = CGRectGetHeight(self.collectionView1.bounds);
        
        if(indexPath.item % 4 == 0 || indexPath.item % 4 == 3) {
            newSize.width = cell1_width;
        }
        else {
            newSize.width = cell2_width;
        }
    }
    else if (collectionView == self.collectionView2) {
        newSize.width = CGRectGetWidth(self.collectionView2.bounds);
        
        if(indexPath.item % 4 == 0 || indexPath.item % 4 == 3) {
            newSize.height = cell1_height;
        }
        else {
            newSize.height = cell2_height;
        }
    }

    return newSize;
}

@end
