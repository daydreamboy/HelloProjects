//
//  WCAudioPlayer.h
//  HelloAVAudioPlayer
//
//  Created by wesley_chen on 2018/8/3.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface WCAudioPlayer : NSObject

/**
 Play audio by URL with completion block

 @param URL the file URL
 @param error the error not nil when return NO
 @param completion the completion when play finished or finished with error
    - finished YES if playback is over, NO if playback is stopped when some error occurred
    - error the error is not nil when finished is NO
 @return YES if can play audio, NO if can't play audio
 */
- (BOOL)playAudioWithURL:(NSURL *)URL error:(NSError **)error completion:(void (^)(BOOL finished, NSError *error))completion;

/**
 Play audio by data with completion block

 @param data the data
 @param error the error not nil when return NO
 @param completion the completion when play finished or finished with error
     - finished YES if playback is over, NO if playback is stopped when some error occurred
     - error the error is not nil when finished is NO
 @return YES if can play audio, NO if can't play audio
 */
- (BOOL)playAudioWithData:(NSData *)data error:(NSError **)error completion:(void (^)(BOOL finished, NSError *error))completion;

/**
 Stop won't make completion called
 */
- (void)stop;
@end
