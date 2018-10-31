//
//  DummyModalViewController.m
//  HelloUIViewController
//
//  Created by wesley_chen on 2018/10/31.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "DummyModalViewController.h"
#import "WCViewControllerTool.h"

@interface DummyModalViewController ()
@property (nonatomic, strong) UIButton *buttonDismiss;
@end

@implementation DummyModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.buttonDismiss];
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

- (UIButton *)buttonDismiss {
    if (!_buttonDismiss) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat width = 120.0f;
        CGFloat height = 30.0f;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake((screenSize.width - width) / 2.0, (screenSize.height - height) / 2.0, width, height);
        button.layer.cornerRadius = 4.0f;
        button.layer.borderColor = [UIColor darkGrayColor].CGColor;
        button.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        button.layer.masksToBounds = YES;
        [button setTitle:@"Dismiss Me" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonDismissClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonDismiss = button;
    }
    
    return _buttonDismiss;
}

- (void)buttonDismissClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
