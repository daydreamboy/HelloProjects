//
//  Tests_CategoryConflict.m
//  Tests_OC
//
//  Created by wesley_chen on 2019/6/29.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RootHandler.h"
#import "ParentHandler.h"
#import "ChildHandler.h"

@interface Tests_CategoryConflict : XCTestCase

@end

@implementation Tests_CategoryConflict

- (void)test_chaining_normal {
    RootHandler *rootHandler = [RootHandler new];
    ParentHandler *parentHandler = [ParentHandler new];
    ChildHandler *childHandler = [ChildHandler new];
    
    // Note: Setup the chain
    childHandler.nextHandler = parentHandler;
    parentHandler.nextHandler = rootHandler;
    
    Event *event = [[Event alloc] initWithName:@"event.root.xxx" userInfo:nil];
    [childHandler handleEvent:event feedbackBlock:^(BOOL handled, Event * _Nonnull event, NSError * _Nullable error) {
        NSLog(@"result");
    }];
}

- (void)test_1 {
//    ParentHandler *parentNode1 = [ParentHandler new];
//    [parentNode1.childNode1 handleEvent:[Event new] feedbackBlock:^(BOOL handled, Event * _Nonnull event, NSError * _Nullable error) {
//        NSLog(@"result");
//    }];
}


@end
