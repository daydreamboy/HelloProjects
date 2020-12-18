//
//  TaskHandler1.m
//  Tests
//
//  Created by wesley_chen on 2020/8/14.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "TaskHandlerChain1.h"

@implementation TaskHandler1

- (instancetype)initWithBizKey:(NSString *)bizKey {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)name {
    return @"taskHandlder1";
}

- (void)handleWithContext:(WCAsyncTaskChainContext *)context taskHandlerCompletion:(TaskHandlerCompletion)taskHandlerCompletion {
    if ([context.data isKindOfClass:[NSArray class]]) {
        NSMutableArray *newData = [NSMutableArray arrayWithArray:context.data];
        [newData addObject:@{
            @"taskHandler1": @"handled",
        }];
        
        taskHandlerCompletion(newData, nil);
    }
}

@end

@interface TaskHandler2 ()
@property (nonatomic, strong) dispatch_queue_t queue;
@end

@implementation TaskHandler2

- (instancetype)initWithBizKey:(NSString *)bizKey {
    self = [super init];
    if (self) {
        _queue = dispatch_queue_create("com.wc.TaskHandler2", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (NSString *)name {
    return @"taskHandlder2";
}

- (void)handleWithContext:(WCAsyncTaskChainContext *)context taskHandlerCompletion:(TaskHandlerCompletion)taskHandlerCompletion {
    if ([context.data isKindOfClass:[NSArray class]]) {
        NSMutableArray *newData = [NSMutableArray arrayWithArray:context.data];
        [newData addObject:@{
            @"taskHandler2": @"handled",
        }];
        
        // Note: Toggle dispatch_after to make timeout
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), self.queue, ^{
            taskHandlerCompletion(newData, nil);
        });
    }
}

- (NSTimeInterval)timeoutInterval {
    return 2;
}

- (void)handleTimeoutWithContext:(WCAsyncTaskChainContext *)context {
    context.shouldAbort = NO;
}

@end

@implementation TaskHandler3

- (instancetype)initWithBizKey:(NSString *)bizKey {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)name {
    return @"taskHandlder3";
}

- (void)handleWithContext:(WCAsyncTaskChainContext *)context taskHandlerCompletion:(TaskHandlerCompletion)taskHandlerCompletion {
    if ([context.data isKindOfClass:[NSArray class]]) {
        NSMutableArray *newData = [NSMutableArray arrayWithArray:context.data];
        [newData addObject:@{
            @"taskHandler3": @"handled",
        }];
        
        taskHandlerCompletion(newData, nil);
    }
}

@end
