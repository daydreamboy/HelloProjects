//
//  NavRootViewController.m
//  HelloUINavigationBar
//
//  Created by wesley_chen on 2020/9/10.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "NavRootViewController.h"
#import "SecondViewController.h"

@interface NavRootViewController ()
@property (nonatomic, strong) UIButton *buttonPush;
@property (nonatomic, strong) UIButton *buttonDismiss;
@property (nonatomic, strong) UIView *subview;
@end

@implementation NavRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    // Solution: set extendedLayoutIncludesOpaqueBars to YES
    // @see https://stackoverflow.com/questions/13235476/how-do-i-get-a-uinavigationcontroller-to-not-change-its-view-size-when-setting-t
//    self.extendedLayoutIncludesOpaqueBars = YES;
    
    [self.view addSubview:self.buttonPush];
    [self.view addSubview:self.buttonDismiss];
    [self.view addSubview:self.subview];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    self.subview.frame = CGRectMake(0, startY, CGRectGetWidth(self.view.bounds), 60);
}

#pragma mark - Getter

- (UIButton *)buttonPush {
    if (!_buttonPush) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.center = CGPointMake(screenSize.width / 2.0 - 100, 200);
        [button setTitle:@"Push" forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTarget:self action:@selector(buttonPushClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonPush = button;
    }
    
    return _buttonPush;
}

- (UIButton *)buttonDismiss {
    if (!_buttonDismiss) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.center = CGPointMake(screenSize.width / 2.0 + 100, 200);
        [button setTitle:@"Dimiss" forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTarget:self action:@selector(buttonDismissClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonDismiss = button;
    }
    
    return _buttonDismiss;
}

- (UIView *)subview {
    if (!_subview) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, startY, screenSize.width, 60)];
        view.backgroundColor = [UIColor greenColor];
        
        _subview = view;
    }
    
    return _subview;
}

#pragma mark - Action

- (void)buttonPushClicked:(id)sender {
    SecondViewController *vc = [SecondViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)buttonDismissClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
