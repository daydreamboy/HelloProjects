//
//  UseCancelsTouchesInView2ViewController.m
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2019/1/17.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UseCancelsTouchesInView2ViewController.h"
#import "WCAlertTool.h"

@interface MyCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation MyCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor whiteColor];
        [self addSubview:_textLabel];
    }
    return self;
}
@end

@interface UseCancelsTouchesInView2ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIView *viewContainer;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *labelTip;
@property (nonatomic, strong) UISwitch *switchEnableUIControlEventTouchUpInside;
@property (nonatomic, strong) UITapGestureRecognizer *gestureTap;
@end

@implementation UseCancelsTouchesInView2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.labelTip];
    [self.view addSubview:self.switchEnableUIControlEventTouchUpInside];
    [self.view addSubview:self.viewContainer];
    [self.viewContainer addSubview:self.collectionView];
}

#pragma mark - Getters


- (UILabel *)labelTip {
    if (!_labelTip) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, startY, screenSize.width, 0)];
        label.text = @"Turn off the @cancelsTouchesInView for the MyView";
        label.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
        
        _labelTip = label;
    }
    
    return _labelTip;
}

- (UISwitch *)switchEnableUIControlEventTouchUpInside {
    if (!_switchEnableUIControlEventTouchUpInside) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UISwitch *switcher = [[UISwitch alloc] init];
        switcher.center = CGPointMake(screenSize.width / 2.0, CGRectGetMaxY(_labelTip.frame) + CGRectGetHeight(switcher.bounds) / 2.0);
        switcher.on = YES;
        [switcher addTarget:self action:@selector(switchEnableUIControlEventTouchUpInsideToggle:) forControlEvents:UIControlEventValueChanged];
        _switchEnableUIControlEventTouchUpInside = switcher;
    }
    
    return _switchEnableUIControlEventTouchUpInside;
}

- (UIView *)viewContainer {
    if (!_viewContainer) {
        CGFloat startY = CGRectGetMaxY(self.switchEnableUIControlEventTouchUpInside.frame);
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, startY + 10, screenSize.width, 400)];
        view.backgroundColor = [UIColor yellowColor];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        [view addGestureRecognizer:tapGesture];
        self.gestureTap = tapGesture;
        
        _viewContainer = view;
    }
    
    return _viewContainer;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 10;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.viewContainer.bounds), 80) collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor greenColor];
        
        [collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([MyCollectionViewCell class])];
        
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

- (void)switchEnableUIControlEventTouchUpInsideToggle:(UISwitch *)switcher {
    switcher.on = !switcher.on;
    
    self.gestureTap.cancelsTouchesInView = self.switchEnableUIControlEventTouchUpInside.on;
}

#pragma mark - UICollectionViewDataSource

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MyCollectionViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", @(indexPath.item)];
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = [NSString stringWithFormat:@"didSelectItemAtIndexPath: %@", @(indexPath.item)];
    NSString *msg = [NSString stringWithFormat:@"%@", collectionView];
    [WCAlertTool presentAlertWithTitle:title message:msg cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:nil];
}

@end
