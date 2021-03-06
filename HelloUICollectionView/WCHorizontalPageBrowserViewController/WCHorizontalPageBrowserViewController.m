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
#import "WCZoomTransitionAnimator.h"
#import "WCStringTool.h"
#import "WCMacroTool.h"
#import <SDWebImage/SDWebImageManager.h>
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>

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

@interface WCHorizontalPageBrowserViewController () <WCHorizontalPageBrowserViewDataSource, WCHorizontalPageBrowserViewDelegate, WCZoomableImagePageDelegate, UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) WCHorizontalPageBrowserView *pageBrowserView;
@property (nonatomic, strong) NSMutableArray<WCHorizontalPageBrowserItem *> *pageList;
@property (nonatomic, strong) id <SDWebImageOperation> imageDownload;
@property (nonatomic, strong) AFURLSessionManager *sessionManager;
@property (nonatomic, strong) NSURL *cacheFolderURL;
@property (nonatomic, strong) NSNumber *initialPageIndex;
@property (nonatomic, strong) WCZoomTransitionAnimator *transitionAnimator;
@property (nonatomic, strong) UITapGestureRecognizer *backgroundTapGesture;
@end

@implementation WCHorizontalPageBrowserViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _pageList = [NSMutableArray array];
        [self setupCacheFolder];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    [self.view addSubview:self.pageBrowserView];
    [self reloadPageData];
    
    if (self.initialPageIndex) {
        NSInteger index = [self.initialPageIndex integerValue];
        if (0 <= index && index < self.pageList.count) {
            [self.pageBrowserView setCurrentPage:index animated:NO];
        }
    }
    
    [self.view addGestureRecognizer:self.backgroundTapGesture];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSInteger index = self.pageBrowserView.indexOfCurrentPage;
    if (0 <= index && index < self.pageList.count) {
        WCBaseHorizontalPage *page = [self.pageBrowserView pageAtIndex:index];
        WCHorizontalPageBrowserItem *item = self.pageList[index];
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
        
        if (self.pageDidDisplayBlock) {
            WCHorizontalPageBrowserItem *item = self.pageList[index];;
            self.pageDidDisplayBlock(item, index);
        }
    }
}

- (void)dealloc {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

// @see https://stackoverflow.com/a/57822698
- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationFullScreen;
}

#pragma mark - Actions

- (void)backgroundTapGestureRecognized:(UITapGestureRecognizer *)recognizer {
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)setCurrentPageAtIndex:(NSInteger)index animated:(BOOL)animated {
    // Note: viewDidLoad not called, pageList is not ready, so just keep the index as initialPageIndex
    if (self.isViewLoaded) {
        if (0 <= index && index < self.pageList.count) {
            [self.pageBrowserView setCurrentPage:index animated:animated];
        }
    }
    else {
        self.initialPageIndex = @(index);
    }
}

- (void)showInRect:(CGRect)rect fromViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (animated) {
        self.transitionAnimator = [[WCZoomTransitionAnimator alloc] initWithFromRect:rect];
        self.transitioningDelegate = self;
        [viewController presentViewController:self animated:YES completion:nil];
    }
    else {
       [viewController presentViewController:self animated:NO completion:nil];
    }
}

- (void)reloadPageData {
    if ([self.dataSource respondsToSelector:@selector(itemsInHorizontalPageBrowserViewController:)]) {
        NSArray<WCHorizontalPageBrowserItem *> *items = [self.dataSource itemsInHorizontalPageBrowserViewController:self];
        [self.pageList removeAllObjects];
        [self.pageList addObjectsFromArray:items];
    }
    
    [self.pageBrowserView reloadData];
}

#pragma mark - Getters

- (WCHorizontalPageBrowserView *)pageBrowserView {
    if (!_pageBrowserView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        WCHorizontalPageBrowserView *view = [[WCHorizontalPageBrowserView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)/*CGRectMake(0, 0, screenSize.width - 100, 400)*/];
        view.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
        //view.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.8];
        view.dataSource = self;
        view.delegate = self;
        view.pageSpace = 30;
        
        [view registerPageClass:[WCZoomableImagePage class] forPageWithReuseIdentifier:NSStringFromClass([WCZoomableImagePage class])];
        [view registerPageClass:[WCVideoPlayerPage class] forPageWithReuseIdentifier:NSStringFromClass([WCVideoPlayerPage class])];
        
        _pageBrowserView = view;
    }
    
    return _pageBrowserView;
}

- (UITapGestureRecognizer *)backgroundTapGesture {
    if (!_backgroundTapGesture) {
        _backgroundTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapGestureRecognized:)];
    }
    
    return _backgroundTapGesture;
}

#pragma mark - WCHorizontalPageBrowserViewDataSource

- (NSInteger)numberOfPagesHorizontalPageBrowserView:(WCHorizontalPageBrowserView *)horizontalPageBrowserView {
    return self.pageList.count;
}

