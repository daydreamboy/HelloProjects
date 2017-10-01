//
//  AddBarrierTaskToConcurrentQueueViewController.m
//  HelloGCD
//
//  Created by wesley chen on 16/12/17.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "AddBarrierTaskToConcurrentQueueViewController.h"

@interface AddBarrierTaskToConcurrentQueueViewController ()

@end

@implementation AddBarrierTaskToConcurrentQueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self test_submit_barrier_task];
}

- (void)test_submit_barrier_task {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.example.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(concurrentQueue, ^{
        [self doLongTimeTaskRandomly];
        NSLog(@"do task 1");
    });
    dispatch_async(concurrentQueue, ^{
        [self doLongTimeTaskRandomly];
        NSLog(@"do task 2");
    });
    dispatch_barrier_async(concurrentQueue, ^{
        NSLog(@"do a task without other task are executing");
    });
    dispatch_async(concurrentQueue, ^{
        [self doLongTimeTaskRandomly];
        NSLog(@"do task 3");
    });
    dispatch_async(concurrentQueue, ^{
        [self doLongTimeTaskRandomly];
        NSLog(@"do task 4");
    });
}

- (void)doLongTimeTaskRandomly {
    
    long maxCount = 1000000000L;
    long count = (long)(arc4random_uniform(100) / 100.0f * maxCount);
    
    long i = 0;
    do {
        i++;
    } while (i < count);
}

@end
