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
#import "WCVideoPlayerPage.h"
#import "WCHorizontalPageBrowserViewController.h"
#import <SDWebImage/SDWebImageManager.h>
#import <AFNetworking/AFNetworking.h>
#import <CommonCrypto/CommonDigest.h>

@interface WCStringTool : NSObject
@end

@interface WCStringTool ()
+ (NSString *)MD5WithString:(NSString *)string;
@end

@implementation WCStringTool
+ (NSString *)MD5WithString:(NSString *)string {
    if (string.length) {
        const char *cStr = [string UTF8String];
        unsigned char result[16];
        CC_MD5(cStr, (unsigned int)strlen(cStr), result);
        return [NSString stringWithFormat:
                @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                result[0], result[1], result[2], result[3],
                result[4], result[5], result[6], result[7],
                result[8], result[9], result[10], result[11],
                result[12], result[13], result[14], result[15]
                ];
    }
    else {
        return nil;
    }
}
@end

@implementation WCHorizontalPageBrowserItem

+ (instancetype)itemWithURL:(NSURL *)URL type:(WCHorizontalPageBrowserItemType)type {
    WCHorizontalPageBrowserItem *item = [WCHorizontalPageBrowserItem new];
    item.URL = URL;
    item.type = type;
    return item;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _autoPlayVideo = YES;
    }
    return self;
}

@end

@interface WCHorizontalPageBrowserViewController () <WCHorizontalPageBrowserViewDataSource, WCHorizontalPageBrowserViewDelegate>
@property (nonatomic, strong) WCHorizontalPageBrowserView *pageBrowserView;
@property (nonatomic, strong) NSArray<WCHorizontalPageBrowserItem *> *pageData;
@property (nonatomic, strong) id <SDWebImageOperation> imageDownload;
@property (nonatomic, strong) AFURLSessionManager *sessionManager;
@property (nonatomic, strong) NSURL *cacheFolderURL;
@property (nonatomic, strong) NSNumber *initialPageIndex;
@end

@implementation WCHorizontalPageBrowserViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupCacheFolder];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //system("osascript -e 'tell app \"Xcode\" to display dialog \"Hello World\"'");
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    if ([self.dataSource respondsToSelector:@selector(itemsInHorizontalPageBrowserViewController:)]) {
        self.pageData = [self.dataSource itemsInHorizontalPageBrowserViewController:self];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pageBrowserView];
    
    if (self.initialPageIndex) {
        NSInteger index = [self.initialPageIndex integerValue];
        if (0 <= index && index < self.pageData.count) {
            [self.pageBrowserView setCurrentPage:index animated:NO];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSInteger index = self.pageBrowserView.indexOfCurrentPage;
    if (0 <= index && index < self.pageData.count) {
        WCBaseHorizontalPage *page = [self.pageBrowserView pageAtIndex:index];
        WCHorizontalPageBrowserItem *item = self.pageData[index];
        if ([page isKindOfClass:[WCVideoPlayerPage class]] && item.autoPlayVideo) {
            WCVideoPlayerPage *videoPlayerPage = (WCVideoPlayerPage *)page;
            if (item.autoPlayVideo) {
                if (videoPlayerPage.readyToPlay) {
                    if (!videoPlayerPage.playing) {
                        [videoPlayerPage play];
                    }
                }
                else {
                    [videoPlayerPage playIfReady];
                }
            }
        }
    }
}

#pragma mark - 

- (void)setupCacheFolder {
    NSURL *cachesDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    cachesDirectoryURL = [cachesDirectoryURL URLByAppendingPathComponent:@"PageBrowser"];
    
    // @see https://stackoverflow.com/a/1929185
    if ([cachesDirectoryURL checkResourceIsReachableAndReturnError:nil] == NO) {
        [[NSFileManager defaultManager] createDirectoryAtURL:cachesDirectoryURL withIntermediateDirectories:YES attributes:nil error:nil];
    }
    self.cacheFolderURL = cachesDirectoryURL;
}

#pragma mark - Public Methods

- (instancetype)initWithPageData:(NSArray<WCHorizontalPageBrowserItem *> *)pageData {
    self = [super init];
    if (self) {
        _pageData = pageData;
    }
    return self;
}

- (void)setCurrentPageAtIndex:(NSInteger)index animated:(BOOL)animated {
    // Note: viewDidLoad not called, pageData is not ready, so just keep the index as initialPageIndex
    if (self.isViewLoaded) {
        if (0 <= index && index < self.pageData.count) {
            [self.pageBrowserView setCurrentPage:index animated:animated];
        }
    }
    else {
        self.initialPageIndex = @(index);
    }
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
        [view registerPageClass:[WCVideoPlayerPage class] forPageWithReuseIdentifier:NSStringFromClass([WCVideoPlayerPage class])];
        
        _pageBrowserView = view;
    }
    
    return _pageBrowserView;
}

