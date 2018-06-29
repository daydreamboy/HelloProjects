//
//  HorizontalPageBrowserViewController.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/6/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "HorizontalPageBrowserViewController.h"
#import "WCHorizontalPageBrowserView.h"
#import "WCZoomableImagePage.h"

@interface ZoomableImagePage : WCBaseHorizontalPage

@end

@implementation ZoomableImagePage

@end

@interface VideoPlayerPage : WCBaseHorizontalPage

@end

@implementation VideoPlayerPage

@end

@interface HorizontalPageBrowserViewController () <WCHorizontalPageBrowserViewDataSource>
@property (nonatomic, strong) WCHorizontalPageBrowserView *pageBrowserView;
@property (nonatomic, strong) NSArray<NSString *> *pageData;
@end

@implementation HorizontalPageBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageData = @[
                @"1.jpg",
                @"2.jpg",
                @"3.jpg",
                ];
    
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
        view.pageSpace = 30;
        
        [view registerPageClass:[WCZoomableImagePage class] forPageWithReuseIdentifier:NSStringFromClass([WCZoomableImagePage class])];
        //[view registerPageClass:[VideoPlayerPage class] forPageWithReuseIdentifier:NSStringFromClass([VideoPlayerPage class])];
        
        _pageBrowserView = view;
    }
    
    return _pageBrowserView;
}

#pragma mark - WCHorizontalPageBrowserViewDataSource

- (NSInteger)numberOfPagesHorizontalPageBrowserView:(WCHorizontalPageBrowserView *)horizontalPageBrowserView {
    return self.pageData.count;
}

- (WCBaseHorizontalPage *)horizontalPageBrowserView:(WCHorizontalPageBrowserView *)horizontalPageBrowserView configurePage:(WCBaseHorizontalPage *)page forItemAtIndex:(NSInteger)index reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([reuseIdentifier isEqualToString:NSStringFromClass([WCZoomableImagePage class])]) {
        NSString *imageName = self.pageData[index];
        WCZoomableImagePage *zoomableImagePage = (WCZoomableImagePage *)page;
        [zoomableImagePage displayImage:[UIImage imageNamed:imageName]];
    }
    
    return page;
}

@end
