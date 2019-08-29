//
//  WCImageTool.m
//  HelloAVMedia
//
//  Created by wesley_chen on 2019/8/8.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCImageTool.h"
#import <AVFoundation/AVFoundation.h>

@implementation WCImageTool

+ (nullable UIImage *)imageWithVideoFilePath:(NSString *)videoFilepath frameTimestamp:(NSTimeInterval)frameTimestamp {
    if (![videoFilepath isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSURL *url = [NSURL fileURLWithPath:videoFilepath];
    if (!url) {
        return nil;
    }
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    
    CMTime endTime = asset.duration;
    CMTime startTime = CMTimeMake(0, 1);
    CMTime requestedTime = CMTimeMinimum(endTime, CMTimeMaximum(CMTimeMakeWithSeconds(frameTimestamp, 1), startTime));
    
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:requestedTime actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    
    return thumbnail;
}

@end
