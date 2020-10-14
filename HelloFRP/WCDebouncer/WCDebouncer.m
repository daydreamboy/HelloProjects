//
//  WCDebouncer.m
//  HelloFRP
//
//  Created by wesley_chen on 2020/10/6.
//

#import "WCDebouncer.h"

#define WCDEBUG 1

@interface WCDebouncer ()
@property (nonatomic, strong) dispatch_block_t dispatchWorkItem;
@property (nonatomic, strong) dispatch_queue_t workQueue;
@property (nonatomic, assign) NSTimeInterval delayInSeconds;
@end

@implementation WCDebouncer

- (instancetype)initWithDelay:(NSTimeInterval)delayInSeconds serialQueue:(nullable dispatch_queue_t)queue {
    self = [super init];
    if (self) {
        _delayInSeconds = delayInSeconds;
        _workQueue = queue ?: dispatch_queue_create("com.wc.WCDebouncer", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)debounceWithBlock:(dispatch_block_t)block {
    if (!block) {
        return;
    }
#if WCDEBUG
    static NSUInteger count = 0;
#endif
    
    __weak typeof(self) weak_self = self;
    dispatch_async(_workQueue, ^{
        __strong typeof(weak_self) self = weak_self;
        if (!self) {
            return;
        }
        
        if (self.dispatchWorkItem) {
            NSLog(@"cancel: %ld", (long)count);
            dispatch_block_cancel(self.dispatchWorkItem);;
        }
        
        count++;
        self.dispatchWorkItem = dispatch_block_create(0, ^{
            NSLog(@"execute: %ld", (long)count);
            !block ?: block();
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayInSeconds * NSEC_PER_SEC)), self.workQueue, self.dispatchWorkItem);
    });
}

@end
