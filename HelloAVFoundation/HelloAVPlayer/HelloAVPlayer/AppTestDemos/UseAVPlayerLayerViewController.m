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
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation UseAVPlayerLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *playItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playItemClicked:)];
    UIBarButtonItem *pauseItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pauseItemClicked:)];
    UIBarButtonItem *stopItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopItemClicked:)];
    UIBarButtonItem *rewindItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(rewindItemClicked:)];
    UIBarButtonItem *fastForwardItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(fastForwardItemClicked:)];
    UIBarButtonItem *replayItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(replayItemClicked:)];
    
    self.navigationItem.rightBarButtonItems = @[replayItem, fastForwardItem, rewindItem, stopItem, pauseItem, playItem];
    
    [self.view addSubview:self.playerView];
    [self.view addSubview:self.imageView];
    
    AVPlayer *player = [AVPlayer playerWithPlayerItem:self.item];
    
    CALayer *superLayer = self.playerView.layer;
    
    // @see https://stackoverflow.com/a/38081257
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
    self.player = player;
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

- (NSTimeInterval)currentPlaybackTime {
    return CMTimeGetSeconds([self.item currentTime]);
}

#pragma mark - Getters

- (AVPlayerItem *)item {
    if (!_item) {
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:self.URLLocalDemo1];
        
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

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImage *image = [UIImage imageNamed:@"video_play"];
        CGSize imageSize = image.size;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageSize.width, imageSize.height)];
        imageView.image = image;
        imageView.center = CGPointMake(self.playerView.bounds.size.width / 2.0, self.playerView.bounds.size.height / 2.0);
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
        [imageView addGestureRecognizer:gesture];
        
        _imageView = imageView;
    }
    
    return _imageView;
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

#pragma mark - Actions

- (void)playItemClicked:(id)sender {
    self.imageView.hidden = YES;
    [self.player play];
}

- (void)pauseItemClicked:(id)sender {
    self.imageView.hidden = NO;
    [self.player pause];
}

- (void)stopItemClicked:(id)sender {
    self.imageView.hidden = NO;
    [self.player pause];
    [self.player seekToTime:kCMTimeZero];
}

- (void)rewindItemClicked:(id)sender {
    // @see
    NSTimeInterval rewindTime = [self currentPlaybackTime] - 5.0;
    CMTime cmTime = CMTimeMakeWithSeconds(rewindTime, NSEC_PER_SEC);
    [self.player seekToTime:cmTime];
}

- (void)fastForwardItemClicked:(id)sender {
    NSTimeInterval rewindTime = [self currentPlaybackTime] + 5.0;
    CMTime cmTime = CMTimeMakeWithSeconds(rewindTime, NSEC_PER_SEC);
    [self.player seekToTime:cmTime];
}

- (void)replayItemClicked:(id)sender {
    self.imageView.hidden = YES;
    [self.player seekToTime:kCMTimeZero];
    [self.player play];
}

- (void)imageViewTapped:(id)sender {
    [self playItemClicked:nil];
}

@end
