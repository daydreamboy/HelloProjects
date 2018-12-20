//
//  PositionBarButtonItemViewController.m
//  HelloUINavigationBar
//
//  Created by wesley_chen on 2018/12/19.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "PositionBarButtonItemViewController.h"
#import "WCNavigationBar.h"

@interface PositionBarButtonItemViewController ()
@property (nonatomic, strong) UIBarButtonItem *barItemDismiss;
@property (nonatomic, strong) UIBarButtonItem *barItemFixedSpace;
@property (nonatomic, strong) UIBarButtonItem *barItemCustomView;
@end

@implementation PositionBarButtonItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self.navigationController.navigationBar isKindOfClass:[WCNavigationBar class]]) {
        WCNavigationBar *bar = (WCNavigationBar *)self.navigationController.navigationBar;
        bar.allowBarButtonSystemItemFixedSpaceNegativeWidth = YES;
    }
    
    self.navigationItem.leftBarButtonItems = @[ self.barItemFixedSpace, self.barItemDismiss ];
    self.navigationItem.rightBarButtonItems = @[ self.barItemFixedSpace, self.barItemCustomView ];
}

#pragma mark - Getters

- (UIBarButtonItem *)barItemDismiss {
    if (!_barItemDismiss) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStyleDone target:self action:@selector(barItemDismissClicked:)];
        _barItemDismiss = item;
    }
    
    return _barItemDismiss;
}

- (UIBarButtonItem *)barItemFixedSpace {
    if (!_barItemFixedSpace) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        item.width = -16;
        _barItemFixedSpace = item;
    }
    
    return _barItemFixedSpace;
}

- (UIBarButtonItem *)barItemCustomView {
    if (!_barItemCustomView) {
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        customView.backgroundColor = [UIColor redColor];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:customView];
        _barItemCustomView = item;
    }
    
    return _barItemCustomView;
}

#pragma mark - Actions

- (void)barItemDismissClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
