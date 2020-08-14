//
//  WCAsyncTaskHandlerProtocol.h
//  HelloNSThread
//
//  Created by wesley_chen on 2020/8/14.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WCAsyncTaskHandlerSynthesize \
@synthesize name = _name;

NS_ASSUME_NONNULL_BEGIN

typedef void(^TaskHandlerCompletion)(id data, NSError * _Nullable error);

@protocol WCAsyncTaskHandler;

/**
 The context for task handler
 */
@interface WCAsyncTaskChainContext : NSObject
/// The data transfer between the chained handlers
@property (nonatomic, strong, readonly) id data;
/// The error if occurred in some one handler
@property (nonatomic, strong, readonly, nullable) NSError *error;
/// The previous handler
@property (nonatomic, weak, readonly, nullable) id<WCAsyncTaskHandler> previousHandler;
/// The next handler
@property (nonatomic, weak, readonly, nullable) id<WCAsyncTaskHandler> nextHandler;
/// If need to cancel continue process data, set cancelled to YES
@property (nonatomic, assign) BOOL cancelled;
@end

@protocol WCAsyncTaskHandler <NSObject>

@required

- (instancetype)initWithBizKey:(NSString *)bizKey;
- (NSString *)name;
- (void)handleWithContext:(WCAsyncTaskChainContext *)context taskHandlerCompletion:(TaskHandlerCompletion)taskHandlerCompletion;

@optional

- (NSTimeInterval)timeoutInterval;

@end

NS_ASSUME_NONNULL_END
