//
//  DummyNavRootViewController.m
//  HelloUIInterfaceOrientation
//
//  Created by wesley_chen on 2021/6/30.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "DummyNavRootViewController.h"
#import "WCInterfaceOrientationTool.h"
#import "WCMacroTool.h"

@interface DummyNavRootViewController ()
@property (nonatomic, strong) UILabel *labelInterfaceOrientationMask;
@end

@implementation DummyNavRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.labelInterfaceOrientationMask];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(backItemClicked:)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    NSLog(@"Dummy: %@", WCNSStringFromUIInterfaceOrientationMask(self.navigationController.supportedInterfaceOrientations));
    
    weakify(self);
    [WCInterfaceOrientationTool registerDeviceOrientationDidChangeEventWithBizKey:NSStringFromClass([self class]) eventBlock:^(NSString * _Nonnull bizKey, UIDeviceOrientation orientation) {        
        strongifyWithReturn(self, return;);
        
        [self refreshLabel];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self refreshLabel];
}

#pragma mark -

- (void)refreshLabel {
    self.labelInterfaceOrientationMask.text = WCNSStringFromUIInterfaceOrientationMask(self.supportedInterfaceOrientations);
    [self.labelInterfaceOrientationMask sizeToFit];
    self.labelInterfaceOrientationMask.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2.0, CGRectGetHeight(self.view.bounds) / 2.0);
}

#pragma mark - Getter

- (UILabel *)labelInterfaceOrientationMask {
    if (!_labelInterfaceOrientationMask) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:20];
        
        _labelInterfaceOrientationMask = label;
    }
    
    return _labelInterfaceOrientationMask;
}

#pragma mark - Orientation

- (BOOL)shouldAutorotate {
    return YES;
}

// Note: not implement this method
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}

#pragma mark - Action

- (void)backItemClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
