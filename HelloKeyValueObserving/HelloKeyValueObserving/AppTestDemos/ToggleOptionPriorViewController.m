//
//  ToggleOptionPriorViewController.m
//  HelloKeyValueObserving
//
//  Created by wesley chen on 17/2/12.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import "ToggleOptionPriorViewController.h"

@interface ToggleOptionPriorViewController ()
@property (nonatomic, strong) UISwitch *switcherIsPrior;
@property (nonatomic, copy) void (^switcherToggledBlock)(BOOL isOn);
@end

@implementation ToggleOptionPriorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Public Method

- (instancetype)initWithSwitcherOn:(BOOL)isOn switcherToggled:(void (^)(BOOL isOn))block; {
    self = [super init];
    if (self) {
        CGFloat offsetX = 10;
        CGFloat offsetY = 64 + 10;
        UISwitch *switcher = [[UISwitch alloc] init];
        switcher.center = CGPointMake(switcher.bounds.size.width / 2.0 + offsetX, switcher.bounds.size.height / 2.0 + offsetY);
        switcher.on = isOn;
        [switcher addTarget:self action:@selector(switcherToggled:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:switcher];
        _switcherIsPrior = switcher;
        
        _switcherToggledBlock = block;
    }
    return self;
}

#pragma mark - Actions

- (void)switcherToggled:(id)sender {
    UISwitch *switcher = (UISwitch *)sender;
    if (_switcherToggledBlock) {
        _switcherToggledBlock(switcher.on);
    }
}

@end
