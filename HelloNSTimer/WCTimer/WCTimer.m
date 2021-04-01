//
//  WCTimer.m
//  HelloNSTimer
//
//  Created by wesley_chen on 2019/5/12.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCTimer.h"

#define DEBUG_LOG 0

@interface WCTimer ()
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, readwrite) NSTimeInterval interval;
@property (nonatomic, readwrite) BOOL repeats;
@property (nonatomic, readwrite, copy) void (^timerFiredBlock)(WCTimer *timer);
@property (nonatomic, strong, readwrite) dispatch_queue_t queue;
@property (nonatomic, assign, readwrite) WCTimerState state;
@end

@implementation WCTimer

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats queue:(nullable dispatch_queue_t)queue block:(void (^)(WCTimer *timer))block {
    WCTimer *timer = [[WCTimer alloc] init];
    timer.interval = interval;
    timer.repeats = repeats;
    timer.queue = queue;
    timer.timerFiredBlock = block;
    timer.state = WCTimerStateReady;
    return timer;
}

- (void)dealloc {
    [self stop];
#if DEBUG_LOG
    NSLog(@"%@ is deallocating", self);
#endif
}

- (BOOL)start {
    dispatch_queue_t runningQueue = self.queue ?: dispatch_get_main_queue();
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, runningQueue);
    if (!self.timer) {
        return NO;
    }
    
    NSTimeInterval tolerance = self.tolerance > 0 ? self.tolerance : 0;
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, self.interval * NSEC_PER_SEC, tolerance * NSEC_PER_SEC);
    
    __weak typeof(self) weak_self = self;
    dispatch_source_set_event_handler(self.timer, ^{
        @autoreleasepool {
            __strong typeof(weak_self) strong_self = weak_self;
            if (strong_self.timerFiredBlock) {
                strong_self.timerFiredBlock(strong_self);
            }
            
            if (strong_self.repeats == NO) {
                [strong_self stop];
            }
        }
    });
    dispatch_source_set_cancel_handler(self.timer, ^{
        __strong typeof(weak_self) strong_self = weak_self;
        if (strong_self.timerCancelledBlock) {
            strong_self.timerCancelledBlock(strong_self);
        }
    });
    
    if ([self resume]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)pause {
    if (self.timer && (self.state == WCTimerStateRunning)) {
        dispatch_suspend(self.timer);
        self.state = WCTimerStatePaused;
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)resume {
    if (self.timer && (self.state == WCTimerStateReady || self.state == WCTimerStatePaused)) {
        dispatch_resume(self.timer);
        self.state = WCTimerStateRunning;
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)stop {
    if (self.timer && (self.state == WCTimerStateReady || self.state == WCTimerStateRunning || self.state == WCTimerStatePaused)) {
        dispatch_source_cancel(self.timer);
        self.state = WCTimerStateReady;
        return YES;
    }
    else {
        return NO;
    }
}

@end
