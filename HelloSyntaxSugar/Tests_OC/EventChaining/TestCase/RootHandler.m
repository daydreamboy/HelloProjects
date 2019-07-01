//
//  RootHandler.m
//  Tests_OC
//
//  Created by wesley_chen on 2019/6/29.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "RootHandler.h"
#import "ParentHandler.h"

@implementation RootHandler

EventChainingSynthesize

- (BOOL)handleEvent:(Event *)event feedbackBlock:(void (^)(BOOL handled,Event *event, NSError *error))feedbackBlock {
    if (self.nextHandler) {
        return [self.nextHandler handleEvent:event feedbackBlock:feedbackBlock];
    }
    else {
        feedbackBlock(NO, event, EventChainingErrorNextHandlerNotFound);
        return NO;
    }
}

@end
