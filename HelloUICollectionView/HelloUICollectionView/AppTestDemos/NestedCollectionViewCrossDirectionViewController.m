//
//  NestedCollectionViewCrossDirectionViewController.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/7/11.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "NestedCollectionViewCrossDirectionViewController.h"
#import "WCHorizontalPageBrowserView.h"

@interface NestedCollectionViewCrossDirectionViewController () <WCHorizontalPageBrowserViewDataSource, WCHorizontalPageBrowserViewDelegate>
@property (nonatomic, strong) WCHorizontalPageBrowserView *pageBrowserView;
@end

@implementation NestedCollectionViewCrossDirectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pageBrowserView];
}

#pragma mark - Getters

- (WCHorizontalPageBrowserView *)pageBrowserView {
    if (!_pageBrowserView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        WCHorizontalPageBrowserView *view = [[WCHorizontalPageBrowserView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width - 100, 400)];
        view.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
        view.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.8];
        view.dataSource = self;
        view.delegate = self;
        view.pageSpace = 30;
        
        _pageBrowserView = view;
    }
    
    return _pageBrowserView;
}

@end
