//
//  EventChaining.h
//  Tests_OC
//
//  Created by wesley_chen on 2019/6/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import "NSObject+EventChaining.h"

#define EventChainingSynthesize \
@synthesize nextHandler = _nextHandler;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT

@protocol EventChaining <NSObject>

/**
 The next handler for the current handler.
 @note The parent handler which owns sevaral children handlers should assign
    itself as next handler for the children handlers
 @discussion If the current handler is root handler, its next handler is nil.
 */
@property (nonatomic, weak, nullable) id<EventChaining> nextHandler;

@optional

/**
 The method for event handler

 @param event the original event object
 @param feedbackBlock the feedback callback when the event handled
 @return Return YES when the event passed to the next handler successfully.
    Return NO when the event fails passed to the next handler
 @discussion This method is optional. If the current handler knows the event
    and can do it, the handler should implement this method
 */
- (BOOL)handleEvent:(Event *)event feedbackBlock:(void (^)(BOOL handled, Event *event, NSError * _Nullable error))feedbackBlock;

@end

NS_ASSUME_NONNULL_END
