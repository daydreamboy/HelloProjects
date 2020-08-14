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
typedef void (^WCAsyncTaskBlock)(WCAsyncTaskCompletion completion);

typedef NS_ENUM(NSUInteger, WCAsyncTaskExecuteMode) {
    WCAsyncTaskExecuteModeSerial,
    WCAsyncTaskExecuteModeConcurrent,
};

@class WCAsyncTaskExecutor;

@protocol WCAsyncTaskExecutorDelegate <NSObject>
/**
 The notification when all tasks finished in the task queue
 
 @discussion This method maybe call many times when all tasks finished in the task queue
 */
- (void)batchTasksAllFinishedWithAsyncTaskExecutor:(WCAsyncTaskExecutor *)exectuor;
@end

/**
 A task executor to execute async task one by one
 */
@interface WCAsyncTaskExecutor : NSObject

@property (nonatomic, assign, readonly) WCAsyncTaskExecuteMode executeMode;
@property (nonatomic, weak) id<WCAsyncTaskExecutorDelegate> delegate;

/**
 Add a block as Task to run or wait to run
 
 @param block the task
 @return YES if parameter is correct. NO if not
 */
- (BOOL)addAsyncTask:(WCAsyncTaskBlock)block;

/**
 Add a block as Task to run or wait to run
 
 @param block the task
 @param key the unique key to identify the task
 @return YES if parameter is correct. NO if not
 @discussion If the key is same with the previous task has been added (running or wait to run), the current task is ignored.
 If the previous task has been added and run finished, the task with same key is OK to added.
 */
- (BOOL)addAsyncTask:(WCAsyncTaskBlock)block forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
