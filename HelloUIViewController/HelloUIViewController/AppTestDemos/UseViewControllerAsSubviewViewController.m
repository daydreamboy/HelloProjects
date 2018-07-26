//
//  UseViewControllerAsSubviewViewController.m
//  HelloUIViewController
//
//  Created by wesley_chen on 2018/7/26.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseViewControllerAsSubviewViewController.h"

@interface SubviewChildViewController : UIViewController
@property (nonatomic, strong) UILabel *labelWelcome;
@end

@implementation SubviewChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.view addSubview:self.labelWelcome];
}

#pragma mark - Getters

- (UILabel *)labelWelcome {
    if (!_labelWelcome) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        label.text = @"Welcome";
        label.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2.0, CGRectGetHeight(self.view.bounds) / 2.0);
        label.backgroundColor = [UIColor greenColor];
        _labelWelcome = label;
    }
    
    return _labelWelcome;
}

@end


@interface UseViewControllerAsSubviewViewController ()
@property (nonatomic, strong) SubviewChildViewController *subviewChildViewController;
@end

@implementation UseViewControllerAsSubviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.subviewChildViewController.view];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"relocate" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked:)];
}

#pragma mark - Getters

- (SubviewChildViewController *)subviewChildViewController {
    if (!_subviewChildViewController) {
        SubviewChildViewController *vc = [SubviewChildViewController new];
        vc.view.frame = CGRectMake(100, 100, 200, 200);
        _subviewChildViewController = vc;
    }
    
    return _subviewChildViewController;
}

#pragma mark - Actions

- (void)rightBarButtonItemClicked:(id)sender {
    
}

@end
