//
//  NSObject+EventChaining.m
//  Tests_OC
//
//  Created by wesley_chen on 2019/6/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "NSObject+EventChaining.h"
#import "EventChaining.h"

NSErrorDomain const EventChainingError = @"EventChainingError";

@implementation NSObject (EventChaining)

- (BOOL)handleEvent:(Event *)event feedbackBlock:(void (^)(BOOL handled, Event * _Nonnull event, NSError * _Nullable error))feedbackBlock {
    if (![event isKindOfClass:[Event class]]) {
        !feedbackBlock ?: feedbackBlock(NO, event, [NSError errorWithDomain:EventChainingError code:EventChainingErrorCodeEventWrongParameter userInfo:@{ NSLocalizedDescriptionKey: [NSString stringWithFormat:@"wrong parameter: %@", event] }]);
        
        return NO;
    }
    
    if (![self conformsToProtocol:@protocol(EventChaining)]) {
        !feedbackBlock ?: feedbackBlock(NO, event, [NSError errorWithDomain:EventChainingError code:EventChainingErrorCodeEventChainingProtocolNotConfirmed userInfo:@{ NSLocalizedDescriptionKey: [NSString stringWithFormat:@"%@ not confirm `EventChaining` protocol", self] }]);
        
        return NO;
    }
    
    if (![self respondsToSelector:@selector(nextHandler)]) {
        !feedbackBlock ?: feedbackBlock(NO, event, [NSError errorWithDomain:EventChainingError code:EventChainingErrorCodeNextHandlerNotFound userInfo:@{ NSLocalizedDescriptionKey: [NSString stringWithFormat:@"%@ not found nextHandler property", self] }]);
        
        return NO;
    }
    
    id<EventChaining> nextHandler = [self performSelector:@selector(nextHandler)];
    if (![nextHandler respondsToSelector:@selector(handleEvent:feedbackBlock:)]) {
        !feedbackBlock ?: feedbackBlock(NO, event, [NSError errorWithDomain:EventChainingError code:EventChainingErrorCodeMethodNotImplemented userInfo:@{ NSLocalizedDescriptionKey: [NSString stringWithFormat:@"%@ not implements `EventChaining` protocol", self] }]);
        
        return NO;
    }
    
    [nextHandler handleEvent:event feedbackBlock:feedbackBlock];
    
    return YES;
}

@end
