//
//  Tests_data_types.m
//  Test_OC
//
//  Created by wesley_chen on 2021/7/3.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_data_types : XCTestCase

@end

@implementation Tests_data_types

- (void)test_double {
    [self dummy_double_parameter:0];
    [self dummy_double_parameter2:0];
}

- (void)dummy_double_parameter:(NSTimeInterval)timeout {
    dispatch_time_t timeoutL2 = (DISPATCH_TIME_FOREVER);
    // Note: timeout is double, so ?: will promote the DISPATCH_TIME_FOREVER also ~0ull, as double
    dispatch_time_t timeoutL = (timeout > 0) ? timeout : (DISPATCH_TIME_FOREVER);
    
    XCTAssertTrue(timeoutL2 == DISPATCH_TIME_FOREVER);
    XCTAssertTrue(timeoutL == 0);
}

- (void)dummy_double_parameter2:(dispatch_time_t)timeout {
    dispatch_time_t timeoutL2 = (DISPATCH_TIME_FOREVER);
    dispatch_time_t timeoutL = (timeout > 0) ? timeout : (DISPATCH_TIME_FOREVER);
    
    XCTAssertTrue(timeoutL2 == DISPATCH_TIME_FOREVER);
    XCTAssertTrue(timeoutL == DISPATCH_TIME_FOREVER);
}

@end
