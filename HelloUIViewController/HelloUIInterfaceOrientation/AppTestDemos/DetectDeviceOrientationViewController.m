//
//  DetectDeviceOrientationViewController.m
//  HelloUIInterfaceOrientation
//
//  Created by wesley_chen on 2021/6/30.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "DetectDeviceOrientationViewController.h"
#import "WCInterfaceOrientationTool.h"
#import "WCMacroTool.h"

@interface DetectDeviceOrientationViewController ()
@property (nonatomic, strong) UILabel *labelDeviceOrientation;
@end

@implementation DetectDeviceOrientationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.labelDeviceOrientation];
    
    weakify(self);
    [WCInterfaceOrientationTool registerDeviceOrientationDidChangeEventWithBizKey:NSStringFromClass([self class]) eventBlock:^(NSString * _Nonnull bizKey, UIDeviceOrientation orientation) {
        NSLog(@"handleUIDeviceOrientationDidChangeNotification: %@", WCNSStringFromUIDeviceOrientation([WCInterfaceOrientationTool deviceCurrentOrientation]));
        
        strongifyWithReturn(self, return;);
        
        [self refreshLabel];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self refreshLabel];
}

- (void)dealloc {
    [WCInterfaceOrientationTool unregisterDeviceOrientationChangeEventWithBizKey:NSStringFromClass([self class])];
}

// Note: this method only called before orientation change
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

// Note: viewDidLayoutSubviews maybe not called when landscape left turn into landscape right with 180°
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

#pragma mark -

- (void)refreshLabel {
    self.labelDeviceOrientation.text = WCNSStringFromUIDeviceOrientation([WCInterfaceOrientationTool deviceCurrentOrientation]);
    [self.labelDeviceOrientation sizeToFit];
    self.labelDeviceOrientation.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2.0, CGRectGetHeight(self.view.bounds) / 2.0);
}

#pragma mark - Getter

- (UILabel *)labelDeviceOrientation {
    if (!_labelDeviceOrientation) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:20];
        
        _labelDeviceOrientation = label;
    }
    
    return _labelDeviceOrientation;
}

#pragma mark - Orientation

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end
