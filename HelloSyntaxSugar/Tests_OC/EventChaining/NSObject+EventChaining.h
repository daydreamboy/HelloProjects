//
//  NSObject+EventChaining.h
//  Tests_OC
//
//  Created by wesley_chen on 2019/6/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

NS_ASSUME_NONNULL_BEGIN

#define EventChainingErrorNextHandlerNotFound ([NSError errorWithDomain:EventChainingError code:EventChainingErrorCodeNextHandlerNotFound userInfo:@{ NSLocalizedDescriptionKey: [NSString stringWithFormat:@"%@ not found nextHandler property", self] }])

typedef NS_ENUM(NSUInteger, EventChainingErrorCode) {
    EventChainingErrorCodeNextHandlerNotFound = -1,
    EventChainingErrorCodeMethodNotImplemented = -2,
    EventChainingErrorCodeEventChainingProtocolNotConfirmed = -3,
    EventChainingErrorCodeEventWrongParameter = -4,
};

FOUNDATION_EXPORT NSErrorDomain const EventChainingError;

@interface NSObject (EventChaining)
- (BOOL)handleEvent:(Event *)event feedbackBlock:(void (^)(BOOL handled, Event * _Nonnull event, NSError * _Nullable error))feedbackBlock;
@end

NS_ASSUME_NONNULL_END
