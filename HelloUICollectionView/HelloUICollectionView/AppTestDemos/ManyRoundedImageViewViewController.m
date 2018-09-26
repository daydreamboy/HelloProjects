//
//  ManyRoundedImageViewViewController.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/8/26.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "ManyRoundedImageViewViewController.h"
#import "FPSLabel.h"

@interface ImageCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ImageCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
    }
    return self;
}

#pragma mark - Getters

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.layer.cornerRadius = 10;
        _imageView.layer.masksToBounds = YES;
    }
    
    return _imageView;
}

@end

@interface ManyRoundedImageViewViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<UIImage *> *collectionData;
@property (nonatomic, strong) FPSLabel *fpsLabel;
@end

@implementation ManyRoundedImageViewViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _collectionData = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 50; i++) {
            [_collectionData addObject:[UIImage imageNamed:@"2.jpg"]];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.fpsLabel];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.fpsLabel removeFromSuperview];
}

#pragma mark - Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(138, 91.5);
        
        CGFloat padding = (screenSize.width - 2 * layout.itemSize.width) / 3.0;
        
        layout.minimumLineSpacing = padding; // Note: default is 10
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60, screenSize.width, screenSize.height - 60) collectionViewLayout:layout];
        view.dataSource = self;
        view.delegate = self;
        // @see https://stackoverflow.com/a/28003330
        view.contentInset = UIEdgeInsetsMake(padding, padding, padding, padding);
        
        [view registerClass:[ImageCell class] forCellWithReuseIdentifier:@"sCellIdentifier"];
        
        _collectionView = view;
    }
    
    return _collectionView;
}

- (FPSLabel *)fpsLabel {
    if (!_fpsLabel) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        FPSLabel *label = [FPSLabel new];
        label.center = CGPointMake(screenSize.width - 80, 20);
        _fpsLabel = label;
    }
    
    return _fpsLabel;
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
    return self.collectionData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sCellIdentifier" forIndexPath:indexPath];
    ImageCell *imageCell = (ImageCell *)cell;
    imageCell.imageView.image = self.collectionData[indexPath.row];
    
    return cell;
}

@end
