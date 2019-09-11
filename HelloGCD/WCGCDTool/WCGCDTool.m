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

+ (BOOL)safeDispatchGroupAsyncWithGroupTaskInfo:(WCGCDGroupTaskInfo *)groupTaskInfo runTaskBlock:(void(^)(id data, void (^taskBlockFinished)(id processedData, NSError * _Nullable error)))runTaskBlock allTaskCompletionBlock:(void (^)(NSArray *dataArray, NSError * _Nullable error))allTaskCompletionBlock  {
    
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
    BOOL ordered = groupTaskInfo.ordered;
    
    WCThreadSafeArray *threadSafeArray = ordered
        ? [[WCThreadSafeArray alloc] initWithPlaceholderObject:[NSNull null] count:dataArray.count]
        : [[WCThreadSafeArray alloc] initWithCapacity:dataArray.count];
    __block NSError *completionError = nil;
    
    if (dataArray.count == 1) {
        dispatch_async(task_queue, ^{
            runTaskBlock([dataArray firstObject], ^(id processedData, NSError * _Nullable error) {
                
                if (ordered) {
                    if (processedData) {
                        threadSafeArray[0] = processedData;
                    }
                }
                else {
                    [threadSafeArray addObject:processedData ?: [NSNull null]];
                }
                
                dispatch_async(completion_queue, ^{
                    if (error) {
                        completionError = error;
                    }
                    allTaskCompletionBlock([threadSafeArray arrayRepresentation], completionError);
                });
            });
        });
    }
    else {
        dispatch_group_t group = dispatch_group_create();
        
        for (NSInteger i = 0; i < dataArray.count; i++) {
            dispatch_group_enter(group);
        }
        
        __block NSUInteger index = 0;
        for (id data in dataArray) {
            __block BOOL taskBlockFinishedCalled = NO;
            dispatch_async(task_queue, ^{
                runTaskBlock(data, ^(id processedData, NSError * _Nullable error) {
                    
                    // Note: prevent this block called many times to cause the dispatch_group_leave
                    // not balance with dispatch_group_enter
                    if (taskBlockFinishedCalled) {
                        return;
                    }
                    
                    taskBlockFinishedCalled = YES;
                    
                    if (ordered) {
                        if (processedData) {
                            threadSafeArray[index] = processedData;
                        }
                    }
                    else {
                        [threadSafeArray addObject:processedData ?: [NSNull null]];
                    }
                    
                    if (error) {
                        completionError = error;
                    }
                    
                    dispatch_group_leave(group);
                });
            });
            ++index;
        }
        
        dispatch_group_notify(group, completion_queue, ^{
            allTaskCompletionBlock([threadSafeArray arrayRepresentation], completionError);
        });
    }
    
    return YES;
}

@end
