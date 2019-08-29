//
//  WCImageTool.h
//  HelloAVMedia
//
//  Created by wesley_chen on 2019/8/8.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCImageTool : NSObject

#pragma mark > From Video

+ (nullable UIImage *)imageWithVideoFilePath:(NSString *)videoFilepath frameTimestamp:(NSTimeInterval)frameTimestamp;

@end

NS_ASSUME_NONNULL_END
