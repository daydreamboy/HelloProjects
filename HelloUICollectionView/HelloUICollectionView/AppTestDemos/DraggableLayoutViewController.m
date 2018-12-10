//
//  DraggableLayoutViewController.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/12/10.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "DraggableLayoutViewController.h"
#import "CollectionViewFlowLayoutDraggable.h"

@interface MyTextCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *label;
@end

@implementation MyTextCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return self;
}
@end

@interface DraggableLayoutViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation DraggableLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
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
        CollectionViewFlowLayoutDraggable *layout = [CollectionViewFlowLayoutDraggable new];
        layout.itemSize = CGSizeMake(62, 62);
        layout.minimumLineSpacing = 16;
        layout.minimumInteritemSpacing = 16;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerClass:[MyTextCell class] forCellWithReuseIdentifier:@"Cell"];
        
        _collectionView = collectionView;
    }
    
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 25;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyTextCell *cell = (MyTextCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 8;
    cell.backgroundColor = self.colors[indexPath.row % self.colors.count];
    cell.label.text = [NSString stringWithFormat:@"%d", (int)indexPath.row];
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
