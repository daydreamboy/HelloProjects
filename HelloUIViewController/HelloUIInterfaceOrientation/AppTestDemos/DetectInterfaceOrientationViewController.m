//
//  DetectInterfaceOrientationViewController.m
//  HelloUIInterfaceOrientation
//
//  Created by wesley_chen on 2021/6/30.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "DetectInterfaceOrientationViewController.h"
#import "WCInterfaceOrientationTool.h"

@interface DetectInterfaceOrientationViewController ()
@property (nonatomic, strong) UILabel *labelInterfaceOrientation;
@end

@implementation DetectInterfaceOrientationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.labelInterfaceOrientation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self refreshLabel];
}

// @see https://stackoverflow.com/a/60577486
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    
    NSLog(@"from orientaion: %@", WCNSStringFromUIInterfaceOrientation([WCInterfaceOrientationTool appCurrentOrientation]));
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        NSLog(@"to orientaion: %@", WCNSStringFromUIInterfaceOrientation([WCInterfaceOrientationTool appCurrentOrientation]));
        [self refreshLabel];
    }];
}

#pragma mark -

- (void)refreshLabel {
    self.labelInterfaceOrientation.text = WCNSStringFromUIInterfaceOrientation([WCInterfaceOrientationTool appCurrentOrientation]);
    [self.labelInterfaceOrientation sizeToFit];
    self.labelInterfaceOrientation.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2.0, CGRectGetHeight(self.view.bounds) / 2.0);
}

#pragma mark - Getter

- (UILabel *)labelInterfaceOrientation {
    if (!_labelInterfaceOrientation) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:20];
        
        _labelInterfaceOrientation = label;
    }
    
    return _labelInterfaceOrientation;
}

#pragma mark - Orientation

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end
