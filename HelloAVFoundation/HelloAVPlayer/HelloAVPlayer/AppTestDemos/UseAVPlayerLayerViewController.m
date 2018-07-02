//
//  UseAVPlayerLayerViewController.m
//  HelloAVPlayer
//
//  Created by wesley_chen on 2018/7/2.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseAVPlayerLayerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface UseAVPlayerLayerViewController ()
@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, strong) AVPlayerItem *item;
@end

@implementation UseAVPlayerLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.playerView];
    
    AVPlayer *player = [AVPlayer playerWithPlayerItem:self.item];
    
    CALayer *superLayer = self.playerView.layer;
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = self.playerView.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [superLayer addSublayer:playerLayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAVPlayerItemDidPlayToEndTimeNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.item];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAVPlayerItemFailedToPlayToEndTimeNotification:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:self.item];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAVPlayerItemTimeJumpedNotification:) name:AVPlayerItemTimeJumpedNotification object:self.item];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAVPlayerItemPlaybackStalledNotification:) name:AVPlayerItemPlaybackStalledNotification object:self.item];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAVPlayerItemNewAccessLogEntryNotification:) name:AVPlayerItemNewAccessLogEntryNotification object:self.item];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAVPlayerItemNewErrorLogEntryNotification:) name:AVPlayerItemNewErrorLogEntryNotification object:self.item];
    
    [player seekToTime:kCMTimeZero];
    [player play];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_item];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:_item];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemTimeJumpedNotification object:_item];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemPlaybackStalledNotification object:_item];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemNewAccessLogEntryNotification object:_item];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemNewErrorLogEntryNotification object:_item];
    
    [_item removeObserver:self forKeyPath:@"status"];
}

#pragma mark - Getters

- (AVPlayerItem *)item {
    if (!_item) {
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:self.URLDemo1];
        
        NSKeyValueObservingOptions options = NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew;
        
        // Register as an observer of the player item's status property
        [item addObserver:self forKeyPath:@"status" options:options context:nil];
        
        _item = item;
    }
    
    return _item;
}

- (UIView *)playerView {
    if (!_playerView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, screenSize.height - 64)];
        _playerView = view;
    }
    
    return _playerView;
}

#pragma mark - NSNotifications

- (void)handleAVPlayerItemDidPlayToEndTimeNotification:(NSNotification *)notification {
    // Note: maybe called on anthoer thread
    NSLog(@"did play to end");
}

- (void)handleAVPlayerItemFailedToPlayToEndTimeNotification:(NSNotification *)notification {
    // Note: maybe called on anthoer thread
    
    NSError *error = notification.userInfo[AVPlayerItemFailedToPlayToEndTimeErrorKey];
    NSLog(@"play failed. %@", error);
}

- (void)handleAVPlayerItemTimeJumpedNotification:(NSNotification *)notification {
    // Note: maybe called on anthoer thread,
    // and called many times at some interval
    NSLog(@"jump to play");
}

- (void)handleAVPlayerItemPlaybackStalledNotification:(NSNotification *)notification {
    // Note: maybe called on anthoer thread
    NSLog(@"play is stalled, need some to download video stream");
}

- (void)handleAVPlayerItemNewAccessLogEntryNotification:(NSNotification *)notification {
    // Note: maybe called on anthoer thread
    NSLog(@"Posted when a new access log entry has been added.");
}

- (void)handleAVPlayerItemNewErrorLogEntryNotification:(NSNotification *)notification {
    // Note: maybe called on anthoer thread
    NSLog(@"Posted when a new error log entry has been added.");
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
