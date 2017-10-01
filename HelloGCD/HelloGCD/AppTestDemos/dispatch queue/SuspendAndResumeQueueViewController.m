//
//  SuspendAndResumeQueueViewController.m
//  HelloGCD
//
//  Created by wesley chen on 16/11/27.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "SuspendAndResumeQueueViewController.h"

@interface SuspendAndResumeQueueViewController ()
@end

@implementation SuspendAndResumeQueueViewController {
    dispatch_queue_t _instanceQueue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // TODO: Toggle the following lines to test
    
    [self test_suspend_global_queue];
    //[self test_suspend_a_serial_queue];
    //[self test_suspend_a_concurrent_queue];
    //[self test_suspend_and_resuem_a_concurrent_queue];
    //[self test_suspend_and_resuem_is_not_paired];
    //[self test_suspend_and_resuem_is_not_paired_for_instanceQueue];
    
    //[self test_submit_task_asynchronously_and_synchronously];
}

#pragma mark - Test Methods

- (void)test_suspend_global_queue {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_sync(queue, ^{
        NSLog(@"do sync task1");
    });
    dispatch_async(queue, ^{
        NSLog(@"do async task1");
    });
    
    dispatch_suspend(queue); // try to suspend a global queue, but it fails
    
    dispatch_sync(queue, ^{
        NSLog(@"do sync task2");
    });
    dispatch_async(queue, ^{
        NSLog(@"do async task2");
    });
}

- (void)test_suspend_a_serial_queue {
    dispatch_queue_t queue = dispatch_queue_create("com.example.serialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        NSLog(@"do sync task1");
    });
    dispatch_async(queue, ^{
        NSLog(@"do async task1");
    });
    
    dispatch_suspend(queue);
    
    dispatch_sync(queue, ^{
        NSLog(@"do sync task2");
    });
    dispatch_async(queue, ^{
        NSLog(@"do async task2");
    });
}

- (void)test_suspend_a_concurrent_queue {
    dispatch_queue_t queue = dispatch_queue_create("com.example.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        NSLog(@"do sync task1");
    });
    dispatch_async(queue, ^{
        NSLog(@"do async task1");
    });
    
    dispatch_suspend(queue);
    
    dispatch_sync(queue, ^{
        NSLog(@"do sync task2");
    });
    dispatch_async(queue, ^{
        NSLog(@"do async task2");
    });
    NSLog(@"end");
}

- (void)test_suspend_and_resuem_a_concurrent_queue {
    dispatch_queue_t queue = dispatch_queue_create("com.example.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        NSLog(@"do sync task1");
    });
    dispatch_async(queue, ^{
        NSLog(@"do async task1");
        [self doLongTimeTask];
    });
    
    dispatch_suspend(queue);
    
    dispatch_async(queue, ^{
        NSLog(@"do async task2");
    });
    
    NSLog(@"end");
    dispatch_resume(queue);
}

- (void)test_suspend_and_resuem_is_not_paired {
    dispatch_queue_t queue = dispatch_queue_create("com.example.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"do async task1");
    });
    
    dispatch_suspend(queue);
    
    dispatch_async(queue, ^{
        NSLog(@"do async task2");
    });
    
    NSLog(@"end");
}

- (void)test_suspend_and_resuem_is_not_paired_for_instanceQueue {
    _instanceQueue = dispatch_queue_create("com.example.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(_instanceQueue, ^{
        NSLog(@"do async task1");
    });
    
    dispatch_suspend(_instanceQueue);
    
    dispatch_async(_instanceQueue, ^{
        NSLog(@"do async task2");
    });
    
    NSLog(@"end");
}

#pragma mark

- (void)test_submit_task_asynchronously_and_synchronously {
    dispatch_queue_t queue = dispatch_queue_create("com.wc.test", DISPATCH_QUEUE_CONCURRENT);//dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^{
        NSLog(@"do sync task1");
    });
    dispatch_async(queue, ^{
        NSLog(@"do async task1");
    });
    
    //[self doLongTimeTask];
    
    dispatch_sync(queue, ^{
        NSLog(@"do sync task2");
    });
    dispatch_async(queue, ^{
        NSLog(@"do async task2");
    });
}

- (void)doLongTimeTask {
    long i = 0;
    do {
        i++;
    } while (i < 1000000000L);
}

@end
