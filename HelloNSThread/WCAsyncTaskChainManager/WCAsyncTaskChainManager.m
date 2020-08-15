//
//  WCAsyncTaskChainManager.m
//  HelloNSThread
//
//  Created by wesley_chen on 2020/8/13.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCAsyncTaskChainManager.h"
#import "WCAsyncTaskExecutor.h"

@interface WCAsyncTaskChainContext ()
@property (nonatomic, strong, readwrite) id data;
@property (nonatomic, strong, readwrite, nullable) NSError *error;
@property (nonatomic, weak, readwrite, nullable) id<WCAsyncTaskHandler> previousHandler;
@property (nonatomic, weak, readwrite, nullable) id<WCAsyncTaskHandler> nextHandler;
@property (nonatomic, assign) BOOL aborted;
@end

@implementation WCAsyncTaskChainContext

@end

NSString *WCAsyncTaskChainManagerErrorDomain = @"WCAsyncTaskChainManager";

@interface WCAsyncTaskChainManager () <WCAsyncTaskExecutorDelegate>
@property (nonatomic, copy) NSString *bizKey;
@property (nonatomic, strong) NSArray<NSString *> *handlerClasses;
@property (nonatomic, strong) NSMutableArray<id<WCAsyncTaskHandler>> *chainedTaskHandler;
@property (nonatomic, strong) WCAsyncTaskExecutor *taskExecutor;
@property (nonatomic, copy) void (^completionBlock)(void);
@end

@implementation WCAsyncTaskChainManager

- (instancetype)initWithTaskHandlerClasses:(NSArray<NSString *> *)classes bizKey:(NSString *)bizKey {
    self = [super init];
    if (self) {
        _handlerClasses = classes;
        _bizKey = bizKey;
        _taskExecutor = [[WCAsyncTaskExecutor alloc] init];
        _taskExecutor.delegate = self;
        
        _chainedTaskHandler = [NSMutableArray array];
        for (NSString *clzString in classes) {
            Class clz = NSClassFromString(clzString);
            if ([clz conformsToProtocol:@protocol(WCAsyncTaskHandler)]) {
                [_chainedTaskHandler addObject:[[clz alloc] initWithBizKey:bizKey]];
            }
        }
    }
    return self;
}

- (BOOL)startTaskHandlersWithData:(id)data completion:(void (^)(WCAsyncTaskChainContext *context))completion {
    if (!data || !completion) {
        return nil;
    }
    
    WCAsyncTaskChainContext *context = [WCAsyncTaskChainContext new];
    context.data = data;
    void (^allHandlersCompletion)(void) = ^{
        completion(context);
    };
    
    id<WCAsyncTaskHandler> previousHandler;
    id<WCAsyncTaskHandler> nextHandler;
    
    NSUInteger numberOfHandlers = self.chainedTaskHandler.count;
    for (NSInteger i = 0; i < numberOfHandlers; ++i) {
        previousHandler = i - 1 >= 0 ? self.chainedTaskHandler[i - 1] : nil;
        nextHandler = i + 1 < numberOfHandlers ? self.chainedTaskHandler[i + 1] : nil;
        
        id<WCAsyncTaskHandler> handler = self.chainedTaskHandler[i];
        
        NSTimeInterval timeoutInterval = -1;
        if ([handler respondsToSelector:@selector(timeoutInterval)]) {
            timeoutInterval = [handler timeoutInterval];
        }
        
        [self.taskExecutor addAsyncTask:^(WCAsyncTaskCompletion  _Nonnull completion) {
            if (context.aborted) {
                return;
            }
            
            if (context.error) {
                allHandlersCompletion();
            }
            else {
                if (!context.cancelled) {
                    context.previousHandler = previousHandler;
                    context.nextHandler = nextHandler;
                    [handler handleWithContext:context taskHandlerCompletion:^(id  _Nonnull data, NSError * _Nullable error) {
                        context.data = data;
                        context.error = error;
                        
                        completion();
                        
                        if (i == numberOfHandlers - 1) {
                            allHandlersCompletion();
                        }
                    }];
                }
                else {
                    allHandlersCompletion();
                }
            }
        } forKey:handler.name timeout:timeoutInterval timeoutBlock:^{
            context.error = [NSError errorWithDomain:WCAsyncTaskChainManagerErrorDomain code:WCAsyncTaskChainManagerErrorHandlerTimeout userInfo:@{ NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:@"handler %@ is timeout", handler.name] }];
            context.aborted = YES;
            allHandlersCompletion();
        }];
    }
    
    return YES;
}

#pragma mark - WCAsyncTaskExecutorDelegate

- (void)batchTasksAllFinishedWithAsyncTaskExecutor:(WCAsyncTaskExecutor *)exectuor {
}

@end
