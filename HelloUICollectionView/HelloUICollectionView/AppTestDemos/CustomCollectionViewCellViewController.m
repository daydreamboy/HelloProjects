//
//  CustomCollectionViewCellViewController.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/6/9.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "CustomCollectionViewCellViewController.h"
#import "MyCustomCollectionViewCell.h"
#import "WCMacroTool.h"

#define kTitle  @"title"
#define kColor  @"color"

@interface CustomCollectionViewCellViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSArray<NSDictionary *> *collectionData;

@property (nonatomic, strong) UICollectionView *collectionView1;
@property (nonatomic, strong) UICollectionView *collectionView2;
@property (nonatomic, strong) UICollectionView *collectionView3;
@property (nonatomic, strong) UICollectionView *collectionView4;
@property (nonatomic, strong) UICollectionView *collectionView5;
@property (nonatomic, strong) UICollectionView *collectionView6;
@property (nonatomic, strong) UICollectionView *collectionView7;
@end

@implementation CustomCollectionViewCellViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSInteger i = 0; i < 15; i++) {
            [arrM addObject:@{ kTitle: [NSString stringWithFormat:@"%d", (int)i], kColor: UICOLOR_randomColor}];
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
    [self.view addSubview:self.collectionView3];
    [self.view addSubview:self.collectionView4];
    [self.view addSubview:self.collectionView5];
    [self.view addSubview:self.collectionView6];
    [self.view addSubview:self.collectionView7];
}

#pragma mark - Getters

#define spaceV 30

// Example 1:
// - scrollDirection, horizontally layout items
// - itemSize, the cell size
- (UICollectionView *)collectionView1 {
    if (!_collectionView1) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame) + 10;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(44, 44);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectMake(0, startY, screenSize.width, 50) collectionViewLayout:layout];
        view.dataSource = self;
        view.delegate = self;
        view.backgroundColor = [UIColor greenColor];
        
        [view registerClass:[MyCustomCollectionViewCell class] forCellWithReuseIdentifier:@"sCellIdentifier"];
        
        _collectionView1 = view;
    }
    
    return _collectionView1;
}

// Example 2:
// - minimumLineSpacing, the space between item on horizontal line
- (UICollectionView *)collectionView2 {
    if (!_collectionView2) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(44, 44);
        layout.minimumLineSpacing = 0; // Note: default is 10
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView1.frame) + spaceV, screenSize.width, 50) collectionViewLayout:layout];
        view.dataSource = self;
        view.delegate = self;
        view.backgroundColor = [UIColor greenColor];
        
        [view registerClass:[MyCustomCollectionViewCell class] forCellWithReuseIdentifier:@"sCellIdentifier"];
        
        _collectionView2 = view;
    }
    
    return _collectionView2;
}

// Example 3:
// - minimumInteritemSpacing, the space between item on vertical line
- (UICollectionView *)collectionView3 {
    if (!_collectionView3) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(44, 44);
        layout.minimumLineSpacing = 20; // Note: default is 10
        layout.minimumInteritemSpacing = 0; // Note: default is 10
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView2.frame) + spaceV, screenSize.width, 88) collectionViewLayout:layout];
        view.dataSource = self;
        view.delegate = self;
        view.backgroundColor = [UIColor greenColor];
        
        [view registerClass:[MyCustomCollectionViewCell class] forCellWithReuseIdentifier:@"sCellIdentifier"];
        
        _collectionView3 = view;
    }
    
    return _collectionView3;
}

// Example 4: cell height < collection view height, maybe an issue that generates warnings as following
/*
 
 2018-06-09 23:18:06.694656+0800 HelloUICollectionView[71140:687972] The behavior of the UICollectionViewFlowLayout is not defined because:
 2018-06-09 23:18:06.694810+0800 HelloUICollectionView[71140:687972] the item height must be less than the height of the UICollectionView minus the section insets top and bottom values, minus the content insets top and bottom values.
 2018-06-09 23:18:06.695572+0800 HelloUICollectionView[71140:687972] The relevant UICollectionViewFlowLayout instance is <UICollectionViewFlowLayout: 0x7fd232301120>, and it is attached to <UICollectionView: 0x7fd23383ea00; frame = (0 352; 375 20); clipsToBounds = YES; gestureRecognizers = <NSArray: 0x60400005e270>; layer = <CALayer: 0x6040000391a0>; contentOffset: {0, 0}; contentSize: {0, 0}; adjustedContentInset: {0, 0, 0, 0}> collection view layout: <UICollectionViewFlowLayout: 0x7fd232301120>.
 2018-06-09 23:18:06.695670+0800 HelloUICollectionView[71140:687972] Make a symbolic breakpoint at UICollectionViewFlowLayoutBreakForInvalidSizes to catch this in the debugger.
 
 */
- (UICollectionView *)collectionView4 {
    if (!_collectionView4) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(44, 44);
        layout.minimumLineSpacing = 0; // Note: default is 10
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView3.frame) + spaceV, screenSize.width, 20) collectionViewLayout:layout];
        view.dataSource = self;
        view.delegate = self;
        view.backgroundColor = [UIColor greenColor];
        
        [view registerClass:[MyCustomCollectionViewCell class] forCellWithReuseIdentifier:@"sCellIdentifier"];
        
        _collectionView4 = view;
    }
    
    return _collectionView4;
}

- (UICollectionView *)collectionView5 {
    if (!_collectionView5) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(44, 44);
        layout.minimumLineSpacing = 20; // Note: default is 10
        layout.minimumInteritemSpacing = 0; // Note: default is 10
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView4.frame) + spaceV, screenSize.width, 88) collectionViewLayout:layout];
        view.dataSource = self;
        view.delegate = self;
        view.backgroundColor = [UIColor greenColor];
        
        [view registerClass:[MyCustomCollectionViewCell class] forCellWithReuseIdentifier:@"sCellIdentifier"];
        
        _collectionView5 = view;
    }
    
    return _collectionView5;
}

// Example 6: minimumInteritemSpacing not work on vertical layout
// @see https://stackoverflow.com/questions/24303876/uicollectionviewflowlayout-minimuminteritemspacing-doesnt-work
// Solution: when set minimumInteritemSpacing = 0, always set collection view's width is X * itemSize.width
- (UICollectionView *)collectionView6 {
    if (!_collectionView6) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(44, 44);
        layout.minimumLineSpacing = 0; // Note: default is 10
        layout.minimumInteritemSpacing = 0; // Note: default is 10
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView5.frame) + spaceV, 44 * 8, 60) collectionViewLayout:layout];
        view.dataSource = self;
        view.delegate = self;
        view.backgroundColor = [UIColor greenColor];
        
        [view registerClass:[MyCustomCollectionViewCell class] forCellWithReuseIdentifier:@"sCellIdentifier"];
        
        _collectionView6 = view;
    }
    
    return _collectionView6;
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
    MyCustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sCellIdentifier" forIndexPath:indexPath];
    NSDictionary *dict = self.collectionData[indexPath.row];
    cell.contentView.backgroundColor = dict[kColor];
    cell.textLabel.text = dict[kTitle];
    
    return cell;
}

@end
