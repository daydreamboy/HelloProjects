//
//  WCTimer.h
//  HelloNSTimer
//
//  Created by wesley_chen on 2019/5/12.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WCTimerState) {
    WCTimerStateUnknown,
    WCTimerStateReady,
    WCTimerStateRunning,
    WCTimerStatePaused,
};

@interface WCTimer : NSObject

@property (nonatomic, readonly) NSTimeInterval interval;
@property (nonatomic, readonly) BOOL repeats;
@property (nonatomic, strong, readonly) dispatch_queue_t queue;
/**
 The tolerance in seconds. Default is 0.
 */
@property (nonatomic, assign) NSTimeInterval tolerance;
@property (nonatomic, assign, readonly) WCTimerState state;

/**
 Create a timer with ready state

 @param interval the interval in seconds
 @param repeats YES if repeated, NO if not repeated
 @param queue the queue to call the block. If nil. use the main thread
 @param block the callback when timer is fired
 @return the timer object
 @discussion
 1. This method not start the timer automatically, use -[WCTimer start] to start it.
 2. The timer should be retained to keep the timer running. When it is deallocted, the timer stops automatically
 */
+ (instancetype)timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats queue:(nullable dispatch_queue_t)queue block:(void (^)(WCTimer *timer))block;

- (BOOL)start;
- (BOOL)pause;
- (BOOL)resume;
- (BOOL)stop;

@end

NS_ASSUME_NONNULL_END
