//
//  ChildHandler.m
//  Tests_OC
//
//  Created by wesley_chen on 2019/6/29.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "ChildHandler.h"

@implementation ChildHandler

EventChainingSynthesize

- (BOOL)handleEvent:(nonnull Event *)event feedbackBlock:(nonnull void (^)(BOOL, Event * _Nonnull, NSError * _Nullable))feedbackBlock {
    if (self.nextHandler) {
        return [self.nextHandler handleEvent:event feedbackBlock:feedbackBlock];
    }
    else {
        feedbackBlock(NO, event, EventChainingErrorNextHandlerNotFound);
        return NO;
    }
}

@end
