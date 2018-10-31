//
//  DummyStackViewController.m
//  HelloUIViewController
//
//  Created by wesley_chen on 2018/10/31.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "DummyStackViewController.h"
#import "WCViewControllerTool.h"

@interface DummyStackViewController ()

@end

@implementation DummyStackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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

@end
