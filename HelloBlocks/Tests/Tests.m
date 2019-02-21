//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2019/1/24.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCBlockTool.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_isBlock_crash_1 {
    id object = [NSNull null];
    void (^block)(void) = object;
    [WCBlockTool isBlock:block]; // Crash for using Block_copy
}

- (void)test_isBlock {
    id object = [NSNull null];
    
    if ([WCBlockTool isBlock:object]) { // OK
        void (^block)(void) = object;
        if (block) {
            block();
        }
    }
}

@end
