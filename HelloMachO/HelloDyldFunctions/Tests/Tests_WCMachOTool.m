//
//  Tests_WCMachOTool.m
//  Tests
//
//  Created by wesley_chen on 2020/5/15.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCMachOTool.h"

#define ITERATIONS 10000

@interface Tests_WCMachOTool : XCTestCase

@end

@implementation Tests_WCMachOTool

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_appExecutableUUID {
    dispatch_group_t group = dispatch_group_create();
    
    CFTimeInterval startTime = CACurrentMediaTime();
    for (int i = 0; i < ITERATIONS; i++) {
        dispatch_group_async(group, dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
            __unused NSString *uuid = [WCMachOTool appExecutableUUID];
        });
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    CFTimeInterval endTime = CACurrentMediaTime();
    
    NSLog(@"Total time for inserting %@ times: averaged %g ns", @(ITERATIONS), (((endTime - startTime) * 1000000000)) / ITERATIONS);
}

@end
