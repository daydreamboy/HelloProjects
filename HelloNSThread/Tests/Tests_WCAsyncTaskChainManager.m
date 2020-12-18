//
//  Tests_WCAsyncTaskChainManager.m
//  Tests
//
//  Created by wesley_chen on 2020/8/14.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCAsyncTaskChainManager.h"
#import "TaskHandlerChain1.h"
#import "TaskHandlerChain2.h"

/**
 Start of the asychronous task
 */
#define XCTestExpectation_BEGIN \
NSString *description__ = [NSString stringWithFormat:@"%s:%d", __FUNCTION__, __LINE__]; \
XCTestExpectation *expectation__ = [self expectationWithDescription:description__]; \

/**
 End of the asychronous task

 @param timeout the primitive integer of timeout
 */
#define XCTestExpectation_END(timeout) \
[self waitForExpectationsWithTimeout:(timeout) handler:nil];

/**
 Mark the asychronous task fulfilled/finished
 */
#define XCTestExpectation_FULFILL \
[expectation__ fulfill];

@interface Tests_WCAsyncTaskChainManager : XCTestCase

@end

@implementation Tests_WCAsyncTaskChainManager

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_startTaskHandlersWithData_completion_order {
    id data;
    NSArray *handlers;
    
    XCTestExpectation_BEGIN
    
    // Case 1
    data = [NSMutableArray array];
    handlers = @[
        NSStringFromClass([Chain1_TaskHandler1 class]),
        NSStringFromClass([Chain1_TaskHandler2 class]),
        NSStringFromClass([Chain1_TaskHandler3 class])
    ];
    WCAsyncTaskChainManager *manager = [[WCAsyncTaskChainManager alloc] initWithTaskHandlerClasses:handlers bizKey:@"default"];
    [manager startTaskHandlersWithData:data completion:^(WCAsyncTaskChainContext * _Nonnull context) {
        NSLog(@"data: %@", context.data);
        NSLog(@"error: %@", context.error);
        NSLog(@"abort: %@", context.shouldAbort ? @"YES" : @"NO");
        NSLog(@"timeout handlers: %@", context.handlersOfTimeout);
        
        XCTestExpectation_FULFILL
    }];
    
    XCTestExpectation_END(60)
}

- (void)test_startTaskHandlersWithData_completion_timeout {
    id data;
    NSArray *handlers;
    
    XCTestExpectation_BEGIN
    
    // Case 1
    data = [NSMutableArray array];
    handlers = @[
        NSStringFromClass([Chain2_TaskHandler1 class]),
        NSStringFromClass([Chain2_TaskHandler2 class]),
        NSStringFromClass([Chain2_TaskHandler3 class])
    ];
    WCAsyncTaskChainManager *manager = [[WCAsyncTaskChainManager alloc] initWithTaskHandlerClasses:handlers bizKey:@"default"];
    [manager startTaskHandlersWithData:data completion:^(WCAsyncTaskChainContext * _Nonnull context) {
        NSLog(@"data: %@", context.data);
        NSLog(@"error: %@", context.error);
        NSLog(@"abort: %@", context.shouldAbort ? @"YES" : @"NO");
        NSLog(@"timeout handlers: %@", context.handlersOfTimeout);
        
        XCTestExpectation_FULFILL
    }];
    
    XCTestExpectation_END(60)
}

- (void)test_startTaskHandlersWithData_completion_multiple_call {
    id data;
    NSArray *handlers;
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    
    // Case 1
    data = [NSMutableArray array];
    handlers = @[
        NSStringFromClass([Chain1_TaskHandler1 class]),
        NSStringFromClass([Chain1_TaskHandler2 class]),
        NSStringFromClass([Chain1_TaskHandler3 class])
    ];
    WCAsyncTaskChainManager *manager = [[WCAsyncTaskChainManager alloc] initWithTaskHandlerClasses:handlers bizKey:@"default"];
    [manager startTaskHandlersWithData:data completion:^(WCAsyncTaskChainContext * _Nonnull context) {
        NSLog(@"data: %@", context.data);
        NSLog(@"error: %@", context.error);
        NSLog(@"abort: %@", context.shouldAbort ? @"YES" : @"NO");
        NSLog(@"timeout handlers: %@", context.handlersOfTimeout);
        
        dispatch_group_leave(group);
    }];
    
    data = [NSMutableArray array];
    [manager startTaskHandlersWithData:data completion:^(WCAsyncTaskChainContext * _Nonnull context) {
        NSLog(@"data: %@", context.data);
        NSLog(@"error: %@", context.error);
        NSLog(@"abort: %@", context.shouldAbort ? @"YES" : @"NO");
        NSLog(@"timeout handlers: %@", context.handlersOfTimeout);
        
        dispatch_group_leave(group);
    }];
    
    dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, 10));
}

@end
