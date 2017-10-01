//
//  UseDispatchSemaphoreViewController.m
//  HelloGCD
//
//  Created by wesley chen on 16/11/29.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "UseDispatchSemaphoreViewController.h"

@interface UseDispatchSemaphoreViewController ()
@end

@implementation UseDispatchSemaphoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // TODO: Toggle the following lines to test
    
    [self test_semaphore_for_finite_resource_pool];
    //[self test_semaphore_for_completion_synchronization];
    //[self test_semaphore_crash];
}

#pragma mark - Test Methods

- (void)test_semaphore_for_finite_resource_pool {
    dispatch_semaphore_t sema = dispatch_semaphore_create(1);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL isMain = [NSThread isMainThread];
        NSLog(@"isMain: %@", isMain ? @"YES" : @"NO");
        NSLog(@"sleeping 1s");
        sleep(1);
        
        long wait2IsWaken = dispatch_semaphore_signal(sema);
        if (wait2IsWaken) {
            NSLog(@"wait2 is allowed");
        }
        
        NSLog(@"sleeping 2s");
        sleep(2);
        long wait3IsWaken = dispatch_semaphore_signal(sema);
        if (wait3IsWaken) {
            NSLog(@"wait3 is allowed");
        }
        
        NSLog(@"sleeping 3s");
        sleep(3);
        long noWaitIsWaken = dispatch_semaphore_signal(sema);
        if (noWaitIsWaken) {
            NSLog(@"wait3 is allowed");
        }
        else {
            NSLog(@"no wait is waken");
        }
    });
    
    long isTimeout1 = dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    NSLog(@"wait1 is passing: %ld", isTimeout1);
    
    long isTimeout2 = dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    NSLog(@"wait2 is passing: %ld", isTimeout2);
    
    long isTimeout3 = dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    NSLog(@"wait3 is passing: %ld", isTimeout3);
}

- (void)test_semaphore_for_completion_synchronization {
    
    dispatch_queue_t queue = dispatch_queue_create("com.example.serialQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        void (^completionBlock)(void) = ^{
            NSLog(@"aync work is completed");
        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"do async work");
            sleep(3);
            
            NSLog(@"notify async work is done");
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER); // the queue is waiting
        completionBlock(); // called always after @"notify async work is done"
    });
}

- (void)test_semaphore_crash {
    dispatch_semaphore_t sema = dispatch_semaphore_create(1);
    
    dispatch_queue_t queue = dispatch_queue_create("com.example.queue", NULL);
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });
    
    NSLog(@"end of the method, and sema will be deallocated");
}

@end
