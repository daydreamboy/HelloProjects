//
//  TouchThroughPartRegionOfViewViewController.m
//  HelloUIView
//
//  Created by wesley_chen on 05/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "TouchThroughPartRegionOfViewViewController.h"
#import "OverlayView.h"

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
@property (nonatomic, strong) OverlayView *overlay;
@end

@implementation TouchThroughPartRegionOfViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.buttonUnderOverlay];
    [self.view addSubview:self.overlay];
}

#pragma mark - Getters

- (UIButton *)buttonUnderOverlay {
    if (!_buttonUnderOverlay) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat side = 200;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake((screenSize.width - side) / 2.0, (screenSize.height - side) / 2.0, side, side);
        button.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        button.layer.borderColor = [UIColor redColor].CGColor;
        [button setTitle:@"Normal" forState:UIControlStateNormal];
        [button setTitle:@"Highlight" forState:UIControlStateHighlighted];
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
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (OverlayView *)overlay {
    if (!_overlay) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat side = 300;
        
        OverlayView *view = [[OverlayView alloc] initWithFrame:CGRectMake((screenSize.width - side) / 2.0, (screenSize.height - side) / 2.0, side, side)];
        view.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.2];
        // Note: set userInteractionEnabled to NO, pointInside:withEvent: WON'T be called
        //view.userInteractionEnabled = NO;
        
        _buttonInOverlay = [self createButtonInOverlayWithOverlaySize:view.bounds.size];
        view.touchableRegion = [view convertRect:_buttonInOverlay.frame fromView:view];
        [view addSubview:_buttonInOverlay];
        
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
