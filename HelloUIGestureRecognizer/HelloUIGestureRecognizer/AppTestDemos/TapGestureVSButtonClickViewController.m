//
//  TapGestureVSButtonClickViewController.m
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2018/9/13.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "TapGestureVSButtonClickViewController.h"
#import "WCAlertTool.h"

@interface TapGestureVSButtonClickViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UISwitch *switchEnableCheckButton;
@end

@implementation TapGestureVSButtonClickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.switchEnableCheckButton];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGesture.cancelsTouchesInView = NO;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    [self.view addSubview:self.button];
}

#pragma mark - Actions

- (void)viewTapped:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    NSString *msg = [NSString stringWithFormat:@"%@", tappedView];
    [WCAlertTool presentAlertWithTitle:@"view tapped" message:msg cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:nil];
}

- (void)buttonClicked:(id)sender {
    NSString *msg = [NSString stringWithFormat:@"%@", sender];
    [WCAlertTool presentAlertWithTitle:@"button clicked" message:msg cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:nil];
}

#pragma mark - Getters

- (UIButton *)button {
    if (!_button) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"Click Me" forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 100, 60);
        button.backgroundColor = [UIColor greenColor];
        button.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _button = button;
    }
    
    return _button;
}

- (UISwitch *)switchEnableCheckButton {
    if (!_switchEnableCheckButton) {
        _switchEnableCheckButton = [UISwitch new];
        _switchEnableCheckButton.on = NO;
    }
    
    return _switchEnableCheckButton;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // Note: check touch.view if the button, if YES, not trigger this gesture
    if (self.switchEnableCheckButton.on && (touch.view == self.button)) {
        return NO;
    }
    return YES;
}

@end
