//
//  DispatchSemaphoreIssueViewController.m
//  HelloGCD
//
//  Created by wesley_chen on 2020/10/29.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import "DispatchSemaphoreIssueViewController.h"

@interface DispatchSemaphoreIssueViewController ()

@end

@implementation DispatchSemaphoreIssueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//
//    [self testWithBlock:^{
//        dispatch_semaphore_signal(sema);
//    }];
//
//    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)));
//    NSLog(@"finished");
    
    [self test2];
}

- (void)testWithBlock:(void (^)(void))block {
    NSUInteger count = 100000;
    for (int i = 0; i < count; ++i) {
        NSLog(@"%d", i);
    }
    
    block();
}

- (void)test2 {
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(5);
        intptr_t count = dispatch_semaphore_signal(sema);
        //count = dispatch_semaphore_signal(sema);
        NSLog(@"count: %ld", count);
    });
    
    intptr_t timeout = dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)));
    NSLog(@"timeout: %@", timeout != 0 ? @"YES" : @"NO");
}

@end
