//
//  GestureRecognizerVSControlEventsViewController.m
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2019/1/16.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "GestureRecognizerVSControlEventsViewController.h"
#import "WCAlertTool.h"

@interface GestureRecognizerVSControlEventsViewController ()
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *labelTip;
@property (nonatomic, strong) UISwitch *switchEnableUIControlEventTouchUpInside;
@property (nonatomic, strong) UITapGestureRecognizer *gestureTap;
@end

@implementation GestureRecognizerVSControlEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.labelTip];
    [self.view addSubview:self.switchEnableUIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    self.gestureTap.cancelsTouchesInView = self.switchEnableUIControlEventTouchUpInside.on;
}

#pragma mark - Getters

- (UILabel *)labelTip {
    if (!_labelTip) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, startY, screenSize.width, 0)];
        label.text = @"Turn off the UISwitch to allow UIControlEventTouchUpInside for the button";
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

- (UIButton *)button {
    if (!_button) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"Click Me" forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 100, 60);
        button.backgroundColor = [UIColor greenColor];
        button.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTapped:)];
        [button addGestureRecognizer:tapGesture];
        _gestureTap = tapGesture;
        
        _button = button;
    }
    
    return _button;
}

#pragma mark - Actions

- (void)buttonTapped:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    NSString *msg = [NSString stringWithFormat:@"%@", tappedView];
    [WCAlertTool presentAlertWithTitle:@"view tapped" message:msg cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:nil];
}

- (void)buttonClicked:(id)sender {
    NSString *msg = [NSString stringWithFormat:@"%@", sender];
    [WCAlertTool presentAlertWithTitle:@"button clicked" message:msg cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:nil];
}

- (void)switchEnableUIControlEventTouchUpInsideToggle:(UISwitch *)switcher {
    switcher.on = !switcher.on;
    
    self.gestureTap.cancelsTouchesInView = self.switchEnableUIControlEventTouchUpInside.on;
}

@end
