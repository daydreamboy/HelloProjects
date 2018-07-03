//
//  WCHorizontalPageBrowserViewController.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/6/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCHorizontalPageBrowserViewController.h"
#import "WCHorizontalPageBrowserView.h"
#import "WCZoomableImagePage.h"
#import "WCHorizontalPageBrowserViewController.h"
#import <SDWebImage/SDWebImageManager.h>

@implementation WCHorizontalPageBrowserItem
+ (instancetype)itemWithURL:(NSURL *)URL type:(WCHorizontalPageBrowserItemType)type {
    WCHorizontalPageBrowserItem *item = [WCHorizontalPageBrowserItem new];
    item.URL = URL;
    item.type = type;
    return item;
}
@end

@interface WCHorizontalPageBrowserViewController () <WCHorizontalPageBrowserViewDataSource, WCHorizontalPageBrowserViewDelegate>
@property (nonatomic, strong) WCHorizontalPageBrowserView *pageBrowserView;
@property (nonatomic, strong) NSArray<WCHorizontalPageBrowserItem *> *pageData;
@property (nonatomic, strong) id <SDWebImageOperation> imageDownload;
@end

@implementation WCHorizontalPageBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _pageData = @[
//                @"1.jpg",
//                @"2.jpg",
//                @"3.jpg",
//                  @"https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/242ce817-97a3-48fe-9acd-b1bf97930b01/09-posterization-opt.jpg",
//                  @"http://kb4images.com/images/image/37185176-image.jpg",
//                  @"https://images.pexels.com/photos/248797/pexels-photo-248797.jpeg?auto=compress&cs=tinysrgb&h=350",
//                  @"https://user-images.githubusercontent.com/883386/35498466-1375b88a-04d7-11e8-8f8e-9d202da6a6b3.jpg"
//                ];
    
    
    if ([self.dataSource respondsToSelector:@selector(itemsInHorizontalPageBrowserViewController:)]) {
        self.pageData = [self.dataSource itemsInHorizontalPageBrowserViewController:self];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pageBrowserView];
//   [self.pageBrowserView setCurrentPage:3 animated:NO];
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
        
        [view registerPageClass:[WCZoomableImagePage class] forPageWithReuseIdentifier:NSStringFromClass([WCZoomableImagePage class])];
//        [view registerPageClass:[VideoPlayerPage class] forPageWithReuseIdentifier:NSStringFromClass([VideoPlayerPage class])];
        
        _pageBrowserView = view;
    }
    
    return _pageBrowserView;
}

#pragma mark - WCHorizontalPageBrowserViewDataSource

- (NSInteger)numberOfPagesHorizontalPageBrowserView:(WCHorizontalPageBrowserView *)horizontalPageBrowserView {
    return self.pageData.count;
}

- (WCBaseHorizontalPage *)horizontalPageBrowserView:(WCHorizontalPageBrowserView *)horizontalPageBrowserView pageForItemAtIndex:(NSInteger)index {
    WCBaseHorizontalPage *page = [horizontalPageBrowserView dequeueReusablePageWithReuseIdentifier:NSStringFromClass([WCZoomableImagePage class]) forIndex:index];
    WCHorizontalPageBrowserItem *item = self.pageData[index];
    
    if (item.type == WCHorizontalPageBrowserItemLocalImage) {
        WCZoomableImagePage *zoomableImagePage = (WCZoomableImagePage *)page;
        zoomableImagePage.scaleToFit = YES;
        
        NSData *data = [NSData dataWithContentsOfURL:item.URL];
        UIImage *image = [UIImage imageWithData:data];
        
        if (image) {
            [zoomableImagePage displayImage:image];
        }
    }
    else if (item.type == WCHorizontalPageBrowserItemRemoteImage) {
        
        self.imageDownload = [[SDWebImageManager sharedManager] loadImageWithURL:item.URL options:SDWebImageAvoidAutoSetImage progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            
            if (image) {
                WCZoomableImagePage *zoomableImagePage = (WCZoomableImagePage *)page;
                [zoomableImagePage displayImage:image];
            }
            else {
            }
        }];

    }

    return page;
}

#pragma mark - WCHorizontalPageBrowserViewDelegate

- (void)horizontalPageBrowserView:(WCHorizontalPageBrowserView *)horizontalPageBrowserView willDisplayPage:(WCBaseHorizontalPage *)page forItemAtIndex:(NSInteger)index {
    WCZoomableImagePage *zoomableImagePage = (WCZoomableImagePage *)page;
    [zoomableImagePage resetZoomableImagePage];
}

@end
