//
//  WCAsyncTaskExecutor.h
//  HelloNSThread
//
//  Created by wesley_chen on 2020/6/24.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^WCAsyncTaskCompletion)(void);
typedef void (^WCAsyncTaskTimeoutBlock)(id _Nullable data, BOOL *shouldContinue);
typedef void (^WCAsyncTaskBlock)(id _Nullable data, WCAsyncTaskCompletion completion);

typedef NS_ENUM(NSUInteger, WCAsyncTaskExecuteMode) {
    WCAsyncTaskExecuteModeSerial,
    WCAsyncTaskExecuteModeConcurrent,
};

@class WCAsyncTaskExecutor;

/**
 A task executor to execute async task one by one
 */
@interface WCAsyncTaskExecutor : NSObject

@property (nonatomic, assign, readonly) WCAsyncTaskExecuteMode executeMode;
/// The completion when all tasks finished
@property (nonatomic, copy) void (^allTaskFinishedCompletion)(WCAsyncTaskExecutor *executor);

/**
 Create an autorelease WCAsyncTaskExecutor
 
 @return the WCAsyncTaskExecutor instance
 
 @discussion After allTaskFinishedCompletion has been called, the WCAsyncTaskExecutor object will be released.
 You don't need to hold the returned WCAsyncTaskExecutor instance
 */
+ (WCAsyncTaskExecutor *)autoreleaseTaskExecutor;

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
 @param key the unique key to identify the task
 @param timeout the timeout for the task. If timeout, timeoutBlock will be called
 @param timeoutBlock the callback when the task is timeout
 
 @return YES if parameter is correct. NO if not
 
 @discussion If the key is same with the previous task has been added (running or wait to run), the current task is ignored.
 If the previous task has been added and run finished, the task with same key is OK to added.
 */
- (BOOL)addAsyncTask:(WCAsyncTaskBlock)block data:(nullable id)data forKey:(nullable NSString *)key timeout:(NSTimeInterval)timeout timeoutBlock:(nullable WCAsyncTaskTimeoutBlock)timeoutBlock;

@end

NS_ASSUME_NONNULL_END
