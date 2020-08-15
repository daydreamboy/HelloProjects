//
//  WCAsyncTaskHandlerProtocol.h
//  HelloNSThread
//
//  Created by wesley_chen on 2020/8/14.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TaskHandlerCompletion)(id data, NSError * _Nullable error);

@protocol WCAsyncTaskHandler;

/**
 The context for task handler
 */
@interface WCAsyncTaskChainContext : NSObject
/// The data transfers between the chained handlers
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

/**
 The specification for custom handlers
 */
@protocol WCAsyncTaskHandler <NSObject>

@required

/// Initialization
- (instancetype)initWithBizKey:(NSString *)bizKey;
/// The name of handlers
- (NSString *)name;
/**
 The processing method of the handler
 
 @param context the context pass through between handler. Don't hold the context
 @param taskHandlerCompletion when the handler finishing its task, call this block to let next handler to continue or cancel to abort
        - data, the data passed by previous handler or original data
        - error, the error generated by previous handler
 */
- (void)handleWithContext:(WCAsyncTaskChainContext *)context taskHandlerCompletion:(TaskHandlerCompletion)taskHandlerCompletion;

@optional

/// The interval of timeout. If forever, pass <=0, or not implements this method
- (NSTimeInterval)timeoutInterval;

@end

NS_ASSUME_NONNULL_END
