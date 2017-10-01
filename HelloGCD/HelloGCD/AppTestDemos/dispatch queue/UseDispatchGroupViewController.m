//
//  UseDispatchGroupViewController.m
//  HelloGCD
//
//  Created by wesley chen on 16/12/6.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "UseDispatchGroupViewController.h"

@interface UseDispatchGroupViewController ()

@end

@implementation UseDispatchGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // TODO: Toggle the following lines to test
    
    //[self test_dispatch_group_wait];
    //[self test_dispatch_group_notify];
    //[self test_dispatch_group_enter_and_leave];
    //[self test_dispatch_group_empty_using_wait];
    //[self test_dispatch_group_empty_using_notify];
    [self test_dispatch_group_issue];
}

- (void)test_dispatch_group_wait {
    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t queue2 = dispatch_queue_create("com.example.queue1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue3 = dispatch_queue_create("com.example.queue2", NULL);
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue1, ^{
        NSLog(@"do task 1");
    });
    
    dispatch_group_async(group, queue2, ^{
        
        [self doLongTimeTask];
        NSLog(@"do task 2");
    });
    
    dispatch_group_async(group, queue3, ^{
        NSLog(@"do task 3");
    });
    
    NSLog(@"start to wait");
    long success = dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC)); // here will block current thread
    if (success == 0) {
        // wait successfully
        NSLog(@"all tasks in group are finished");
    }
    else {
        NSLog(@"wait timeout");
    }
}

- (void)test_dispatch_group_notify {
    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t queue2 = dispatch_queue_create("com.example.queue1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue3 = dispatch_queue_create("com.example.queue2", NULL);
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue1, ^{
        NSLog(@"do task 1");
    });
    
    dispatch_group_async(group, queue2, ^{
        
        [self doLongTimeTask];
        NSLog(@"do task 2");
    });
    
    dispatch_group_async(group, queue3, ^{
        NSLog(@"do task 3");
    });
    
    NSLog(@"start to notify");
    dispatch_queue_t queue4 = dispatch_queue_create("com.example.queue4", DISPATCH_QUEUE_SERIAL);
    dispatch_group_notify(group, queue4, ^{
        NSLog(@"all tasks in group are finished");
    });
}

- (void)test_dispatch_group_enter_and_leave {
    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t queue2 = dispatch_queue_create("com.example.queue1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue3 = dispatch_queue_create("com.example.queue2", NULL);
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue2, ^{
        NSLog(@"do task 1");
    });
    
    a_minic_of_dispatch_group_async(group, queue1, ^{
        [self doLongTimeTask];
        NSLog(@"do task 2");
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue3, ^{
        NSLog(@"do task 3");
        [self doLongTimeTask];
        [self doLongTimeTask];
       
        dispatch_group_leave(group);
        
        NSLog(@"do task 3 completed");
    });
    
    NSLog(@"start to notify");
    dispatch_queue_t queue4 = dispatch_queue_create("com.example.queue4", DISPATCH_QUEUE_SERIAL);
    dispatch_group_notify(group, queue4, ^{
        NSLog(@"all tasks in group are finished");
    });
}

- (void)test_dispatch_group_empty_using_wait {
    dispatch_group_t group = dispatch_group_create();
    
    NSLog(@"start to wait");
    long success = dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    if (success == 0) {
        // wait successfully
        NSLog(@"all tasks in group are finished");
    }
    else {
        NSLog(@"wait timeout");
    }
}

- (void)test_dispatch_group_empty_using_notify {
    dispatch_group_t group = dispatch_group_create();
    
    NSLog(@"start to notify");
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"all tasks in group are finished");
    });
}

- (void)test_dispatch_group_issue {
    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t queue3 = dispatch_queue_create("com.example.serail.queue", NULL);
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue1, ^{
        NSLog(@"do task 1");
    });
    
    dispatch_group_async(group, queue3, ^{
        NSLog(@"do task 3");
    });
    
    
    dispatch_queue_t concurrentQueue1 = dispatch_queue_create("com.example.queue1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t concurrentQueue2 = dispatch_queue_create("com.example.queue2", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(concurrentQueue1, ^{
        [self doLongTimeTask];
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        NSLog(@"end of wait1");
    });
    
    dispatch_async(concurrentQueue2, ^{
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        NSLog(@"end of wait2");
    });
}

#pragma mark - 

void
a_minic_of_dispatch_group_async(dispatch_group_t group, dispatch_queue_t queue, dispatch_block_t block) {
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        block();
        dispatch_group_leave(group);
    });
}

- (void)doLongTimeTask {
    long i = 0;
    do {
        i++;
    } while (i < 1000000000L);
}

@end
