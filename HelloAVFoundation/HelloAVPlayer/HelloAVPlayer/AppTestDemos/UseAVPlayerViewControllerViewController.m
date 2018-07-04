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
@property (nonatomic, strong) AVPlayer *player;
@end

@implementation UseAVPlayerViewControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self presentPlayerViewController];
    
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"availableDuration: %f", [self availableDuration]);
    }];
}

#pragma mark -

- (void)presentPlayerViewController {
    // @see https://stackoverflow.com/questions/25348877/how-to-play-a-local-video-with-swift
    //AVPlayer *player = [AVPlayer playerWithURL:self.URLLocalDemo1];
    AVPlayer *player = [AVPlayer playerWithURL:self.URLRemoteDemo1];
    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    playerViewController.player = player;
    
    [self presentViewController:playerViewController animated:YES completion:^{
        [player play];
    }];
    
    self.player = player;
}

- (NSTimeInterval)availableDuration {
    // @see https://stackoverflow.com/a/7730708
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [[loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
    Float64 startSeconds = CMTimeGetSeconds(timeRange.start);
    Float64 durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;
    return result;
}

@end
