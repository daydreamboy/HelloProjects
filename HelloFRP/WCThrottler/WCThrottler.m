//
//  WCThrottler.m
//  HelloFRP
//
//  Created by wesley_chen on 2020/10/6.
//

#import "WCThrottler.h"

@interface WCThrottler ()
@property (nonatomic, strong) dispatch_block_t dispatchWorkItem;
@property (nonatomic, strong) NSDate *previousRunDate;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, assign) NSTimeInterval timeWindow;
@property (nonatomic, assign) BOOL handleLatestItem;
@end

@implementation WCThrottler

- (instancetype)initWithTimeWindow:(NSTimeInterval)timeWindow queue:(nullable dispatch_queue_t)queue {
    return [self initWithTimeWindow:timeWindow queue:queue handleLatestItem:YES];
}

- (instancetype)initWithTimeWindow:(NSTimeInterval)timeWindow queue:(nullable dispatch_queue_t)queue handleLatestItem:(BOOL)handleLatestItem {
    self = [super init];
    if (self) {
        _timeWindow = timeWindow;
        _queue = queue ?: dispatch_get_main_queue();
        _handleLatestItem = handleLatestItem;
    }
    return self;
}

- (void)throttleWithBlock:(dispatch_block_t)block {
    if (!block) {
        return;
    }
    
    if (self.handleLatestItem) {
        // TODO: https://www.craftappco.com/blog/2018/5/30/simple-throttling-in-swift
        dispatch_block_cancel(_dispatchWorkItem);
        
        __weak typeof(self) weak_self = self;
        _dispatchWorkItem = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
            __strong typeof(weak_self) self = weak_self;
            if (!self) {
                return;
            }
            self.previousRunDate = [NSDate date];
            !block ?: block();
        });
        
        
    }
    
    
    
}

@end
