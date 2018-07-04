//
//  UseNSURLSessionDownloadTaskDelegateViewController.m
//  HelloNSURLSessionBasic
//
//  Created by wesley_chen on 2018/7/3.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseNSURLSessionDownloadTaskDelegateViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface UseNSURLSessionDownloadTaskDelegateViewController () <NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate>
@property (nonatomic, strong) NSMutableData *dataToDownload;
@property (nonatomic, assign) long long downloadSize;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *labelProgress;
@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayer *player;
@end

@implementation UseNSURLSessionDownloadTaskDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.labelProgress];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.playerView];
    
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURL *URL = [NSURL URLWithString:@"https://github.com/daydreamboy/NetFiles/raw/master/demo.mp4"];
    NSURLSessionDownloadTask *dataTask = [defaultSession downloadTaskWithURL:URL];
    
    [dataTask resume];
}

#pragma mark - Getters

- (UILabel *)labelProgress {
    if (!_labelProgress) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat paddingH = 20;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 64 + 10, screenSize.width - 2 * paddingH, 20)];
        label.text = @"0 %";
        _labelProgress = label;
    }
    
    return _labelProgress;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat paddingH = 20;
        
        UIProgressView *view = [[UIProgressView alloc] initWithFrame:CGRectMake(paddingH, 64 + 50, screenSize.width - 2 * paddingH, 20)];
        
        _progressView = view;
    }
    
    return _progressView;
}

- (UIView *)playerView {
    if (!_playerView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat paddingH = 20;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(self.progressView.frame) + paddingH, screenSize.width - 2 * paddingH, 300)];
        
        _playerView = view;
    }
    
    return _playerView;
}

#pragma mark - NSURLSessionDownloadDelegate < NSURLSessionTaskDelegate < NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
    
    // Note: use currentRequest instead of originalRequest
    NSURL *requestURL = [[downloadTask currentRequest] URL];
    NSString *extension = [requestURL pathExtension];
    
    // @see https://stackoverflow.com/a/27170681
    NSURL *newLocation = [[location URLByDeletingPathExtension] URLByAppendingPathExtension:extension];
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:newLocation error:nil];
    
    AVAsset *asset = [AVAsset assetWithURL:newLocation];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    _player = [AVPlayer playerWithPlayerItem:item];
    
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_player];
    layer.frame = self.playerView.bounds;
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.playerView.layer addSublayer:layer];
    
    [self.player seekToTime:kCMTimeZero];
    [self.player play];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
    
    // @see https://stackoverflow.com/a/26696360
    self.progressView.progress = totalBytesWritten / (double)totalBytesExpectedToWrite;
    self.labelProgress.text = [NSString stringWithFormat:@"%.2f %%", self.progressView.progress * 100.0];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    // Only handle observations for the PlayerItemContext
    /*
     if (context != &PlayerItemContext) {
     [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
     return;
     }
     */
    
    AVPlayerItem *item = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = AVPlayerItemStatusUnknown;
        // Get the status change from the change dictionary
        NSNumber *statusNumber = change[NSKeyValueChangeNewKey];
        if ([statusNumber isKindOfClass:[NSNumber class]]) {
            status = statusNumber.integerValue;
        }
        // Switch over the status
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:
                // Ready to Play
                NSLog(@"KVO: Ready to Play, %@", item.error);
                break;
            case AVPlayerItemStatusFailed:
                // Failed. Examine AVPlayerItem.error
                NSLog(@"KVO: Failed, %@", item.error);
                break;
            case AVPlayerItemStatusUnknown:
                // Not ready
                NSLog(@"KVO: Not ready, %@", item.error);
                break;
        }
    }
}

@end
