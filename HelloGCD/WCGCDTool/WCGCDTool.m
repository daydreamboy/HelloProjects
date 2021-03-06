//
//  WCGCDTool.m
//  HelloGCD
//
//  Created by wesley_chen on 12/12/2017.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import "WCGCDTool.h"
#import "WCThreadSafeArray.h"

@implementation WCGCDGroupTaskInfo
@end

@implementation WCGCDTool

+ (BOOL)safePerformBlockOnMainQueue:(dispatch_block_t)block {
    if (!block) {
        return NO;
    }
    
    if ([NSThread isMainThread]) {
        block();
    }
    else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
    
    return YES;
}

+ (BOOL)safeDispatchGroupEnterLeavePairWithGroupTaskInfo:(WCGCDGroupTaskInfo *)groupTaskInfo runTaskBlock:(void(^)(id data, NSUInteger index, void (^taskBlockFinished)(id _Nullable processedData, NSError * _Nullable error)))runTaskBlock allTaskCompletionBlock:(void (^)(NSArray *dataArray, NSArray *errorArray))allTaskCompletionBlock  {
    
    if (![groupTaskInfo isKindOfClass:[WCGCDGroupTaskInfo class]]) {
        return NO;
    }
    
    if (![groupTaskInfo.dataArray isKindOfClass:[NSArray class]] ||
        ([groupTaskInfo.dataArray isKindOfClass:[NSArray class]] && groupTaskInfo.dataArray.count == 0)) {
        return NO;
    }
    
    if (groupTaskInfo.taskQueue == NULL || groupTaskInfo.completionQueue == NULL) {
        return NO;
    }
    
    if (runTaskBlock == NULL || allTaskCompletionBlock == NULL) {
        return NO;
    }
    
    dispatch_queue_t task_queue = groupTaskInfo.taskQueue;
    dispatch_queue_t completion_queue = groupTaskInfo.completionQueue;
    NSArray *dataArray = groupTaskInfo.dataArray;
    
    WCThreadSafeArray *processedDataArray = [[WCThreadSafeArray alloc] initWithPlaceholderObject:[NSNull null] count:dataArray.count];
    WCThreadSafeArray *errorArray = [[WCThreadSafeArray alloc] initWithPlaceholderObject:[NSNull null] count:dataArray.count];
    
    if (dataArray.count == 1) {
        dispatch_async(task_queue, ^{
            runTaskBlock([dataArray firstObject], 0, ^(id processedData, NSError * _Nullable error) {
                
                if (processedData) {
                    processedDataArray[0] = processedData;
                }
                
                dispatch_async(completion_queue, ^{
                    if (error) {
                        errorArray[0] = error;
                    }
                    allTaskCompletionBlock([processedDataArray arrayRepresentation], [errorArray arrayRepresentation]);
                });
            });
        });
    }
    else {
        dispatch_group_t group = dispatch_group_create();
        
        for (NSInteger i = 0; i < dataArray.count; i++) {
            dispatch_group_enter(group);
        }
        
        NSUInteger index = 0;
        for (id data in dataArray) {
            __block BOOL taskBlockFinishedCalled = NO;
            dispatch_async(task_queue, ^{
                runTaskBlock(data, index, ^(id _Nullable processedData, NSError * _Nullable error) {
                    
                    // Note: prevent this block called many times to cause the dispatch_group_leave
                    // not balance with dispatch_group_enter
                    if (taskBlockFinishedCalled) {
                        return;
                    }
                    
                    taskBlockFinishedCalled = YES;
                    
                    if (processedData) {
                        processedDataArray[index] = processedData;
                    }
                    
                    if (error) {
                        errorArray[index] = error;
                    }
                    
                    dispatch_group_leave(group);
                });
            });
            ++index;
        }
        
        dispatch_group_notify(group, completion_queue, ^{
            allTaskCompletionBlock([processedDataArray arrayRepresentation], [errorArray arrayRepresentation]);
        });
    }
    
    return YES;
}

+ (BOOL)performSynchronouslyWithAsyncTask:(void (^)(WCGCDToolAsyncTaskSynchronizedCompletion completion))asyncTask timeout:(dispatch_time_t)timeout {
    if (!asyncTask) {
        return NO;
    }
    
    // @see https://stackoverflow.com/a/21191050
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    __block BOOL status = NO;
    __block BOOL isTimeout = NO;
    __block BOOL isCompletionCalled = NO;
    WCGCDToolAsyncTaskSynchronizedCompletion completion = ^(BOOL success) {
        // Note: protect `status` to write different values if completion called many times
        if (isCompletionCalled) {
            return;
        }
        
        if (!isTimeout) {
            status = success;
            dispatch_semaphore_signal(sema);
        }
        
        isCompletionCalled = YES;
    };
    
    if (asyncTask) {
        asyncTask(completion);
    }
    else {
        completion(NO);
    }
    
    intptr_t code = dispatch_semaphore_wait(sema, timeout); // the current queue is waiting
    isTimeout = code == 0 ? NO : YES;
    if (isTimeout) {
        return NO;
    }
    
    return status;
}

@end
