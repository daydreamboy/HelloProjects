//
//  SetMultipleContextDataToQueueViewController.m
//  HelloGCD
//
//  Created by wesley_chen on 12/12/2017.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import "SetMultipleContextDataToQueueViewController.h"

@interface SetMultipleContextDataToQueueViewController ()

@end

@implementation SetMultipleContextDataToQueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test_using_dispatch_get_specific_with_main_queue];
//    [self test_using_dispatch_get_specific_with_global_default_queue];
//    [self test_using_dispatch_get_specific_with_private_queue];
}

static void *mainQueueKey = @"mainQueueKey";
static void *defaultQueueKey = @"defaultQueueKey";
static void *privateQueueKey1 = @"privateQueueKey1";
static void *privateQueueKey2 = @"privateQueueKey2";
static void *privateQueueKey2_2 = @"privateQueueKey2_2";

/// @see https://stackoverflow.com/a/38100934
- (void)test_using_dispatch_get_specific {
    [self test_using_dispatch_get_specific_with_main_queue];
    [self test_using_dispatch_get_specific_with_global_default_queue];
    [self test_using_dispatch_get_specific_with_private_queue];
}

- (void)test_using_dispatch_get_specific_with_private_queue {
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

- (void)test_using_dispatch_get_specific_with_global_default_queue {
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

- (void)test_using_dispatch_get_specific_with_main_queue {
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
        }
        else {
            NSLog(@"contextData4 is NULL");
        }
    });
}

@end
