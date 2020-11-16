//
//  WCGCDTool.h
//  HelloGCD
//
//  Created by wesley_chen on 12/12/2017.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^WCGCDToolAsyncTaskSynchronizedCompletion)(BOOL success);

@interface WCGCDGroupTaskInfo : NSObject
@property (nonatomic, copy, nullable) NSString *groupName;
@property (nonatomic, strong) dispatch_queue_t taskQueue;
@property (nonatomic, strong) dispatch_queue_t completionQueue;
@property (nonatomic, strong) NSArray<id> *dataArray;
@end

@interface WCGCDTool : NSObject

/**
 Safe run a block always on the main queue

 @param block the block to run
 @return YES if operate successfully, or NO if failed
 @see https://stackoverflow.com/a/10341532
 */
+ (BOOL)safePerformBlockOnMainQueue:(dispatch_block_t)block;

/**
 Safe wrapper the dispatch_group_enter/dispatch_group_leave pair

 @param groupTaskInfo the WCGCDGroupTaskInfo object which include the queues and input data
 @param singleTaskBlock the single task run block
 - data the data to process
 - taskBlockFinished when data finish processing, call this block to pass the processed data and error
 @param allTaskCompletionBlock the callback when all tasks completed
 - dataArray the data array after all tasks finished
 - errorArray the error array after all tasks finished
 @return YES if operate successfully, or NO if failed
 @discussion This method executes runTaskBlock on groupTaskInfo.taskQueue, and executes
 allTaskCompletionBlock on groupTaskInfo.completionQueue
 */
+ (BOOL)safeDispatchGroupEnterLeavePairWithGroupTaskInfo:(WCGCDGroupTaskInfo *)groupTaskInfo runTaskBlock:(void(^)(id data, NSUInteger index, void (^taskBlockFinished)(id _Nullable processedData, NSError * _Nullable error)))singleTaskBlock allTaskCompletionBlock:(void (^)(NSArray *dataArray, NSArray *errorArray))allTaskCompletionBlock;

/**
 Synchronize an asynchronous task. The thread which call this method will wait for the asynchronous task
 
 @param asyncTask the block to encapsulate the asynchronous task. The type is WCGCDToolAsyncTaskSynchronizedCompletion
 -  completion, call completion when finished the asynchronous task, and pass a BOOL to indicate the return value of this method
 @param timeout the time interval for timeout. Pass DISPATCH_TIME_FOREVER or dispatch_time(DISPATCH_TIME_NOW, (int64_t)(N * NSEC_PER_SEC))
 @return the value of completion pass. Or return NO if timeout
 
 @discussion asyncTask is expected to execute asynchronous task, e.g.
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{...});, but also support a synchronous task.
 
 @code
 BOOL success = [WCGCDTool performAsyncTaskSynchronously:^(WCGCDToolAsyncTaskSynchronizedCompletion  _Nonnull completion) {
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        completion(YES/NO);
     });
 } timeout:dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC)];
 
 // Note: the current thread will wait here for asynchronous task finished
 if (sucess) {
    // continue
 }
 @endcode
 */
+ (BOOL)performAsyncTaskSynchronously:(void (^)(WCGCDToolAsyncTaskSynchronizedCompletion completion))asyncTask timeout:(dispatch_time_t)timeout;

@end

NS_ASSUME_NONNULL_END
