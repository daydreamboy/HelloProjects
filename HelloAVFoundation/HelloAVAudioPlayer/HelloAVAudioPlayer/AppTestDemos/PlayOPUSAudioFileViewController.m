//
//  PlayOPUSAudioFileViewController.m
//  HelloAVAudioPlayer
//
//  Created by wesley_chen on 2018/8/6.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "PlayOPUSAudioFileViewController.h"
#import "WCMacroTool.h"
#import "WCAudioPlayer.h"

@interface PlayOPUSAudioFileViewController ()
@property (nonatomic, strong) WCAudioPlayer *audioPlayer;
@end

@implementation PlayOPUSAudioFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSData *separatorSoundData = [NSData dataWithContentsOfFile:PathForResourceInBundle(@"detodos.opus", nil)];
    NSError *error;
    BOOL status = [self.audioPlayer playAudioWithData:separatorSoundData error:&error completion:^(BOOL finished, NSError *error) {
        NSLog(@"completed");
    }];
    if (error) {
        NSLog(@"not support format: %@", error);
    }
}

- (WCAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        _audioPlayer = [WCAudioPlayer new];
    }
    
    return _audioPlayer;
}

@end
