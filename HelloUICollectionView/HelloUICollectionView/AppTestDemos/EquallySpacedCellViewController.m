//
//  EquallySpacedCellViewController.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2020/8/23.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "EquallySpacedCellViewController.h"
#import "MyCustomCollectionViewCell.h"

@interface EquallySpacedCellViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign) NSUInteger numberOfCellPerRow;
@property (nonatomic, strong) UIView *collectionViewBackground;
@end

@implementation EquallySpacedCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.spacing = 1.0; // BUG: use 1.0/ [UIScreen mainScreen].scale, separators show not equally
    self.numberOfCellPerRow = 4;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.collectionViewBackground = [UIView new];
    self.collectionViewBackground.backgroundColor = [UIColor darkGrayColor];
    
    [self.view addSubview:self.collectionView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Getters

- (NSArray *)colors {
    return @[
             [UIColor colorWithRed:0.02 green:0.25 blue:0.49 alpha:1],
             [UIColor colorWithRed:0.32 green:0.66 blue:0.99 alpha:1],
             [UIColor colorWithRed:0.05 green:0.52 blue:0.98 alpha:1],
             [UIColor colorWithRed:0.18 green:0.34 blue:0.49 alpha:1],
             [UIColor colorWithRed:0.03 green:0.41 blue:0.79 alpha:1],
             ];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        // @see https://medium.com/@NickBabo/equally-spaced-uicollectionview-cells-6e60ce8d457b
        CGFloat width = CGRectGetWidth(self.view.bounds);
        CGFloat widthLeftBySpace = width - (self.numberOfCellPerRow + 1) * self.spacing;
        CGFloat itemWidth = widthLeftBySpace / self.numberOfCellPerRow;
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.sectionInset = UIEdgeInsetsMake(self.spacing, self.spacing, self.spacing, self.spacing);
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        layout.minimumLineSpacing = self.spacing;
        layout.minimumInteritemSpacing = self.spacing;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor clearColor];
        [collectionView registerClass:[MyCustomCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];

        _collectionView = collectionView;
    }
    
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 39;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCustomCollectionViewCell *cell = (MyCustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%d", (int)indexPath.row];
    
    if (!self.collectionViewBackground.superview) {
        // Note: not works, use collectionViewContentSize instead
        //CGSize contentSize = self.collectionView.contentSize;
        CGSize contentSize2 = self.collectionView.collectionViewLayout.collectionViewContentSize;// @see https://stackoverflow.com/a/13788641
        self.collectionViewBackground.frame = CGRectMake(0, 0, contentSize2.width, contentSize2.height);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView insertSubview:self.collectionViewBackground atIndex:0];
        });
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

@end

