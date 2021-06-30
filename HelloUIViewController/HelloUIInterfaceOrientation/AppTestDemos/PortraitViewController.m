//
//  PortraitViewController.m
//  HelloUIInterfaceOrientation
//
//  Created by wesley_chen on 2021/6/29.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "PortraitViewController.h"
#import "WCInterfaceOrientationTool.h"

@interface PortraitViewController ()
@property (nonatomic, strong) UILabel *labelOrientation;
@property (nonatomic, assign) UIInterfaceOrientation previousOrientation;
@end

@implementation PortraitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.labelOrientation];
    
//    self.previousOrientation = [WCInterfaceOrientationTool appCurrentOrientation];
//    [WCInterfaceOrientationTool forceLockOrientation:UIInterfaceOrientationLandscapeLeft];
}

- (void)dealloc {
//    [WCInterfaceOrientationTool forceLockOrientation:self.previousOrientation];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.labelOrientation.text = WCNSStringFromUIInterfaceOrientation([WCInterfaceOrientationTool appCurrentOrientation]);//WCNSStringFromUIDeviceOrientation([UIDevice currentDevice].orientation);
    [self.labelOrientation sizeToFit];
    self.labelOrientation.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2.0, CGRectGetHeight(self.view.bounds) / 2.0);
}

#pragma mark - Getter

- (UILabel *)labelOrientation {
    if (!_labelOrientation) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:20];
        
        _labelOrientation = label;
    }
    
    return _labelOrientation;
}

#pragma mark - Orientation

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return
//}

@end
