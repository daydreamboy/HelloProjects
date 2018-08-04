//
//  ContinuousPlayVoiceViewController.m
//  HelloAVAudioPlayer
//
//  Created by wesley_chen on 2018/8/2.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "ContinuousPlayVoiceViewController.h"
#import "WCMacroTool.h"
#import "WCAudioPlayer.h"
#import "UIView+Addition.h"

#import <AVFoundation/AVFoundation.h>


@interface ContinuousPlayVoiceViewController () <AVAudioPlayerDelegate>
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSArray<NSURL *> *audioURLs;
@property (nonatomic, strong) WCAudioPlayer *audioPlayer2;
@end

@implementation ContinuousPlayVoiceViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _audioURLs = @[
                       URLForResourceInBundle(@"voice1.amr", nil),
                       URLForResourceInBundle(@"voice2.amr", nil),
                       URLForResourceInBundle(@"voice3.amr", nil),
                       ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.label1];
    [self.view addSubview:self.label2];
    [self.view addSubview:self.label3];
    
    [self playVoiceMessageSeparatorSoundWithCompletion:^(BOOL finished, NSError *error) {
        NSLog(@"play finished");
    }];
}

#pragma mark - Getters

- (UILabel *)label1 {
    if (!_label1) {
        CGFloat width = arc4random() % 100 + 50;
        NSURL *audioFileURL = self.audioURLs[0];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, width, 30)];
        label.userInteractionEnabled = YES;
        label.backgroundColor = [UIColor yellowColor];
        label.layer.cornerRadius = 12;
        label.text = [NSString stringWithFormat:@"%0.2f\"", [self audioDurationWithFileURL:audioFileURL]];
        label.userInfo = audioFileURL;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        [label addGestureRecognizer:tapGesture];

        _label1 = label;
    }
    
    return _label1;
}

- (UILabel *)label2 {
    if (!_label2) {
        CGFloat width = arc4random() % 100 + 50;
        NSURL *audioFileURL = self.audioURLs[1];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.label1.frame) + 10, width, 30)];
        label.userInteractionEnabled = YES;
        label.backgroundColor = [UIColor yellowColor];
        label.layer.cornerRadius = 12;
        label.text = [NSString stringWithFormat:@"%0.2f\"", [self audioDurationWithFileURL:audioFileURL]];
        label.userInfo = audioFileURL;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        [label addGestureRecognizer:tapGesture];
        
        _label2 = label;
    }
    
    return _label2;
}

- (UILabel *)label3 {
    if (!_label3) {
        CGFloat width = arc4random() % 100 + 50;
        NSURL *audioFileURL = self.audioURLs[2];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.label2.frame) + 10, width, 30)];
        label.userInteractionEnabled = YES;
        label.backgroundColor = [UIColor yellowColor];
        label.layer.cornerRadius = 12;
        label.text = [NSString stringWithFormat:@"%0.2f\"", [self audioDurationWithFileURL:audioFileURL]];
        label.userInfo = audioFileURL;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        [label addGestureRecognizer:tapGesture];
        
        _label3 = label;
    }
    
    return _label3;
}

#pragma mark - Actions

- (void)viewTapped:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    NSURL *audioURL = tappedView.userInfo;
    [self playAudioWithURL:audioURL];
    
    if (tappedView == self.label1) {
        
    }
    else if (tappedView == self.label2) {
        
    }
    else if (tappedView == self.label3) {
        
    }
}

- (void)playAudioWithURL:(NSURL *)URL {
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:&error];
    self.audioPlayer.delegate = self;
    [self.audioPlayer play];
}

#pragma mark -

- (float)audioDurationWithFileURL:(NSURL *)fileURL {
    // @see https://stackoverflow.com/a/7052147
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    CMTime duration = audioAsset.duration;
    float durationInSeconds = CMTimeGetSeconds(duration);
    return durationInSeconds;
}

- (void)playVoiceMessageSeparatorSoundWithCompletion:(void (^)(BOOL finished, NSError *error))completion {
    static NSData *sSeparatorAudioData;
    if (!sSeparatorAudioData) {
        NSString *filePath = PathForResourceInBundle(@"separatorSound.m4a", nil);
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            sSeparatorAudioData = [NSData dataWithContentsOfFile:filePath];
        }
        else {
            NSError *error = [NSError errorWithDomain:@"NSFileManager" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"file not found"}];
            !completion ?: completion(NO, error);
        }
    }
    
    [self playAudioOnlyOnceWithData:sSeparatorAudioData completion:^(BOOL finished, NSError *error) {
        !completion ?: completion(finished, error);
    }];
}

- (void)playAudioOnlyOnceWithData:(NSData *)data completion:(void (^)(BOOL finished, NSError *error))completion {
    if (!data) {
        NSError *error = [NSError errorWithDomain:@"NSData" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"data is nil"}];
        !completion ?: completion(NO, error);
        return;
    }
    
    NSError *error = nil;
    __block AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data error:&error];
    NSTimeInterval duration = player.duration;
    if (error) {
        NSLog(@"error: %@", error);
        !completion ?: completion(NO, error);
    }
    else {
        [player play];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // Note: let the block retain the player
            [player setDelegate:nil];
            !completion ?: completion(YES, nil);
        });
    }
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSURL *URL = player.url;
    NSInteger index = [self.audioURLs indexOfObject:URL];
    if (index != NSNotFound) {
        if (index + 1 < self.audioURLs.count) {
            [self playVoiceMessageSeparatorSoundWithCompletion:^(BOOL finished, NSError *error) {
                NSURL *nextURL = self.audioURLs[index + 1];
                [self playAudioWithURL:nextURL];
            }];
        }
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
}


@end
