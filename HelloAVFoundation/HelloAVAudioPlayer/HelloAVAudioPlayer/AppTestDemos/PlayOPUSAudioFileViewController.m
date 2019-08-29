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
@property (nonatomic, strong) NSArray<NSString *> *audioFiles;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation PlayOPUSAudioFileViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        // @see http://www.kozco.com/tech/soundtests.html
        _audioFiles = @[
                        @"piano2.wav",
                        @"voice1.amr",
                        @"separatorSound.m4a",
                        @"detodos.opus",
                        ];
    }
    return self;
}

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

#pragma mark - Getters

- (WCAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        _audioPlayer = [WCAudioPlayer new];
    }
    
    return _audioPlayer;
}

@end
