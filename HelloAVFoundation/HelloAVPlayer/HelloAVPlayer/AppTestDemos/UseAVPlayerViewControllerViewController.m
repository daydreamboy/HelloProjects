//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "UseAVPlayerViewControllerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface UseAVPlayerViewControllerViewController ()

@end

@implementation UseAVPlayerViewControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self presentPlayerViewController];
}

#pragma mark -

- (void)presentPlayerViewController {
    // @see https://stackoverflow.com/questions/25348877/how-to-play-a-local-video-with-swift
    AVPlayer *player = [AVPlayer playerWithURL:self.URLDemo1];
    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    playerViewController.player = player;
    
    [self presentViewController:playerViewController animated:YES completion:^{
        [player play];
    }];
}

@end
