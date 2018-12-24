//
//  AutoFitHeightCollectionViewViewController.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/12/24.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "AutoFitHeightCollectionViewViewController.h"
#import "MyCustomCollectionViewCell.h"

#define MPMUnited(x)    ((x) * ([[UIScreen mainScreen] bounds].size.width / 750.0f))

@interface AutoFitHeightCollectionViewViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, strong) NSArray<NSDictionary *> *gridItems;
@end

@implementation AutoFitHeightCollectionViewViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _gridItems = @[
                       @{
                           @"title": @"A",
                           },
                       @{
                           @"title": @"B",
                           },
                       @{
                           @"title": @"C",
                           },
                       @{
                           @"title": @"D",
                           },
                       ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _itemSize = CGSizeMake(MPMUnited(140), MPMUnited(140));
    
    [self.view addSubview:self.collectionView];
    
    // @see https://stackoverflow.com/a/13788641
    [self.collectionView reloadData];
    CGRect frame = self.collectionView.frame;
    frame.size.height = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
    self.collectionView.frame = frame;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat paddingH = MPMUnited(20);
        CGFloat width = MPMUnited(488) - 2 * paddingH;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = self.itemSize;
        layout.minimumLineSpacing = MPMUnited(10);
        layout.minimumInteritemSpacing = MPMUnited(14);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(paddingH, 80, width, 0) collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.3];
        [collectionView registerClass:[MyCustomCollectionViewCell class] forCellWithReuseIdentifier:@"sCellIdentifier"];
        
        _collectionView = collectionView;
    }
    
    return _collectionView;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath: %@", @(indexPath.row));
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.gridItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sCellIdentifier" forIndexPath:indexPath];
    NSDictionary *dict = self.gridItems[indexPath.row];
    cell.contentView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    cell.textLabel.text = dict[@"title"];
    
    return cell;
}


@end
