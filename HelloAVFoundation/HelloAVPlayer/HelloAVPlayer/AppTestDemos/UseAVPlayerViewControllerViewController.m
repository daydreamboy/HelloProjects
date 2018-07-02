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
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];
    NSURL *URL = [NSURL fileURLWithPath:filePath];
    AVPlayer *player = [AVPlayer playerWithURL:URL];
    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    playerViewController.player = player;
    
    [self presentViewController:playerViewController animated:YES completion:^{
        [player play];
    }];
}

@end
