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
@property (nonatomic, readwrite, nullable) id<WCAsyncTaskHandler> previousHandler;
@property (nonatomic, readwrite, nullable) id<WCAsyncTaskHandler> nextHandler;
@property (nonatomic, strong, readwrite) NSMutableArray *handlersOfTimeout;
@end

@implementation WCAsyncTaskChainContext
+ (instancetype)contextWithData:(id)data {
    WCAsyncTaskChainContext *context = [[WCAsyncTaskChainContext alloc] init];
    context.data = data;
    context.handlersOfTimeout = [NSMutableArray array];
    
    return context;
}
@end

NSString *WCAsyncTaskChainManagerErrorDomain = @"WCAsyncTaskChainManager";

@interface WCAsyncTaskChainManager ()
@property (nonatomic, copy) NSString *bizKey;
@property (nonatomic, strong) NSArray<NSString *> *handlerClasses;
@property (nonatomic, strong) NSMutableArray<id<WCAsyncTaskHandler>> *chainedTaskHandler;
@property (nonatomic, copy) void (^completionBlock)(void);
@property (nonatomic, strong) NSMutableDictionary<NSString *, WCAsyncTaskExecutor *> *keeper;
@property (nonatomic, strong) dispatch_queue_t enqueue;
@end

@implementation WCAsyncTaskChainManager

- (instancetype)initWithTaskHandlerClasses:(NSArray<NSString *> *)classes bizKey:(NSString *)bizKey {
    self = [super init];
    if (self) {
        _handlerClasses = classes;
        _bizKey = bizKey;
        _keeper = [NSMutableDictionary dictionary];
        _enqueue = dispatch_queue_create("com.wc.WCAsyncTaskChainManager", DISPATCH_QUEUE_SERIAL);
        
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
        return NO;
    }
    
    dispatch_async(self.enqueue, ^{
        NSString *taskId = [NSUUID UUID].UUIDString;
        WCAsyncTaskChainContext *context = [WCAsyncTaskChainContext contextWithData:data];
        
        WCAsyncTaskExecutor *taskExecutor = [[WCAsyncTaskExecutor alloc] init];
        taskExecutor.allTaskFinishedCompletion = ^(WCAsyncTaskExecutor * _Nonnull executor) {
            completion(context);
            self.keeper[taskId] = nil;
        };
        self.keeper[taskId] = taskExecutor;
        
        NSUInteger numberOfHandlers = self.chainedTaskHandler.count;
        
        for (NSInteger i = 0; i < numberOfHandlers; ++i) {
            id<WCAsyncTaskHandler> data = self.chainedTaskHandler[i];
            NSTimeInterval timeoutInterval = [data respondsToSelector:@selector(timeoutInterval)] ? [data timeoutInterval] : 0;
            
            [taskExecutor addAsyncTask:^(id _Nullable data, WCAsyncTaskCompletion  _Nonnull completion) {
                if (context.shouldAbort) {
                    return;
                }
                
                id<WCAsyncTaskHandler> currentHandler = data;
                
                context.previousHandler = ({
                    id<WCAsyncTaskHandler> handler = nil;
                    NSUInteger index = [self.chainedTaskHandler indexOfObject:currentHandler];
                    if (index != NSNotFound && index >= 1) {
                        handler = self.chainedTaskHandler[index - 1];
                    }
                    handler;
                });
                
                context.nextHandler = ({
                    id<WCAsyncTaskHandler> handler = nil;
                    NSUInteger index = [self.chainedTaskHandler indexOfObject:currentHandler];
                    if (index != NSNotFound && i + 1 < numberOfHandlers) {
                        handler = self.chainedTaskHandler[index + 1];
                    }
                    handler;
                });

                [currentHandler handleWithContext:context taskHandlerCompletion:^(id  _Nonnull data, NSError * _Nullable error) {
                    context.data = data;
                    context.error = error;
                    
                    completion();
                }];
            } data:data forKey:data.name timeout:timeoutInterval timeoutBlock:^(id _Nullable data, BOOL * _Nonnull shouldContinue) {
                id<WCAsyncTaskHandler> currentHandler = data;
                
                if ([currentHandler respondsToSelector:@selector(handleTimeoutWithContext:)]) {
                    [currentHandler handleTimeoutWithContext:context];
                    *shouldContinue = context.shouldAbort ? NO : YES;
                }
                else {
                    context.shouldAbort = YES;
                    *shouldContinue = NO;
                }
                
                if (currentHandler) {
                    [context.handlersOfTimeout addObject:currentHandler];
                }
            }];
        }
    });

    return YES;
}

@end
