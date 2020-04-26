//
//  TouchThroughToUnderneathViewViewController.m
//  HelloUIView
//
//  Created by wesley_chen on 2018/7/6.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "TouchThroughToUnderneathViewViewController.h"
#import "WCTouchThroughView.h"

@interface TouchThroughToUnderneathViewViewController ()
@property (nonatomic, strong) WCTouchThroughView *touchThroughView;
@property (nonatomic, strong) UISwitch *switcherShouldPassTouchThrough;
@property (nonatomic, strong) UIButton *buttonInOverlay;
@property (nonatomic, strong) UIButton *buttonUnderOverlay;
@property (nonatomic, assign) BOOL shouldPassTouchThroughWhenHitBackgroundRegion;
@end

@implementation TouchThroughToUnderneathViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldPassTouchThroughWhenHitBackgroundRegion = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.switcherShouldPassTouchThrough];
    [self.view addSubview:self.buttonUnderOverlay];
}

- (void)viewDidAppear:(BOOL)animated {
    WCTouchThroughView *touchThroughView = [[WCTouchThroughView alloc] initWithFrame:self.view.bounds];
    touchThroughView.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.5];
    // Note: self.switcherUnderOverlay not work, because it's not subview of touchThroughView
    touchThroughView.interceptedSubviews = @[self.buttonInOverlay];
    touchThroughView.backgroundRegionShouldTouchThrough = ^BOOL{
        return self.shouldPassTouchThroughWhenHitBackgroundRegion;
    };
    
    [touchThroughView addSubview:self.buttonInOverlay];
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
        button.frame = CGRectMake(screenSize.width - 200, 0, 200, 60);
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor redColor].CGColor;
        button.layer.cornerRadius = 5;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
        [button setTitle:@"Enable TouchThrough" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonInOverlayClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonInOverlay = button;
    }
    
    return _buttonInOverlay;
}

- (UIButton *)buttonUnderOverlay {
    if (!_buttonUnderOverlay) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 64 + 10, 150, 100);
        [button setTitle:@"Button under overlay" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonUnderOverlayClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonUnderOverlay = button;
    }
    
    return _buttonUnderOverlay;
}

- (UISwitch *)switcherShouldPassTouchThrough {
    if (!_switcherShouldPassTouchThrough) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat side = 200;
        
        UISwitch *switcher = [[UISwitch alloc] initWithFrame:CGRectMake((screenSize.width - side) / 2.0, (screenSize.height - side) / 2.0, side, side)];
        switcher.on = self.shouldPassTouchThroughWhenHitBackgroundRegion;
        [switcher addTarget:self action:@selector(switcherToggled:) forControlEvents:UIControlEventValueChanged];
        
        _switcherShouldPassTouchThrough = switcher;
    }
    
    return _switcherShouldPassTouchThrough;
}

#pragma mark - Actions

- (void)buttonInOverlayClicked:(id)sender {
    NSLog(@"buttonInOverlayClicked");
    self.shouldPassTouchThroughWhenHitBackgroundRegion = YES;
}

- (void)buttonUnderOverlayClicked:(id)sender {
    NSLog(@"buttonUnderOverlayClicked");
}

- (void)switcherToggled:(UISwitch *)switcher {
    self.shouldPassTouchThroughWhenHitBackgroundRegion = switcher.on;
}

@end
