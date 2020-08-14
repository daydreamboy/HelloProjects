//
//  WCAsyncTaskExecutor.m
//  HelloNSThread
//
//  Created by wesley_chen on 2020/6/24.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCAsyncTaskExecutor.h"
#import "WCMacroTool.h"

@interface WCAsyncTask : NSObject
@property (nonatomic, copy) WCAsyncTaskBlock block;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) BOOL isRunning;
+ (instancetype)taskWithBlock:(WCAsyncTaskBlock)block forKey:(NSString *)key;
@end

@implementation WCAsyncTask

+ (instancetype)taskWithBlock:(WCAsyncTaskBlock)block forKey:(NSString *)key {
    WCAsyncTask *holder = [WCAsyncTask new];
    holder.block = block;
    holder.key = key;
    
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

- (BOOL)addAsyncTask:(WCAsyncTaskBlock)block {
    return [self addAsyncTask:block forKey:[NSUUID UUID].UUIDString];
}

- (BOOL)addAsyncTask:(WCAsyncTaskBlock)block forKey:(NSString *)key {
    if (!block || ![key isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    weakify(self);
    dispatch_async(self.serialQueue, ^{
        strongify(self);
        
        if (self.enqueueMap[key]) {
            return;
        }
        
        WCAsyncTask *taskToRun = [WCAsyncTask taskWithBlock:block forKey:key];
        self.enqueueMap[key] = taskToRun;
        [self.taskList addObject:taskToRun];
        
        if (self.isRunningTask) {
            return;
        }
        
        self.isRunningTask = YES;
        [self runTasksWithAllTasksFinished:^{
            strongify(self);
            
            if ([self.delegate respondsToSelector:@selector(batchTasksAllFinishedWithAsyncTaskExecutor:)]) {
                [self.delegate batchTasksAllFinishedWithAsyncTaskExecutor:self];
            }
            
            self.isRunningTask = NO;
        }];
    });
    
    return YES;
}

- (void)runTasksWithAllTasksFinished:(void (^)(void))allTasksFinishedBlock {
    if (self.taskList.count == 0) {
        self.currentRunningTask = nil;
        allTasksFinishedBlock();
        return;
    }

    self.currentRunningTask = [self.taskList firstObject];
    self.currentRunningTask.isRunning = YES;
    [self.taskList removeObjectAtIndex:0];
    
    weakify(self);
    __block BOOL checkFlagIfCompletionCalled = NO;
    WCAsyncTaskCompletion completion = ^{
        strongifyWithReturn(self, return;);
        
        checkFlagIfCompletionCalled = YES;
        
        self.currentRunningTask.isRunning = NO;
        [self.enqueueMap removeObjectForKey:self.currentRunningTask.key];
        
        dispatch_async(self.serialQueue, ^{
            strongify(self);
            [self runTasksWithAllTasksFinished:allTasksFinishedBlock];
        });
    };
    
    if (self.currentRunningTask.block) {
        self.currentRunningTask.block(completion);
        
        if (!checkFlagIfCompletionCalled) {
            NSLog(@"[Warning] The task `%@` must call the WCAsyncTaskCompletion block. If not the task is not executed serially", self.currentRunningTask.key);
            // Use timeout check instead
            //completion();
        }
    }
    else {
        NSLog(@"[Error] The task `%@` 's block is nil.", self.currentRunningTask.key);
        completion();
    }
}

@end
