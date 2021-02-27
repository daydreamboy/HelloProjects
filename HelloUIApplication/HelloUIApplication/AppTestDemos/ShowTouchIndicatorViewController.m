//
//  ShowTouchIndicatorViewController.m
//  HelloUIApplication
//
//  Created by wesley_chen on 2021/1/3.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "ShowTouchIndicatorViewController.h"
#import "WCTouchIndicatorWindow.h"

@interface ShowTouchIndicatorViewController ()
@property (nonatomic, strong) WCTouchIndicatorWindow *touchWindow;
@end

@implementation ShowTouchIndicatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UISwitch *switchShowTouchIndicator = [UISwitch new];
    switchShowTouchIndicator.on = YES;
    [switchShowTouchIndicator addTarget:self action:@selector(switchShowTouchIndicatorToggled:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:switchShowTouchIndicator];
    
    self.touchWindow = [WCTouchIndicatorWindow defaultTouchWindow];
}

#pragma mark - Action

- (void)switchShowTouchIndicatorToggled:(id)sender {
    UISwitch *switcher = (UISwitch *)sender;
    
    self.touchWindow.shouldDisplayTouches = switcher.on;
}

@end
