//
//  WCAudioPlayer.m
//  HelloAVAudioPlayer
//
//  Created by wesley_chen on 2018/8/3.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCAudioPlayer.h"
#import "WCMacroTool.h"

@interface WCAudioPlayer () <AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSMutableDictionary<NSURL *, id> *table;
@end

@implementation WCAudioPlayer

#pragma mark - Public Methods

- (instancetype)init {
    self = [super init];
    if (self) {
        _table = [NSMutableDictionary dictionary];
    }
    return self;
}

- (BOOL)playAudioWithURL:(NSURL *)URL error:(NSError **)error completion:(void (^)(BOOL finished, NSError *error))completion {
    NSError *errorL;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:&errorL];
    _audioPlayer.delegate = self;
    [_audioPlayer play];
    
    WCSafeSetErrorPtr(error, errorL);
    
    if (errorL) {
        return NO;
    }
    else {
        _table[URL] = completion;
        return YES;
    }
}

- (BOOL)playAudioWithData:(NSData *)data error:(NSError **)error completion:(void (^)(BOOL finished, NSError *error))completion {
    NSError *errorL;
    _audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&errorL];
    _audioPlayer.delegate = self;
    [_audioPlayer play];
    
    WCSafeSetErrorPtr(error, errorL);
    
    if (errorL) {
        return NO;
    }
    else {
        _table[data] = completion;
        return YES;
    }
}

- (void)stop {
    [self.audioPlayer stop];
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        id key;
        if (player.url) {
            key = player.url;
        }
        else if (player.data) {
            key = player.data;
        }
        
        if (key) {
            void (^completion)(BOOL finished, NSError *error) = self.table[key];
            !completion ?: completion(YES, nil);
        }
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    id key;
    if (player.url) {
        key = player.url;
    }
    else if (player.data) {
        key = player.data;
    }
    
    if (key) {
        void (^completion)(BOOL finished, NSError *error) = self.table[key];
        !completion ?: completion(NO, error);
    }
}

@end
