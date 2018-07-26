//
//  WCVideoPlayerPage.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/7/4.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCVideoPlayerPage.h"

// >= `10.0`
#ifndef IOS10_OR_LATER
#define IOS10_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@interface WCVideoPlayerPage ()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong, readwrite) UIImageView *imageViewPlayIcon;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *currentPlayerItem;
@end

@implementation WCVideoPlayerPage

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageViewPlayIcon];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)dealloc {
    [_currentPlayerItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_currentPlayerItem];
}

#pragma mark - Public Methods

- (void)displayLocalVideo:(NSURL *)fileURL {
    AVAsset *asset = [AVAsset assetWithURL:fileURL];
    
    if (_currentPlayerItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_currentPlayerItem];
        [_currentPlayerItem removeObserver:self forKeyPath:@"status"];
    }
    _currentPlayerItem = [AVPlayerItem playerItemWithAsset:asset];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAVPlayerItemDidPlayToEndTimeNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:_currentPlayerItem];
    
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew;
    // Register as an observer of the player item's status property
    [_currentPlayerItem addObserver:self forKeyPath:@"status" options:options context:nil];
    
    if (!_player) {
        _player = [AVPlayer playerWithPlayerItem:_currentPlayerItem];
    }
    else {
        [_player replaceCurrentItemWithPlayerItem:_currentPlayerItem];
    }
    
    if (!_playerLayer) {
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_player];
        layer.frame = self.bounds;
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.layer addSublayer:layer];
        _playerLayer = layer;
    }
    
    [self bringSubviewToFront:self.imageViewPlayIcon];
}

- (void)play {
    self.imageViewPlayIcon.hidden = YES;
    [self.player seekToTime:kCMTimeZero];
    [self.player play];
}

- (void)stop {
    self.imageViewPlayIcon.hidden = NO;
    [self.player pause];
    [self.player seekToTime:kCMTimeZero];
}

#pragma mark > Properties

- (BOOL)readyToPlay {
    return self.currentPlayerItem.status == AVPlayerItemStatusReadyToPlay;
}

- (BOOL)playing {
    if (IOS10_OR_LATER) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability"
        // @see https://stackoverflow.com/a/41125062
        return self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying;
#pragma GCC diagnostic pop
    }
    else {
        // @see https://stackoverflow.com/a/9288642
        return (self.player.rate > 0 && !self.player.error) ? YES : NO;
    }
}

- (BOOL)paused {
    if (IOS10_OR_LATER) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability"
        return self.player.timeControlStatus == AVPlayerTimeControlStatusPaused;
#pragma GCC diagnostic pop
    }
    else {
        return (self.player.rate == 0 && !self.player.error) ? YES : NO;
    }
}

#pragma mark - Getters

- (UIImageView *)imageViewPlayIcon {
    if (!_imageViewPlayIcon) {
        UIImage *image = [UIImage imageNamed:@"video_play"];
        CGSize imageSize = image.size;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageSize.width, imageSize.height)];
        imageView.image = image;
        imageView.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewPlayIconTapped:)];
        [imageView addGestureRecognizer:gesture];
        
        _imageViewPlayIcon = imageView;
    }
    
    return _imageViewPlayIcon;
}

#pragma mark - Actions

- (void)imageViewPlayIconTapped:(UITapGestureRecognizer *)recognizer {
    if ([self readyToPlay]) {
        self.imageViewPlayIcon.hidden = YES;
        [self play];
    }
}

#pragma mark - NSNotifications

- (void)handleAVPlayerItemDidPlayToEndTimeNotification:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageViewPlayIcon.hidden = NO;
    });
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
