//
//  WCConcurrentTaskExecutor.h
//  HelloNSThread
//
//  Created by wesley_chen on 2021/6/28.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The task completion block
 
 @discussion If the task finished, you must call this completion
 */
typedef void (^WCAsyncTaskCompletion)(void);
/**
 The timeout block
 
 @param data the input data for the task
 @param shouldContinue the flag for should continue process next task  if the current task is timeout
 */
typedef void (^WCAsyncTaskTimeoutBlock)(id _Nullable data, BOOL *shouldContinue);
/**
 The task block
 
 @param data the input data for the task
 @param completion the completion. If the task block finished, you must call this completion
 */
typedef void (^WCAsyncTaskBlock)(id _Nullable data, WCAsyncTaskCompletion completion);

typedef NS_ENUM(NSUInteger, WCAsyncTaskExecuteMode) {
    WCAsyncTaskExecuteModeSerial,
    WCAsyncTaskExecuteModeConcurrent,
};

@interface WCConcurrentTaskExecutor : NSObject

@property (nonatomic, assign, readonly) WCAsyncTaskExecuteMode executeMode;
/**
 The completion when all tasks finished
 
 @discussion This block maybe called multiple times
 */
@property (nonatomic, copy) void (^allTaskFinishedCompletion)(WCConcurrentTaskExecutor *executor);

- (instancetype)initWithMaxConcurrency:(NSUInteger)maxConcurrency;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 Add a block as Task to run or wait to run
 
 @param block the task
        - completion, if task is finished, call the completion
 
 @return YES if parameter is correct. NO if not
 */
- (BOOL)addAsyncTask:(WCAsyncTaskBlock)block;

/**
 Add a block as Task to run or wait to run
 
 @param block the task
        - completion, if task is finished, call the completion
 @param data the input data for the task
 @param timeout the timeout for the task. If timeout, timeoutBlock will be called
 @param timeoutBlock the callback when the task is timeout
 
 @return YES if parameter is correct. NO if not
 
 @discussion If the key is same with the previous task has been added (running or wait to run), the current task is ignored.
 If the previous task has been added and run finished, the task with same key is OK to added.
 */
- (BOOL)addAsyncTask:(WCAsyncTaskBlock)block data:(nullable id)data timeout:(dispatch_time_t)timeout timeoutBlock:(nullable WCAsyncTaskTimeoutBlock)timeoutBlock;

@end

NS_ASSUME_NONNULL_END
