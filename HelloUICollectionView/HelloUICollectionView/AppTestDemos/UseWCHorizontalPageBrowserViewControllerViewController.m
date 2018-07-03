//
//  UseWCHorizontalPageBrowserViewControllerViewController.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/7/2.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseWCHorizontalPageBrowserViewControllerViewController.h"
#import "WCHorizontalPageBrowserViewController.h"

@interface UseWCHorizontalPageBrowserViewControllerViewController () <WCHorizontalPageBrowserViewControllerDataSource>
@property (nonatomic, strong) WCHorizontalPageBrowserViewController *pageBrowserViewController;
@property (nonatomic, strong) NSMutableArray<WCHorizontalPageBrowserItem *> *items;
@end

@implementation UseWCHorizontalPageBrowserViewControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageBrowserViewController = [WCHorizontalPageBrowserViewController new];
    _pageBrowserViewController.dataSource = self;
    
    _items = [NSMutableArray array];
    
    // local images
    [_items addObject:[WCHorizontalPageBrowserItem itemWithURL:[[NSBundle mainBundle] URLForResource:@"1" withExtension:@"jpg"] type:WCHorizontalPageBrowserItemLocalImage]];
    [_items addObject:[WCHorizontalPageBrowserItem itemWithURL:[[NSBundle mainBundle] URLForResource:@"2" withExtension:@"jpg"] type:WCHorizontalPageBrowserItemLocalImage]];
    [_items addObject:[WCHorizontalPageBrowserItem itemWithURL:[[NSBundle mainBundle] URLForResource:@"3" withExtension:@"jpg"] type:WCHorizontalPageBrowserItemLocalImage]];
    
    // remote images
    [_items addObject:[WCHorizontalPageBrowserItem itemWithURL:[NSURL URLWithString:@"https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/242ce817-97a3-48fe-9acd-b1bf97930b01/09-posterization-opt.jpg"] type:WCHorizontalPageBrowserItemRemoteImage]];
    [_items addObject:[WCHorizontalPageBrowserItem itemWithURL:[NSURL URLWithString:@"http://kb4images.com/images/image/37185176-image.jpg"] type:WCHorizontalPageBrowserItemRemoteImage]];
    [_items addObject:[WCHorizontalPageBrowserItem itemWithURL:[NSURL URLWithString:@"https://images.pexels.com/photos/248797/pexels-photo-248797.jpeg?auto=compress&cs=tinysrgb&h=350"] type:WCHorizontalPageBrowserItemRemoteImage]];
    [_items addObject:[WCHorizontalPageBrowserItem itemWithURL:[NSURL URLWithString:@"https://user-images.githubusercontent.com/883386/35498466-1375b88a-04d7-11e8-8f8e-9d202da6a6b3.jpg"] type:WCHorizontalPageBrowserItemRemoteImage]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self presentViewController:_pageBrowserViewController animated:YES completion:nil];
}

#pragma mark - WCHorizontalPageBrowserViewControllerDataSource

- (NSArray<WCHorizontalPageBrowserItem *> *)itemsInHorizontalPageBrowserViewController:(WCHorizontalPageBrowserViewController *)horizontalPageBrowserView {
    return self.items;
}

@end
