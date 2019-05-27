//
//  WCVideoPlayerPage.h
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/7/4.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCBaseHorizontalPage.h"
#import <AVFoundation/AVFoundation.h>

@interface WCVideoPlayerPage : WCBaseHorizontalPage

@property (nonatomic, strong, readonly) UIImageView *imageViewPlayIcon;
@property (nonatomic, assign, readonly) BOOL readyToPlay;
@property (nonatomic, assign, readonly) BOOL playing;
@property (nonatomic, assign, readonly) BOOL paused;

- (void)displayLocalVideo:(NSURL *)fileURL;
- (void)play;
/**
 Auto play when remote video become ready. If ready, play immediately.
 */
- (void)playIfReady;
- (void)stop;

@end
