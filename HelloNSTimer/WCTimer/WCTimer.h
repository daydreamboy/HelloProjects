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
    WCTimerStateUninitialized,
    WCTimerStateReady,
    WCTimerStateRunning,
    WCTimerStatePaused,
};

/**
 A timer with its current state (ready, running, paused)
 */
@interface WCTimer : NSObject

@property (nonatomic, readonly) NSTimeInterval interval;
@property (nonatomic, readonly) BOOL repeats;
@property (nonatomic, strong, readonly) dispatch_queue_t queue;
/**
 The tolerance in seconds. Default is 0.
 */
@property (nonatomic, assign) NSTimeInterval tolerance;
@property (nonatomic, assign, readonly) WCTimerState state;
@property (nonatomic, copy) void (^timerCancelledBlock)(WCTimer *timer);

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

/**
 Start the timer
 
 @return YES if the timer can start. NO if fails to start
 
 @note This metod change the state to WCTimerStateRunning
 */
- (BOOL)start;

/**
 Pause the timer
 
 @return YES if the timer can pause. NO if fails to pause
 
 @note This metod change the state to WCTimerStatePaused
 */
- (BOOL)pause;

/**
 Resume the timer
 
 @return YES if the timer can resume. NO if fails to resume
 
 @note This metod change the state to WCTimerStateRunning
 */
- (BOOL)resume;

/**
 Stop the timer
 
 @return YES if the timer can stop. NO if fails to stop
 
 @note This metod change the state to WCTimerStateReady
 */
- (BOOL)stop;

@end

NS_ASSUME_NONNULL_END
