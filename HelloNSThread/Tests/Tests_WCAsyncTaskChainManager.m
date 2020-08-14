//
//  Tests_WCAsyncTaskChainManager.m
//  Tests
//
//  Created by wesley_chen on 2020/8/14.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCAsyncTaskChainManager.h"
#import "TaskHandler1.h"
#import "TaskHandler2.h"
#import "TaskHandler3.h"

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

- (void)test_startTaskHandlersWithData_completion {
    id data;
    NSArray *handlers;
    
    XCTestExpectation_BEGIN
    
    // Case 1
    data = [NSMutableDictionary dictionary];
    handlers = @[ NSStringFromClass([TaskHandler1 class]), NSStringFromClass([TaskHandler2 class]), NSStringFromClass([TaskHandler3 class]) ];
    WCAsyncTaskChainManager *manager = [[WCAsyncTaskChainManager alloc] initWithTaskHandlerClasses:handlers bizKey:@"default"];
    [manager startTaskHandlersWithData:data completion:^(WCAsyncTaskChainContext * _Nonnull context) {
        NSLog(@"data: %@", context.data);
        NSLog(@"error: %@", context.error);
        
        XCTestExpectation_FULFILL
    }];
    
    XCTestExpectation_END(60)
}

@end
