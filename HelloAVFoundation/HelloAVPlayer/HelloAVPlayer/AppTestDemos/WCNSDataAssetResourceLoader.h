//
//  WCNSDataAssetResourceLoader.h
//  HelloAVPlayer
//
//  Created by wesley_chen on 2018/7/4.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface WCNSDataAssetResourceLoader : NSObject <AVAssetResourceLoaderDelegate>
- (instancetype)initWithData:(NSData *)data contentType:(NSString *)contentType;
@end
