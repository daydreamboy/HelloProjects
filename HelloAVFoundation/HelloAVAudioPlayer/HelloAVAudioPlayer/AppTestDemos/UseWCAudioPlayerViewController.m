//
//  UseWCAudioPlayerViewController.m
//  HelloAVAudioPlayer
//
//  Created by wesley_chen on 2018/8/3.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseWCAudioPlayerViewController.h"
#import "WCMacroTool.h"
#import "WCAudioPlayer.h"
#import "UIView+Addition.h"

#import <AVFoundation/AVFoundation.h>

@interface UseWCAudioPlayerViewController ()
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) NSArray<NSURL *> *audioURLs;
@property (nonatomic, strong) WCAudioPlayer *audioPlayer;
@property (nonatomic, assign) NSInteger currentPlayingIndex;

@end

@implementation UseWCAudioPlayerViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _audioURLs = @[
                       URLForResourceInBundle(@"voice1.amr", nil),
                       URLForResourceInBundle(@"voice2.amr", nil),
                       URLForResourceInBundle(@"voice3.amr", nil),
                       ];
        _currentPlayingIndex = -1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.label1];
    [self.view addSubview:self.label2];
    [self.view addSubview:self.label3];
    
    NSData *separatorSoundData = [NSData dataWithContentsOfFile:PathForResourceInBundle(@"separatorSound.m4a", nil)];
    [self.audioPlayer playAudioWithData:separatorSoundData error:nil completion:^(BOOL finished, NSError *error) {
        NSLog(@"completed");
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

- (WCAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        _audioPlayer = [WCAudioPlayer new];
    }
    
    return _audioPlayer;
}

#pragma mark - Actions

- (void)viewTapped:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    NSURL *audioURL = tappedView.userInfo;
    NSInteger startIndex = [self.audioURLs indexOfObject:audioURL];
    if (startIndex == self.currentPlayingIndex) {
        // TODO: stop
        [self.audioPlayer stop];
    }
    else {
        [self playAudioURLsContinuouslyStartedAtIndex:startIndex];
    }
    
    if (tappedView == self.label1) {
        
    }
    else if (tappedView == self.label2) {
        
    }
    else if (tappedView == self.label3) {
        
    }
}

#pragma mark -

- (void)playAudioURLsContinuouslyStartedAtIndex:(NSInteger)index {
    if (0 <= index && index < self.audioURLs.count) {
        NSError *error;
        NSURL *audioURL = self.audioURLs[index];
        self.currentPlayingIndex = index;
        [self.audioPlayer playAudioWithURL:audioURL error:&error completion:^(BOOL finished, NSError *error) {
            self.currentPlayingIndex = -1;
            if (finished && !error) {
                NSURL *separatorSoundURL = URLForResourceInBundle(@"separatorSound.m4a", nil);
                [self.audioPlayer playAudioWithURL:separatorSoundURL error:nil completion:^(BOOL finished, NSError *error) {
                    [self playAudioURLsContinuouslyStartedAtIndex:index + 1];
                }];
            }
        }];
    }
}

- (float)audioDurationWithFileURL:(NSURL *)fileURL {
    // @see https://stackoverflow.com/a/7052147
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    CMTime duration = audioAsset.duration;
    float durationInSeconds = CMTimeGetSeconds(duration);
    return durationInSeconds;
}

@end
