//
//  WCNSDataAssetResourceLoader.m
//  HelloAVPlayer
//
//  Created by wesley_chen on 2018/7/4.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCNSDataAssetResourceLoader.h"

@interface WCNSDataAssetResourceLoader ()
@property (nonatomic, strong) NSData *data;
@property (nonatomic, copy) NSString *contentType;
@end

@implementation WCNSDataAssetResourceLoader

- (instancetype)initWithData:(NSData *)data contentType:(NSString *)contentType {
    if (self = [super init]) {
        _data = data;
        _contentType = contentType;
    }
    return self;
}

// @see https://stackoverflow.com/a/39926706
// @see https://stackoverflow.com/a/19723622
// @see https://stackoverflow.com/a/16443946
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    AVAssetResourceLoadingContentInformationRequest *contentRequest = loadingRequest.contentInformationRequest;
    
    // TODO: check that loadingRequest.request is actually our custom scheme
    
    if (contentRequest) {
        contentRequest.contentType = self.contentType;
        contentRequest.contentLength = self.data.length;
        contentRequest.byteRangeAccessSupported = YES;
    }
    
    AVAssetResourceLoadingDataRequest *dataRequest = loadingRequest.dataRequest;
    
    if (dataRequest) {
        // TODO: handle requestsAllDataToEndOfResource
        
        NSRange range = NSMakeRange((NSUInteger)dataRequest.requestedOffset, (NSUInteger)dataRequest.requestedLength);
        [dataRequest respondWithData:[self.data subdataWithRange:range]];
        //[dataRequest respondWithData:self.data];
        [loadingRequest finishLoading];
    }
    
    return YES;
}

@end