#pragma mark - WCHorizontalPageBrowserViewDataSource

- (NSInteger)numberOfPagesHorizontalPageBrowserView:(WCHorizontalPageBrowserView *)horizontalPageBrowserView {
    return self.pageData.count;
}

- (WCBaseHorizontalPage *)horizontalPageBrowserView:(WCHorizontalPageBrowserView *)horizontalPageBrowserView pageForItemAtIndex:(NSInteger)index {
    WCBaseHorizontalPage *page;
    WCHorizontalPageBrowserItem *item = self.pageData[index];
    
    if (item.type == WCHorizontalPageBrowserItemLocalImage) {
        page = [horizontalPageBrowserView dequeueReusablePageWithReuseIdentifier:NSStringFromClass([WCZoomableImagePage class]) forIndex:index];
        
        WCZoomableImagePage *zoomableImagePage = (WCZoomableImagePage *)page;
        zoomableImagePage.scaleToFit = YES;
        
        NSData *data = [NSData dataWithContentsOfURL:item.URL];
        UIImage *image = [UIImage imageWithData:data];
        
        if (image) {
            [zoomableImagePage displayImage:image];
        }
    }
    else if (item.type == WCHorizontalPageBrowserItemRemoteImage) {
        page = [horizontalPageBrowserView dequeueReusablePageWithReuseIdentifier:NSStringFromClass([WCZoomableImagePage class]) forIndex:index];
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
    else if (item.type == WCHorizontalPageBrowserItemRemoteVideo) {
        page = [horizontalPageBrowserView dequeueReusablePageWithReuseIdentifier:NSStringFromClass([WCVideoPlayerPage class]) forIndex:index];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:item.URL];
        NSURLSessionDownloadTask *downloadTask = [_sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            // Note: dispatch to main thread
            NSLog(@"progress: %f", downloadProgress.fractionCompleted);
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [self.cacheFolderURL URLByAppendingPathComponent:[WCStringTool MD5WithString:item.URL.absoluteString]];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"filePath: %@", filePath);
                NSString *extension = [item.URL pathExtension];
                
                NSURL *newFilePath = [[filePath URLByDeletingPathExtension] URLByAppendingPathExtension:extension];
                [[NSFileManager defaultManager] moveItemAtURL:filePath toURL:newFilePath error:nil];
                
                WCVideoPlayerPage *videoPlayerPage = (WCVideoPlayerPage *)page;
                [videoPlayerPage displayLocalVideo:newFilePath];
            }
        }];
        [downloadTask resume];
    }

    return page;
}

#pragma mark - WCHorizontalPageBrowserViewDelegate

- (void)horizontalPageBrowserView:(WCHorizontalPageBrowserView *)horizontalPageBrowserView willDisplayPage:(WCBaseHorizontalPage *)page forItemAtIndex:(NSInteger)index {
}

- (void)horizontalPageBrowserView:(WCHorizontalPageBrowserView *)horizontalPageBrowserView didEndDisplayingPage:(WCBaseHorizontalPage *)page forItemAtIndex:(NSInteger)index {
    
    if ([page isKindOfClass:[WCZoomableImagePage class]]) {
        WCZoomableImagePage *zoomableImagePage = (WCZoomableImagePage *)page;
        [zoomableImagePage resetZoomableImagePage];
    }
    
    if ([page isKindOfClass:[WCVideoPlayerPage class]]) {
        WCVideoPlayerPage *videoPlayerPage = (WCVideoPlayerPage *)page;
        [videoPlayerPage stop];
    }
}

- (void)horizontalPageBrowserView:(WCHorizontalPageBrowserView *)horizontalPageBrowserView didScrollToPage:(WCBaseHorizontalPage *)page forItemAtIndex:(NSInteger)index {
    
    if ([page isKindOfClass:[WCVideoPlayerPage class]]) {
        WCHorizontalPageBrowserItem *item = self.pageData[index];
        
        WCVideoPlayerPage *videoPlayerPage = (WCVideoPlayerPage *)page;
        if (videoPlayerPage.readyToPlay && item.autoPlayVideo) {
            if (!videoPlayerPage.playing) {
                [videoPlayerPage play];
            }
        }
    }
}

@end
