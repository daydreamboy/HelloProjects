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
@end

@implementation UseAVPlayerLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.playerView];
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:self.URLDemo1];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
    
    CALayer *superLayer = self.playerView.layer;
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = self.playerView.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [superLayer addSublayer:playerLayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAVPlayerItemDidPlayToEndTimeNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:item];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAVPlayerItemFailedToPlayToEndTimeNotification:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:item];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAVPlayerItemTimeJumpedNotification:) name:AVPlayerItemTimeJumpedNotification object:item];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAVPlayerItemPlaybackStalledNotification:) name:AVPlayerItemPlaybackStalledNotification object:item];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAVPlayerItemNewAccessLogEntryNotification:) name:AVPlayerItemNewAccessLogEntryNotification object:item];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAVPlayerItemNewErrorLogEntryNotification:) name:AVPlayerItemNewErrorLogEntryNotification object:item];
    
    [player seekToTime:kCMTimeZero];
    [player play];
}

#pragma mark - Getters

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

@end
