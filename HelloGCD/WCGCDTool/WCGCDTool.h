//
//  WCGCDTool.h
//  HelloGCD
//
//  Created by wesley_chen on 12/12/2017.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

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

@end

NS_ASSUME_NONNULL_END
