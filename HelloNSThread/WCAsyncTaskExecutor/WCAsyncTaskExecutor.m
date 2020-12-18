//
//  WCAsyncTaskExecutor.m
//  HelloNSThread
//
//  Created by wesley_chen on 2020/6/24.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCAsyncTaskExecutor.h"
#import "WCMacroTool.h"
#import <QuartzCore/QuartzCore.h>

@interface WCAsyncTask : NSObject
@property (nonatomic, copy) WCAsyncTaskBlock block;
@property (nonatomic, copy, nullable) WCAsyncTaskTimeoutBlock timeoutBlock;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong, nullable) id data;
@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval finishTime;

+ (instancetype)taskWithBlock:(WCAsyncTaskBlock)block data:(nullable id)data forKey:(NSString *)key timeoutInterval:(NSTimeInterval)timeoutInterval timeoutBlock:(WCAsyncTaskTimeoutBlock)timeoutBlock;
@end

@implementation WCAsyncTask

+ (instancetype)taskWithBlock:(WCAsyncTaskBlock)block data:(nullable id)data forKey:(NSString *)key timeoutInterval:(NSTimeInterval)timeoutInterval timeoutBlock:(nullable WCAsyncTaskTimeoutBlock)timeoutBlock {
    WCAsyncTask *holder = [WCAsyncTask new];
    holder.block = block;
    holder.data = data;
    holder.key = key;
    holder.timeoutInterval = timeoutInterval;
    holder.timeoutBlock = timeoutBlock;
    
    return holder;
}

@end

@interface WCAsyncTaskExecutor ()
@property (nonatomic, assign, readwrite) WCAsyncTaskExecuteMode executeMode;
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) dispatch_queue_t timeoutQueue;
@property (nonatomic, strong) NSMutableArray<WCAsyncTask *> *taskList;
@property (nonatomic, strong) WCAsyncTask *currentRunningTask;
@property (nonatomic, strong) NSMutableDictionary<NSString *, WCAsyncTask *> *enqueueMap;
@property (nonatomic, assign) BOOL isRunningTask;
@end

@implementation WCAsyncTaskExecutor

- (instancetype)init {
    self = [super init];
    if (self) {
        _executeMode = WCAsyncTaskExecuteModeSerial;
        _serialQueue = dispatch_queue_create("com.wc.WCAsyncTaskExecutor", DISPATCH_QUEUE_SERIAL);
        _timeoutQueue = dispatch_queue_create("com.wc.WCAsyncTaskExecutor.timeout", DISPATCH_QUEUE_SERIAL);
        _taskList = [NSMutableArray array];
        _enqueueMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
#if DEBUG
    NSLog(@"WCAsyncTaskExecutor: %@, %@", NSStringFromSelector(_cmd), self);
#endif
}

- (BOOL)addAsyncTask:(WCAsyncTaskBlock)block {
    return [self addAsyncTask:block data:nil forKey:[NSUUID UUID].UUIDString timeout:0 timeoutBlock:nil];
}

- (BOOL)addAsyncTask:(WCAsyncTaskBlock)block data:(nullable id)data forKey:(NSString *)key timeout:(NSTimeInterval)timeout timeoutBlock:(nullable WCAsyncTaskTimeoutBlock)timeoutBlock {
    if (!block || ![key isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    weakify(self);
    dispatch_async(self.serialQueue, ^{
        strongifyWithReturn(self, return;);
        
        if (self.enqueueMap[key]) {
            return;
        }
        
        WCAsyncTask *taskToRun = [WCAsyncTask taskWithBlock:block data:data forKey:key timeoutInterval:timeout timeoutBlock:timeoutBlock];
        self.enqueueMap[key] = taskToRun;
        [self.taskList addObject:taskToRun];
        
        if (self.isRunningTask) {
            return;
        }
        
        self.isRunningTask = YES;
        [self runTasksWithAllTasksFinished:^{
            strongifyWithReturn(self, return;);
            
            self.currentRunningTask = nil;
            self.isRunningTask = NO;
            
            !self.allTaskFinishedCompletion ?: self.allTaskFinishedCompletion(self);
        }];
    });
    
    return YES;
}

- (void)runTasksWithAllTasksFinished:(void (^)(void))allTasksFinishedBlock {
    if (self.taskList.count == 0) {
        allTasksFinishedBlock();
        return;
    }

    self.currentRunningTask = [self.taskList firstObject];
    self.currentRunningTask.isRunning = YES;
    [self.taskList removeObjectAtIndex:0];
    
    NSString *taskKey = self.currentRunningTask.key;
    weakify(self);
    WCAsyncTaskCompletion completion = ^{
        strongifyWithReturn(self, return;);
        
        if (![self.currentRunningTask.key isEqualToString:taskKey]) {
            return;
        }
        
        self.currentRunningTask.finishTime = CACurrentMediaTime();
        self.currentRunningTask.isRunning = NO;
        if (self.currentRunningTask.key) {
            [self.enqueueMap removeObjectForKey:self.currentRunningTask.key];
        }
        
        dispatch_async(self.serialQueue, ^{
            strongify(self);
            [self runTasksWithAllTasksFinished:allTasksFinishedBlock];
        });
    };
    
    if (!self.currentRunningTask.block) {
        NSLog(@"[Error] The task `%@` 's block is nil.", self.currentRunningTask.key);
        completion();
        return;
    }
    
    self.currentRunningTask.startTime = CACurrentMediaTime();
    self.currentRunningTask.block(self.currentRunningTask.data, completion);
    
    if (self.currentRunningTask.timeoutInterval > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.currentRunningTask.timeoutInterval * NSEC_PER_SEC)), self.timeoutQueue, ^{
            dispatch_async(self.serialQueue, ^{
                strongify(self);
                if (self.currentRunningTask.isRunning) {
                    NSLog(@"[Warning] The task `%@` is timeout. Timeout block will be called", self.currentRunningTask.key);
                    
                    completion();
                    BOOL shouldContinue = YES;
                    
                    if (self.currentRunningTask.timeoutBlock) {
                        self.currentRunningTask.timeoutBlock(self.currentRunningTask.data, &shouldContinue);
                    }
                    
                    if (!shouldContinue) {
                        [self.taskList removeAllObjects];
                        allTasksFinishedBlock();
                    }
                }
            });
        });
    }
}

@end
