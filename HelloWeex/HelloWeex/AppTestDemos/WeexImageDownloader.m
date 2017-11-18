//
//  WeexImageDownloader.m
//  HelloWeex
//
//  Created by wesley_chen on 18/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "WeexImageDownloader.h"
#import <SDWebImage/SDWebImageManager.h>

@implementation WeexImageDownloader

- (id<WXImageOperationProtocol>)downloadImageWithURL:(NSString *)url imageFrame:(CGRect)imageFrame userInfo:(NSDictionary *)options completed:(void(^)(UIImage *image,  NSError *error, BOOL finished))completedBlock {
    
    return (id<WXImageOperationProtocol>)[[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:url] options:kNilOptions progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (completedBlock) {
            completedBlock(image, error, finished);
        }
    }];
}

@end
