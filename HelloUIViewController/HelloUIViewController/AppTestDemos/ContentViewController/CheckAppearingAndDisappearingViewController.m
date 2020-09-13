//
//  CheckAppearingAndDisappearingViewController.m
//  HelloUIViewController
//
//  Created by wesley_chen on 2018/10/30.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "CheckAppearingAndDisappearingViewController.h"
#import "WCViewControllerTool.h"
#import "DummyModalViewController.h"
#import "DummyStackViewController.h"

@interface CheckAppearingAndDisappearingViewController ()
@property (nonatomic, strong) UIButton *buttonPush;
@property (nonatomic, strong) UIButton *buttonPresent;
@end

@implementation CheckAppearingAndDisappearingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.buttonPush];
    [self.view addSubview:self.buttonPresent];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@: %@", self, NSStringFromSelector(_cmd));
    
    switch ([WCViewControllerTool checkAppearingReasonWithViewController:self]) {
        case WCViewControllerAppearingReasonPopAnotherVC:
            NSLog(@"appear for popping another VC");
            break;
        case WCViewControllerAppearingReasonDismissModalVC:
            NSLog(@"appear for dismissing modal VC");
            break;
        case WCViewControllerAppearingReasonPushItself:
            NSLog(@"appear for pushing itself");
            break;
        case WCViewControllerAppearingReasonPresentItself:
            NSLog(@"appear for presenting itself");
            break;
        case WCViewControllerAppearingReasonUnknown:
            NSLog(@"appear for unknown");
        default:
            break;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%@: %@", self, NSStringFromSelector(_cmd));
    
    switch ([WCViewControllerTool checkDisappearingReasonWithViewController:self]) {
        case WCViewControllerDisappearingReasonPresentModalVC:
            NSLog(@"disappear for presenting modal VC");
            break;
        case WCViewControllerDisappearingReasonPushAnotherVC:
            NSLog(@"disappear for pushing another VC");
            break;
        case WCViewControllerDisappearingReasonPopItself:
            NSLog(@"disappear for popping itself");
            break;
        case WCViewControllerDisappearingReasonDismissItself:
            NSLog(@"disappear for dismissing itself");
            break;
        case WCViewControllerDisappearingReasonUnknown:
            NSLog(@"disappear for unknown");
        default:
            break;
    }
}

#pragma mark - Getters

- (UIButton *)buttonPush {
    if (!_buttonPush) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat width = 140.0f;
        CGFloat height = 30.0f;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake((screenSize.width - width) / 2.0, 120, width, height);
        button.layer.cornerRadius = 4.0f;
        button.layer.borderColor = [UIColor darkGrayColor].CGColor;
        button.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        button.layer.masksToBounds = YES;
        [button setTitle:@"Push" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPushClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonPush = button;
    }
    
    return _buttonPush;
}

- (UIButton *)buttonPresent {
    if (!_buttonPresent) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat width = 140.0f;
        CGFloat height = 30.0f;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake((screenSize.width - width) / 2.0, CGRectGetMaxY(self.buttonPush.frame) + 10, width, height);
        button.layer.cornerRadius = 4.0f;
        button.layer.borderColor = [UIColor darkGrayColor].CGColor;
        button.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        button.layer.masksToBounds = YES;
        [button setTitle:@"Present" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPresentClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonPresent = button;
    }
    
    return _buttonPresent;
}

#pragma mark - Actions

- (void)buttonPushClicked:(id)sender {
    [self.navigationController pushViewController:[DummyStackViewController new] animated:YES];
}

- (void)buttonPresentClicked:(id)sender {
    [self.navigationController presentViewController:[DummyModalViewController new] animated:YES completion:nil];
}

@end
