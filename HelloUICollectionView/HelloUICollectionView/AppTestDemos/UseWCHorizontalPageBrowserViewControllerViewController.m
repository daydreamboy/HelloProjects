//
//  UseWCHorizontalPageBrowserViewControllerViewController.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/7/2.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseWCHorizontalPageBrowserViewControllerViewController.h"
#import "WCHorizontalPageBrowserViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface UseWCHorizontalPageBrowserViewControllerViewController () <WCHorizontalPageBrowserViewControllerDataSource>
@property (nonatomic, strong) WCHorizontalPageBrowserViewController *pageBrowserViewController;
@property (nonatomic, strong) NSMutableArray<WCHorizontalPageBrowserItem *> *items;
@property (nonatomic, assign) BOOL present;
@property (nonatomic, strong) UIButton *buttonScrollToPage;
@property (nonatomic, strong) UIButton *buttonDismiss;
@end

@implementation UseWCHorizontalPageBrowserViewControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.present = YES;
    
    _pageBrowserViewController = [WCHorizontalPageBrowserViewController new];
    _pageBrowserViewController.dataSource = self;
    
    _items = [NSMutableArray array];
    
    WCHorizontalPageBrowserItem *item;
    
    // local images
    [_items addObject:[WCHorizontalPageBrowserItem itemWithURL:[[NSBundle mainBundle] URLForResource:@"1" withExtension:@"jpg"] type:WCHorizontalPageBrowserItemLocalImage]];
    [_items addObject:[WCHorizontalPageBrowserItem itemWithURL:[[NSBundle mainBundle] URLForResource:@"2" withExtension:@"jpg"] type:WCHorizontalPageBrowserItemLocalImage]];
    [_items addObject:[WCHorizontalPageBrowserItem itemWithURL:[[NSBundle mainBundle] URLForResource:@"3" withExtension:@"jpg"] type:WCHorizontalPageBrowserItemLocalImage]];
    
    // remote images
    [_items addObject:[WCHorizontalPageBrowserItem itemWithURL:[NSURL URLWithString:@"https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/242ce817-97a3-48fe-9acd-b1bf97930b01/09-posterization-opt.jpg"] type:WCHorizontalPageBrowserItemRemoteImage]];
    [_items addObject:[WCHorizontalPageBrowserItem itemWithURL:[NSURL URLWithString:@"http://kb4images.com/images/image/37185176-image.jpg"] type:WCHorizontalPageBrowserItemRemoteImage]];
    [_items addObject:[WCHorizontalPageBrowserItem itemWithURL:[NSURL URLWithString:@"https://images.pexels.com/photos/248797/pexels-photo-248797.jpeg?auto=compress&cs=tinysrgb&h=350"] type:WCHorizontalPageBrowserItemRemoteImage]];
    [_items addObject:[WCHorizontalPageBrowserItem itemWithURL:[NSURL URLWithString:@"https://user-images.githubusercontent.com/883386/35498466-1375b88a-04d7-11e8-8f8e-9d202da6a6b3.jpg"] type:WCHorizontalPageBrowserItemRemoteImage]];
    
    // remote videos
    item = [WCHorizontalPageBrowserItem itemWithURL:[NSURL URLWithString:@"https://card-data.oss-cn-hangzhou.aliyuncs.com/demo.mp4"] type:WCHorizontalPageBrowserItemRemoteVideo];
//    item.autoPlayVideo = NO;
    [_items addObject:item];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.present) {
        [_pageBrowserViewController.view addSubview:self.buttonDismiss];
        [_pageBrowserViewController.view addSubview:self.buttonScrollToPage];
        
        [self presentViewController:_pageBrowserViewController animated:YES completion:nil];
    }
}

#pragma mark - Getters

- (UIButton *)buttonScrollToPage {
    if (!_buttonScrollToPage) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"Scroll to" forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTarget:self action:@selector(buttonScrollToPageClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(20, 20, button.frame.size.width, button.frame.size.height);
        
        _buttonScrollToPage = button;
    }
    
    return _buttonScrollToPage;
}

- (UIButton *)buttonDismiss {
    if (!_buttonDismiss) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"Dimiss" forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTarget:self action:@selector(buttonDismissClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(screenSize.width - button.frame.size.width - 20, 20, button.frame.size.width, button.frame.size.height);
        
        _buttonDismiss = button;
    }
    
    return _buttonDismiss;
}

#pragma mark - WCHorizontalPageBrowserViewControllerDataSource

- (NSArray<WCHorizontalPageBrowserItem *> *)itemsInHorizontalPageBrowserViewController:(WCHorizontalPageBrowserViewController *)horizontalPageBrowserView {
    return self.items;
}

#pragma mark - Actions

- (void)buttonDismissClicked:(id)sender {
    self.present = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)buttonScrollToPageClicked:(id)sender {
    [self.pageBrowserViewController setCurrentPageAtIndex:3 animated:YES];
}

@end
