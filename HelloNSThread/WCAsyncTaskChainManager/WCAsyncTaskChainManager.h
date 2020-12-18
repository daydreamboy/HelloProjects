//
//  WCAsyncTaskChainManager.h
//  HelloNSThread
//
//  Created by wesley_chen on 2020/8/13.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCAsyncTaskHandlerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WCAsyncTaskHandler;

/**
 A manager which make a chain with some async task handler,
 so input data can pass through between different handlers, and get the final processed data
 */
@interface WCAsyncTaskChainManager : NSObject

/**
 Initialize with ordered handlers
 
 @param classes the handler class strings
 @param bizKey the unique ID
 
 @return the instance
 */
- (instancetype)initWithTaskHandlerClasses:(NSArray<NSString *> *)classes bizKey:(NSString *)bizKey;

/**
 Start processing data by passing through data between handlers
 
 @param data the data to process
 @param completion the calback when all handlers finished
 
 @return YES if parameters are correct, or NO if parameters are not correct
 */
- (BOOL)startTaskHandlersWithData:(id)data completion:(void (^)(WCAsyncTaskChainContext *context))completion;

@end

NS_ASSUME_NONNULL_END
