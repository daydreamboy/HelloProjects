//
//  DispatchGetCurrentQueueCrashIssueViewController.m
//  HelloDeploymentTargetBelowiOS6
//
//  Created by wesley_chen on 13/12/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "DispatchGetCurrentQueueCrashIssueViewController.h"

@interface DispatchGetCurrentQueueCrashIssueViewController ()

@end

@implementation DispatchGetCurrentQueueCrashIssueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self test_dispatch_get_current_queue_with_global_queue];
//    [self test_dispatch_get_current_queue_with_private_serial_queue];
    [self test_dispatch_get_current_queue_with_private_concurrent_queue];
}

- (void)test_dispatch_get_current_queue_with_global_queue {
    // Note: Ok, dispatch_get_current_queue can access gloabl queues on both iOS 5.x and iOS 6+
    NSLog(@"main queue: %@", dispatch_get_current_queue());
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"default queue: %@", dispatch_get_current_queue());
    });
}

- (void)test_dispatch_get_current_queue_with_private_serial_queue {
    
    dispatch_queue_t queue = dispatch_queue_create("com.wc.example1", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        // Crash: EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0) on dispatch_get_current_queue
        NSLog(@"private serial queue: %@", dispatch_get_current_queue());
    });
}

- (void)test_dispatch_get_current_queue_with_private_concurrent_queue {
    
    dispatch_queue_t queue = dispatch_queue_create("com.wc.example2", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        // Crash: EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0) on dispatch_get_current_queue
        NSLog(@"private concurrent queue: %@", dispatch_get_current_queue());
    });
}

@end
