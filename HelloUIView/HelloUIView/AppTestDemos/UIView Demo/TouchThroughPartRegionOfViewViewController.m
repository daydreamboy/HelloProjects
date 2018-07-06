//
//  TouchThroughPartRegionOfViewViewController.m
//  HelloUIView
//
//  Created by wesley_chen on 05/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "TouchThroughPartRegionOfViewViewController.h"
#import "WCTouchThroughView.h"

#define ALERT_TIP(title, msg, cancel) \
\
do { \
    if ([UIAlertController class]) { \
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:(title) message:(msg) preferredStyle:UIAlertControllerStyleAlert]; \
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:(cancel) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) { \
            [alert dismissViewControllerAnimated:YES completion:nil]; \
        }]; \
        [alert addAction:okAction]; \
        [self presentViewController:alert animated:YES completion:nil]; \
    } \
    else { \
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:(title) message:(msg) delegate:nil cancelButtonTitle:(cancel) otherButtonTitles:nil]; \
        [alert show]; \
    } \
} while (0)

@interface TouchThroughPartRegionOfViewViewController ()
@property (nonatomic, strong) UIButton *buttonUnderOverlay;
@property (nonatomic, strong) UIButton *buttonInOverlay;
@property (nonatomic, strong) WCTouchThroughView *overlay;
@property (nonatomic, strong) UISwitch *switcherUnderOverlay;
@property (nonatomic, strong) UISwitch *switcherInOverlay;
@end

@implementation TouchThroughPartRegionOfViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.buttonUnderOverlay];
    [self.view addSubview:self.overlay];

    _buttonInOverlay = [self createButtonInOverlayWithOverlaySize:self.overlay.bounds.size];
    [self.overlay addSubview:_buttonInOverlay];
    
    [self.view addSubview:self.switcherUnderOverlay];
    [self.view addSubview:self.overlay];
    
    _switcherInOverlay = [self createSwitcherInOverlayWithOverlaySize:self.overlay.bounds.size];
    [self.overlay addSubview:_switcherInOverlay];
    
    self.overlay.interceptedSubviews = @[_switcherInOverlay, _buttonInOverlay];
}

#pragma mark - Getters

- (UISwitch *)switcherUnderOverlay {
    if (!_switcherUnderOverlay) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat side = 200;
        
        UISwitch *switcher = [[UISwitch alloc] initWithFrame:CGRectMake((screenSize.width - side) / 2.0, (screenSize.height - side) / 2.0, side, side)];
        
        _switcherUnderOverlay = switcher;
    }
    
    return _switcherUnderOverlay;
}

- (UISwitch *)createSwitcherInOverlayWithOverlaySize:(CGSize)overlaySize {
    CGFloat side = 100;
    
    UISwitch *switcher = [[UISwitch alloc] initWithFrame:CGRectMake((overlaySize.width - side) / 2.0, (overlaySize.height - side) / 2.0, side, side)];
    
    return switcher;
}

- (UIButton *)buttonUnderOverlay {
    if (!_buttonUnderOverlay) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat side = 200;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake((screenSize.width - side) / 2.0, (screenSize.height - side) / 2.0, side, side);
        button.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        button.layer.borderColor = [UIColor redColor].CGColor;
//        [button setTitle:@"Normal" forState:UIControlStateNormal];
//        [button setTitle:@"Highlight" forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonUnderOverlay = button;
    }
    
    return _buttonUnderOverlay;
}

- (UIButton *)createButtonInOverlayWithOverlaySize:(CGSize)overlaySize {
    CGFloat side = 100;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake((overlaySize.width - side) / 2.0, (overlaySize.height - side) / 2.0, side, side);
    button.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    button.layer.borderColor = [UIColor blueColor].CGColor;
    [button setTitle:@"(touch region)" forState:UIControlStateNormal];
    [button setTitle:@"Highlight" forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (WCTouchThroughView *)overlay {
    if (!_overlay) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat side = 300;
        
        WCTouchThroughView *view = [[WCTouchThroughView alloc] initWithFrame:CGRectMake((screenSize.width - side) / 2.0, (screenSize.height - side) / 2.0, side, side)];
        view.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.2];
        // Note: set userInteractionEnabled to NO, pointInside:withEvent: WON'T be called
        //view.userInteractionEnabled = NO;
        
        _overlay = view;
    }
    
    return _overlay;
}

#pragma mark - Actions

- (void)buttonClicked:(UIButton *)sender {
    if (sender == self.buttonUnderOverlay) {
        ALERT_TIP(@"hit button (red border)", @"You hit button under yellow overlay", @"Ok");
    }
    else if (sender == self.buttonInOverlay) {
        ALERT_TIP(@"hit button (blue border)", @"You hit button in yellow overlay", @"Ok");
    }
}

@end
