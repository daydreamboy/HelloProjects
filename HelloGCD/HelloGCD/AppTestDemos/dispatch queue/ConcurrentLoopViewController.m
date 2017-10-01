//
//  ConcurrentLoopViewController.m
//  HelloGCD
//
//  Created by wesley chen on 16/11/22.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "ConcurrentLoopViewController.h"

@interface ConcurrentLoopViewController ()

@end

@implementation ConcurrentLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // TODO: Toggle the following lines to test
    
    [self test_dispatch_apply_using_concurrent_queue];
    //[self test_dispatch_apply_using_serial_queue];
    
    //[self test_deadlock_of_dispatch_apply_using_main_dispatch_queue];
    //[self test_deadlock_of_dispatch_apply_using_serial_queue];
    //[self test_deadlock_of_dispatch_apply_using_concurrent_queue];
}

#pragma mark - Test Methods

- (void)test_dispatch_apply_using_concurrent_queue {
    NSLog(@"start concurrent iterating");
    size_t count = 10;
    dispatch_apply(count, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t i) {
        NSLog(@"This is %zu iteration", i);
    });
    NSLog(@"end concurrent iterating");
}

- (void)test_dispatch_apply_using_serial_queue {
    dispatch_queue_t serialQueue = dispatch_queue_create("com.wc.test.serialQueue", NULL);
    NSLog(@"start concurrent iterating");
    size_t count = 10;
    dispatch_apply(count, serialQueue, ^(size_t i) {
        NSLog(@"This is %zu iteration", i);
    });
    NSLog(@"end concurrent iterating");
}

#pragma mark > Dead Lock

- (void)test_deadlock_of_dispatch_apply_using_main_dispatch_queue {
    NSLog(@"start concurrent iterating");
    size_t count = 10;
    dispatch_apply(count, dispatch_get_main_queue(), ^(size_t i) { // Error: dead lock here!!!
        NSLog(@"This is %zu iteration", i);
    });
    NSLog(@"end concurrent iterating");
}

- (void)test_deadlock_of_dispatch_apply_using_serial_queue {
    dispatch_queue_t serialQueue = dispatch_queue_create("com.wc.test.serialQueue", NULL);
    
    dispatch_async(serialQueue, ^{
        NSLog(@"start concurrent iterating");
        size_t count = 10;
        dispatch_apply(count, serialQueue, ^(size_t i) { // Error: dead lock here!!!
            NSLog(@"This is %zu iteration", i);
        });
        NSLog(@"end concurrent iterating");
    });
}

- (void)test_deadlock_of_dispatch_apply_using_concurrent_queue {
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // Wow, it's OK! Use concurrentQueue to execute dispatch_apply() and dispatch_apply() also dispatch tasks to the concurrentQueue
    dispatch_async(concurrentQueue, ^{
        NSLog(@"start concurrent iterating");
        size_t count = 10;
        dispatch_apply(count, concurrentQueue, ^(size_t i) {
            NSLog(@"This is %zu iteration", i);
        });
        NSLog(@"end concurrent iterating");
    });
}


@end
