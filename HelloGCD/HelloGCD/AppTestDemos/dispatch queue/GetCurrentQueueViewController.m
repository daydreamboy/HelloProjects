//
//  GetCurrentQueueViewController.m
//  HelloGCD
//
//  Created by wesley_chen on 12/12/2017.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import "GetCurrentQueueViewController.h"

@interface GetCurrentQueueViewController ()

@end

@implementation GetCurrentQueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self test_using_dispatch_get_current_queue];
    [self test_using_NSOperation_currentQueue_underlyingQueue];
//    [self test_using_DISPATCH_CURRENT_QUEUE_LABEL];
    
//    [self test_using_dispatch_get_specific_to_check_main_queue];
//    [self test_using_dispatch_get_specific_to_check_global_default_queue];
//    [self test_using_dispatch_get_specific_to_check_private_queue];
}

- (void)test_using_dispatch_get_current_queue {
    // Warning: dispatch_get_current_queue is deprecated, and maybe crash
    
    // Ok, get queue for gloabl queues
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"%@", dispatch_get_current_queue());
    });
    
    // Error, can't get private queue in its block
    dispatch_queue_t queue = dispatch_queue_create("com.wc.example", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        // Note: crash on iOS 6+, but safe on iOS 5 and lower
        NSLog(@"Will crash here: %@", dispatch_get_current_queue());
    });
}

/// @see https://stackoverflow.com/a/29708852
- (void)test_using_NSOperation_currentQueue_underlyingQueue {
    // Note: `underlyingQueue` on iOS 8+
    NSLog(@"1. %@", [NSOperationQueue currentQueue].underlyingQueue);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"2. %@", [NSOperationQueue currentQueue].underlyingQueue);
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"3. %@", [NSOperationQueue currentQueue].underlyingQueue);
    });
    
    dispatch_queue_t queue = dispatch_queue_create("com.wc.myQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"4. %@", [NSOperationQueue currentQueue].underlyingQueue);
    });
}

/// @see https://stackoverflow.com/a/38271884
- (void)test_using_DISPATCH_CURRENT_QUEUE_LABEL {
    // Note: `underlyingQueue` on iOS 8+
    
    // com.apple.main-thread
    NSLog(@"1. %s", dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL));
    NSLog(@"main queue: %@", dispatch_get_main_queue());
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // com.apple.root.default-qos
        NSLog(@"2. %s", dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL));
    });
    
    dispatch_queue_t queue1 = dispatch_queue_create("com.wc.myQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue1, ^{
        // com.wc.myQueue
        NSLog(@"3. %s", dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL));
        
        if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), "com.wc.myQueue") == 0) {
            NSLog(@"is current queue");
        }
        else {
            NSLog(@"is not current queue");
        }
    });
    
    dispatch_queue_t queue2 = dispatch_queue_create("com.wc.myQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue2, ^{
        // still com.wc.myQueue
        NSLog(@"4. %s", dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL));
        
        if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), "com.wc.myQueue") == 0) {
            NSLog(@"is current queue");
        }
        else {
            NSLog(@"is not current queue");
        }
    });
}

static void *mainQueueKey = @"mainQueueKey";
static void *defaultQueueKey = @"defaultQueueKey";
static void *privateQueueKey1 = @"privateQueueKey1";
static void *privateQueueKey2 = @"privateQueueKey2";
static void *privateQueueKey2_2 = @"privateQueueKey2_2";

/// @see https://stackoverflow.com/a/38100934
- (void)test_using_dispatch_get_specific {
    [self test_using_dispatch_get_specific_to_check_main_queue];
    [self test_using_dispatch_get_specific_to_check_global_default_queue];
    [self test_using_dispatch_get_specific_to_check_private_queue];
}

- (void)test_using_dispatch_get_specific_to_check_private_queue {
    dispatch_queue_t serial_queue = dispatch_queue_create("com.wc.myQueue1", DISPATCH_QUEUE_SERIAL);
    // Note: set context data for private serial queue
    dispatch_queue_set_specific(serial_queue, &privateQueueKey1, privateQueueKey1, NULL);
    
    dispatch_async(serial_queue, ^{
        void *contextData1 = dispatch_get_specific(&privateQueueKey1);
        if (contextData1 != NULL) {
            NSLog(@"contextData1: %@", contextData1);
        }
        else {
            NSLog(@"contextData1 is NULL");
        }
    });
    
    dispatch_queue_t concurrent_queue = dispatch_queue_create("com.wc.myQueue2", DISPATCH_QUEUE_CONCURRENT);
    // Note: set context data for private concurrent queue
    dispatch_queue_set_specific(concurrent_queue, &privateQueueKey2, privateQueueKey2, NULL);
    dispatch_queue_set_specific(concurrent_queue, &privateQueueKey2_2, privateQueueKey2_2, NULL);
    
    dispatch_async(concurrent_queue, ^{
        void *contextData2 = dispatch_get_specific(&privateQueueKey2);
        if (contextData2 != NULL) {
            NSLog(@"contextData2: %@", contextData2);
        }
        else {
            NSLog(@"contextData2 is NULL");
        }
        
        void *contextData3 = dispatch_queue_get_specific(concurrent_queue, &privateQueueKey2);
        if (contextData3 != NULL) {
            NSLog(@"contextData3: %@", contextData3);
        }
        else {
            NSLog(@"contextData3 is NULL");
        }
        
        void *contextData4 = dispatch_queue_get_specific(concurrent_queue, &privateQueueKey2_2);
        if (contextData4 != NULL) {
            NSLog(@"contextData4: %@", contextData4);
        }
        else {
            NSLog(@"contextData4 is NULL");
        }
    });
}

- (void)test_using_dispatch_get_specific_to_check_global_default_queue {
    void *contextData1 = dispatch_queue_get_specific(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), &defaultQueueKey);
    if (contextData1 != NULL) {
        NSLog(@"contextData1: %@", contextData1);
    }
    else {
        NSLog(@"contextData1 is NULL");
    }
    
    // set context data for global default queue
    dispatch_queue_set_specific(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), &defaultQueueKey, defaultQueueKey, NULL);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        void *contextData2 = dispatch_get_specific(&defaultQueueKey);
        if (contextData2 != NULL) {
            NSLog(@"contextData2: %@", contextData2);
        }
        else {
            NSLog(@"contextData2 is NULL");
        }
    });
}

- (void)test_using_dispatch_get_specific_to_check_main_queue {
    void *contextData1 = dispatch_get_specific(&mainQueueKey);
    if (contextData1 != NULL) {
        NSLog(@"contextData1: %@", contextData1);
    }
    else {
        NSLog(@"contextData1 is NULL");
    }
    
    void *contextData2 = dispatch_queue_get_specific(dispatch_get_main_queue(), &mainQueueKey);
    if (contextData2 != NULL) {
        NSLog(@"contextData2: %@", contextData2);
    }
    else {
        NSLog(@"contextData2 is NULL");
    }
    
    // set context data for main queue
    dispatch_queue_set_specific(dispatch_get_main_queue(), &mainQueueKey, mainQueueKey, NULL);
    
    void *contextData3 = dispatch_get_specific(&mainQueueKey);
    if (contextData3 != NULL) {
        NSLog(@"contextData3: %@", contextData3);
    }
    else {
        NSLog(@"contextData3 is NULL");
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        void *contextData4 = dispatch_get_specific(&mainQueueKey);
        if (contextData4 != NULL) {
            NSLog(@"contextData4: %@", contextData4);
            NSLog(@"is current queue");
        }
        else {
            NSLog(@"contextData4 is NULL");
            NSLog(@"is not current queue");
        }
    });
}

@end
