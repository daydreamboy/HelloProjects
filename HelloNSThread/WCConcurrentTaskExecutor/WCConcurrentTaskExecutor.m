//
//  WCConcurrentTaskExecutor.m
//  HelloNSThread
//
//  Created by wesley_chen on 2021/6/28.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "WCConcurrentTaskExecutor.h"

@interface WCConcurrentTaskExecutor ()
@property (nonatomic, assign) NSUInteger maxConcurrency;
@property (nonatomic, strong) dispatch_semaphore_t sema;
@property (nonatomic, strong) dispatch_queue_t taskQueue;
@property (nonatomic, assign) BOOL shouldAllTasksContinue;
@property (nonatomic, strong) NSRecursiveLock *rLockForContinueFlag;
@property (nonatomic, strong) NSRecursiveLock *rLockForKeyContainer;
@property (nonatomic, strong) NSMutableArray *keyContainers;
@end

@implementation WCConcurrentTaskExecutor

- (instancetype)initWithMaxConcurrency:(NSUInteger)maxConcurrency {
    self = [super init];
    if (self) {
        if (maxConcurrency <= 0) {
            maxConcurrency = 1;
        }
        _maxConcurrency = maxConcurrency;
        _sema = dispatch_semaphore_create(maxConcurrency);
        _taskQueue = dispatch_queue_create("com.wc.WCConcurrentTaskExecutor.queue.c", DISPATCH_QUEUE_CONCURRENT);
        
        _shouldAllTasksContinue = YES;
        _keyContainers = [NSMutableArray array];
        
        _rLockForContinueFlag = [[NSRecursiveLock alloc] init];
        _rLockForKeyContainer = [[NSRecursiveLock alloc] init];
    }
    return self;
}

- (BOOL)addAsyncTask:(WCAsyncTaskBlock)block {
    return [self addAsyncTask:block data:nil forKey:[NSUUID UUID].UUIDString timeout:0 timeoutBlock:nil];
}

- (BOOL)addAsyncTask:(WCAsyncTaskBlock)block data:(nullable id)data timeout:(dispatch_time_t)timeout timeoutBlock:(nullable WCAsyncTaskTimeoutBlock)timeoutBlock {
    return [self addAsyncTask:block data:data forKey:[NSUUID UUID].UUIDString timeout:timeout timeoutBlock:timeoutBlock];
}

#pragma mark -

- (BOOL)addAsyncTask:(WCAsyncTaskBlock)block data:(nullable id)data forKey:(NSString *)key timeout:(dispatch_time_t)timeout timeoutBlock:(nullable WCAsyncTaskTimeoutBlock)timeoutBlock {
    
    dispatch_async(_taskQueue, ^{
        [self.rLockForContinueFlag lock];
        BOOL shouldContinue = self.shouldAllTasksContinue;
        [self.rLockForContinueFlag unlock];
        
        if (!shouldContinue) {
            return;
        }
        
        [self.rLockForKeyContainer lock];
        [self.keyContainers addObject:key];
        [self.rLockForKeyContainer unlock];
        
        dispatch_time_t timeoutL = timeout > 0 ? timeout : (DISPATCH_TIME_FOREVER);
        
        intptr_t code = dispatch_semaphore_wait(self.sema, timeoutL);
        BOOL isTimeout = code == 0 ? NO : YES;
        if (isTimeout) {
            BOOL shouldContinue = YES;
            !timeoutBlock ?: timeoutBlock(self, &shouldContinue);
            
            [self.rLockForContinueFlag lock];
            self.shouldAllTasksContinue = shouldContinue;
            [self.rLockForContinueFlag unlock];
            
            dispatch_semaphore_signal(self.sema);
            
            [self checkKeyContainersIfEmptyWithKey:key];
        }
        else {
            void (^completion)(void) = ^{
                dispatch_semaphore_signal(self.sema);
                
                [self checkKeyContainersIfEmptyWithKey:key];
            };
            
            !block ?: block(data, completion);
        }
    });
    
    return YES;
}

- (void)checkKeyContainersIfEmptyWithKey:(NSString *)key {
    // Note: rLockForKeyContainer protect self.keyContainers and self.allTaskFinishedCompletion
    [self.rLockForKeyContainer lock];
    [self.keyContainers removeObject:key];
    
    BOOL isNoRunningTasks = self.keyContainers.count == 0 ? YES : NO;
    if (isNoRunningTasks) {
        !self.allTaskFinishedCompletion ?: self.allTaskFinishedCompletion(self);
    }
    
    [self.rLockForKeyContainer unlock];
}

@end
