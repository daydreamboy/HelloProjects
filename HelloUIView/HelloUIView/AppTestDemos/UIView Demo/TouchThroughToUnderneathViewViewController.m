//
//  TouchThroughToUnderneathViewViewController.m
//  HelloUIView
//
//  Created by wesley_chen on 2018/7/6.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "TouchThroughToUnderneathViewViewController.h"
#import "WCTouchThroughView.h"

@interface TouchThroughToUnderneathViewViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) WCTouchThroughView *touchThroughView;
@property (nonatomic, strong) UISwitch *switchEnableTouchThroughInOverlay;
@property (nonatomic, strong) UIButton *buttonInOverlay;
@property (nonatomic, strong) UIButton *buttonUnderOverlay;
@property (nonatomic, assign) BOOL enableTouchThroughWhenHitBackgroundRegion;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *listData;
@end

@implementation TouchThroughToUnderneathViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.enableTouchThroughWhenHitBackgroundRegion = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.buttonUnderOverlay];
    [self.view addSubview:self.tableView];
    self.listData = @[
        @"A",
        @"B",
        @"C",
        @"D",
        @"E",
        @"F",
        @"G",
    ];
}

- (void)viewDidAppear:(BOOL)animated {
    WCTouchThroughView *touchThroughView = [[WCTouchThroughView alloc] initWithFrame:self.view.bounds];
    touchThroughView.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.5];
    touchThroughView.interceptedSubviews = @[
        self.buttonInOverlay,
        self.switchEnableTouchThroughInOverlay,
    ];
    touchThroughView.backgroundRegionShouldTouchThrough = ^BOOL{
        return self.enableTouchThroughWhenHitBackgroundRegion;
    };
    
    [touchThroughView addSubview:self.buttonInOverlay];
    [touchThroughView addSubview:self.switchEnableTouchThroughInOverlay];
    [self.view.window addSubview:touchThroughView];
    self.touchThroughView = touchThroughView;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.touchThroughView removeFromSuperview];
}

#pragma mark - Getters

- (UIButton *)buttonInOverlay {
    if (!_buttonInOverlay) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(screenSize.width - 200, 64 + 10, 150, 30);
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor redColor].CGColor;
        button.layer.cornerRadius = 5;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
        [button setTitle:@"subview in overlay" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonInOverlayClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonInOverlay = button;
    }
    
    return _buttonInOverlay;
}

- (UIButton *)buttonUnderOverlay {
    if (!_buttonUnderOverlay) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 64 + 10, 200, 100);
        [button setTitle:@"Button under yellow overlay" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonUnderOverlayClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonUnderOverlay = button;
    }
    
    return _buttonUnderOverlay;
}

- (UISwitch *)switchEnableTouchThroughInOverlay {
    if (!_switchEnableTouchThroughInOverlay) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat side = 200;
        
        UISwitch *switcher = [[UISwitch alloc] initWithFrame:CGRectMake((screenSize.width - side) / 2.0, (screenSize.height - side) / 2.0, side, side)];
        switcher.on = self.enableTouchThroughWhenHitBackgroundRegion;
        [switcher addTarget:self action:@selector(switcherToggled:) forControlEvents:UIControlEventValueChanged];
        
        _switchEnableTouchThroughInOverlay = switcher;
    }
    
    return _switchEnableTouchThroughInOverlay;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_buttonUnderOverlay.frame) + 10, screenSize.width, 300) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        tableView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        
        _tableView = tableView;
    }
    
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"TouchThroughToUnderneathViewViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
    }
    
    cell.textLabel.text = self.listData[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Actions

- (void)buttonInOverlayClicked:(id)sender {
    NSLog(@"buttonInOverlayClicked");
}

- (void)buttonUnderOverlayClicked:(id)sender {
    NSLog(@"buttonUnderOverlayClicked");
}

- (void)switcherToggled:(UISwitch *)switcher {
    self.enableTouchThroughWhenHitBackgroundRegion = switcher.on;
}

@end
