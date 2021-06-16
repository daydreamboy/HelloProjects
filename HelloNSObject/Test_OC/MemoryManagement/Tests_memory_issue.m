//
//  Tests_memory.m
//  Test_OC
//
//  Created by wesley_chen on 2021/6/16.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCXCTestCaseTool.h"

@interface Tests_memory : XCTestCase
@property (nonatomic, copy) NSString *string;
@end

@implementation Tests_memory

- (void)test_issue_none_tagged_pointer {
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);

    for (int i = 0; i < 1000; i++) {
        dispatch_group_enter(group);
        dispatch_async(queue, ^{
            // Crash: release in setter method will cauase EXC_BAD_ACCESS
            self.string = [NSString stringWithFormat:@"abcdefghijk"];
            dispatch_group_leave(group);
        });
    }
    
    NSLog(@"start to wait");
    long success = dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, 60 * NSEC_PER_SEC));
    if (success == 0) {
        NSLog(@"all tasks in group are finished");
    }
    else {
        NSLog(@"wait timeout");
    }
}

- (void)test_issue_tagged_pointer {
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);

    for (int i = 0; i < 1000; i++) {
        dispatch_group_enter(group);
        dispatch_async(queue, ^{
            // Note: Ok, use tagged pointer
            self.string = [NSString stringWithFormat:@"abc"];
            dispatch_group_leave(group);
        });
    }
    
    NSLog(@"start to wait");
    long success = dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, 60 * NSEC_PER_SEC));
    if (success == 0) {
        NSLog(@"all tasks in group are finished");
    }
    else {
        NSLog(@"wait timeout");
    }
}


@end
