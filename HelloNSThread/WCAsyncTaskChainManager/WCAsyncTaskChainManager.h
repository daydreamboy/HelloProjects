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

@interface WCAsyncTaskChainManager : NSObject

- (instancetype)initWithTaskHandlerClasses:(NSArray<NSString *> *)classes bizKey:(NSString *)bizKey;
- (BOOL)startTaskHandlersWithData:(id)data completion:(void (^)(WCAsyncTaskChainContext *context))completion;

@end

NS_ASSUME_NONNULL_END