- (WCBaseHorizontalPage *)horizontalPageBrowserView:(WCHorizontalPageBrowserView *)horizontalPageBrowserView pageForItemAtIndex:(NSInteger)index {
    WCBaseHorizontalPage *page;
    WCHorizontalPageBrowserItem *item = self.pageList[index];
    
    if (item.type == WCHorizontalPageBrowserItemLocalImage) {
        page = [horizontalPageBrowserView dequeueReusablePageWithReuseIdentifier:NSStringFromClass([WCZoomableImagePage class]) forIndex:index];
        
        WCZoomableImagePage *zoomableImagePage = (WCZoomableImagePage *)page;
        [zoomableImagePage resetPage];
        zoomableImagePage.delegate = self;
        zoomableImagePage.scaleToFit = YES;
        
        // FIX: zoomableImagePage.doubleTapGesture is nil, cause requireGestureRecognizerToFail to crash
        if (zoomableImagePage.doubleTapGesture) {
            [self.backgroundTapGesture requireGestureRecognizerToFail:zoomableImagePage.doubleTapGesture];
        }
        
        NSData *data = [NSData dataWithContentsOfURL:item.URL];
        UIImage *image = [UIImage imageWithData:data];
        
        if (image) {
            [zoomableImagePage displayImage:image];
        }
    }
    else if (item.type == WCHorizontalPageBrowserItemRemoteImage) {
        page = [horizontalPageBrowserView dequeueReusablePageWithReuseIdentifier:NSStringFromClass([WCZoomableImagePage class]) forIndex:index];
        WCZoomableImagePage *zoomableImagePage = (WCZoomableImagePage *)page;
        [zoomableImagePage resetPage];
        zoomableImagePage.delegate = self;
        zoomableImagePage.scaleToFit = YES;
        [zoomableImagePage startActivityIndicatorView];
        
        // FIX: zoomableImagePage.doubleTapGesture is nil, cause requireGestureRecognizerToFail to crash
        if (zoomableImagePage.doubleTapGesture) {
            [self.backgroundTapGesture requireGestureRecognizerToFail:zoomableImagePage.doubleTapGesture];
        }
        
        weakify(zoomableImagePage);
        weakify(self);
        self.imageDownload = [[SDWebImageManager sharedManager] loadImageWithURL:item.URL options:SDWebImageAvoidAutoSetImage progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            strongify(zoomableImagePage);
            strongifyWithReturn(self, return;);
            
            [zoomableImagePage stopActivityIndicatorView];
            
            if (image) {
                [zoomableImagePage displayImage:image];
            }
            else {
                NSLog(@"remote video download failed, %@", imageURL);
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                
                // Set the label text.
                hud.label.text = NSLocalizedString(@"remote video download failed", @"HUD loading title");
                // You can also adjust other label properties if needed.
                // hud.label.font = [UIFont italicSystemFontOfSize:16.f];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                });
            }
        }];
    }
    else if (item.type == WCHorizontalPageBrowserItemRemoteVideo) {
        page = [horizontalPageBrowserView dequeueReusablePageWithReuseIdentifier:NSStringFromClass([WCVideoPlayerPage class]) forIndex:index];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:item.URL];
        NSURLSessionDownloadTask *downloadTask = [_sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            // Note: dispatch to main thread
//            NSLog(@"progress: %f", downloadProgress.fractionCompleted);
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
    else if (item.type == WCHorizontalPageBrowserItemLocalVideo) {
        page = [horizontalPageBrowserView dequeueReusablePageWithReuseIdentifier:NSStringFromClass([WCVideoPlayerPage class]) forIndex:index];
        
        WCVideoPlayerPage *videoPlayerPage = (WCVideoPlayerPage *)page;
        [videoPlayerPage displayLocalVideo:item.URL];
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
        WCHorizontalPageBrowserItem *item = self.pageList[index];
        
        WCVideoPlayerPage *videoPlayerPage = (WCVideoPlayerPage *)page;
        if (videoPlayerPage.readyToPlay && item.autoPlayVideo) {
            if (!videoPlayerPage.playing) {
                [videoPlayerPage play];
            }
        }
    }
    
    if (self.pageDidDisplayBlock) {
        WCHorizontalPageBrowserItem *item = nil;
        if (0 <= index && index < self.pageList.count) {
            item = self.pageList[index];
        }
        
        self.pageDidDisplayBlock(item, index);
    }
}

#pragma mark - WCZoomableImagePageDelegate

- (void)WCZoomableImagePage:(WCZoomableImagePage *)page imageViewDidLongPressed:(UIImageView *)imageView {
//    MPMHorizontalPageBrowserItem *item = [page.mpm_associatedWeakUserInfo objectForKey:@"item"];
//
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片到相册", nil];
//    actionSheet.mpm_associatedUserObject = imageView.image;
//    [actionSheet.mpm_associatedWeakUserInfo setObject:item forKey:@"item"];
//    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.transitionAnimator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.transitionAnimator;
}

//- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
//    return self.transitionAnimator.interactionInProgress ? self.transitionAnimator : nil;
//}

@end
