//
//  UseDelaysTouchesEndedViewController.m
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2020/12/31.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseDelaysTouchesEndedViewController.h"
#import "WCAlertTool.h"

@interface MyCollectionViewCell2 : UICollectionViewCell
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation MyCollectionViewCell2
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor whiteColor];
        [self addSubview:_textLabel];
        
        UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        selectedBackgroundView.backgroundColor = [UIColor redColor];
        self.selectedBackgroundView = selectedBackgroundView;
    }
    return self;
}
@end

@interface UseDelaysTouchesEndedViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIView *viewContainer;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *labelTip;
@property (nonatomic, strong) UISwitch *switchEnableDelayTouchesEnded;
@property (nonatomic, strong) UITapGestureRecognizer *gestureTap;
@end

@implementation UseDelaysTouchesEndedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.labelTip];
    [self.view addSubview:self.switchEnableDelayTouchesEnded];
    [self.view addSubview:self.collectionView];
}

#pragma mark - Getters


- (UILabel *)labelTip {
    if (!_labelTip) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, startY, screenSize.width, 0)];
        label.text = @"Turn off the @delaysTouchesEnded for the collection view";
        label.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
        
        _labelTip = label;
    }
    
    return _labelTip;
}

- (UISwitch *)switchEnableDelayTouchesEnded {
    if (!_switchEnableDelayTouchesEnded) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UISwitch *switcher = [[UISwitch alloc] init];
        switcher.center = CGPointMake(screenSize.width / 2.0, CGRectGetMaxY(_labelTip.frame) + CGRectGetHeight(switcher.bounds) / 2.0);
        switcher.on = YES;
        [switcher addTarget:self action:@selector(switchEnableDelayTouchesEndedToggled:) forControlEvents:UIControlEventValueChanged];
        _switchEnableDelayTouchesEnded = switcher;
    }
    
    return _switchEnableDelayTouchesEnded;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat startY = CGRectGetMaxY(self.switchEnableDelayTouchesEnded.frame) + 20;
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(80, 80);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, startY, screenSize.width, 80) collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor greenColor];
        
        [collectionView registerClass:[MyCollectionViewCell2 class] forCellWithReuseIdentifier:NSStringFromClass([MyCollectionViewCell2 class])];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        tapGesture.numberOfTapsRequired = 2;
        [collectionView addGestureRecognizer:tapGesture];
        self.gestureTap = tapGesture;
        
        _collectionView = collectionView;
    }
    
    return _collectionView;
}

#pragma mark - Actions

- (void)viewTapped:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    NSString *msg = [NSString stringWithFormat:@"%@", tappedView];
    [WCAlertTool presentAlertWithTitle:@"view tapped" message:msg cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:nil];
}

- (void)switchEnableDelayTouchesEndedToggled:(UISwitch *)switcher {
    self.gestureTap.delaysTouchesEnded = self.switchEnableDelayTouchesEnded.on;
}

#pragma mark - UICollectionViewDataSource

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MyCollectionViewCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MyCollectionViewCell2 class]) forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", @(indexPath.item)];
    cell.backgroundColor = [UIColor orangeColor];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
//    NSString *title = [NSString stringWithFormat:@"didSelectItemAtIndexPath: %@", @(indexPath.item)];
//    NSString *msg = [NSString stringWithFormat:@"%@", collectionView];
//    [WCAlertTool presentAlertWithTitle:title message:msg cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:nil];
}
@end
