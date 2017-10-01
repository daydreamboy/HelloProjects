//
//  AddCompletionBlockToQueueViewController.m
//  HelloGCD
//
//  Created by wesley chen on 16/11/21.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "AddCompletionBlockToQueueViewController.h"

@interface AddCompletionBlockToQueueViewController ()

@end

@implementation AddCompletionBlockToQueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self demonstrate_completion_block];
}

- (void)demonstrate_completion_block {
    int len = 3;
    int *dataPtr = malloc(len * sizeof(int));
    dataPtr[0] = 1;
    dataPtr[1] = 2;
    dataPtr[2] = 3;
    
    // TODO: Toggle the following lines to test
    
    //[self test_average_async1:dataPtr len:len];
    //[self test_average_async2:dataPtr len:len];
    [self test_average_async3:dataPtr len:len];
}

#pragma mark - Test Methods

- (void)test_average_async1:(int *)dataPtr len:(int)len {
    dispatch_queue_t queue = dispatch_queue_create("com.wc.test1", NULL);
    
    [self doSomeLongTimeTaskWithQueue:queue];
    [self doSomeLongTimeTaskWithQueue:nil];
    
    average_async1(dataPtr, len, queue, ^(float avg) {
        NSLog(@"1. notify work done");
        NSLog(@"avg1: %f", avg);
        
        free(dataPtr);
    });
    
    [self doSomeLongTimeTaskWithQueue:queue];
    [self doSomeLongTimeTaskWithQueue:nil];
}

- (void)test_average_async2:(int *)dataPtr len:(int)len {
    dispatch_queue_t queue = dispatch_queue_create("com.wc.test2", NULL);
    
    NSLog(@"start");
    [self doSomeLongTimeTaskWithQueue:queue];
    [self doSomeLongTimeTaskWithQueue:nil];
    NSLog(@"end");
    
    average_async2(dataPtr, len, queue, ^(float avg) {
        NSLog(@"2. notify work done");
        NSLog(@"avg2: %f", avg);
        
        free(dataPtr);
    });
    
    [self doSomeLongTimeTaskWithQueue:queue];
    [self doSomeLongTimeTaskWithQueue:nil];
}

- (void)test_average_async3:(int *)dataPtr len:(int)len {
    dispatch_queue_t queue = dispatch_queue_create("com.wc.test3", NULL);
    
    [self doSomeLongTimeTaskWithQueue:queue];
    [self doSomeLongTimeTaskWithQueue:nil];
    
    average_async3(dataPtr, len, queue, ^(float avg) {
        NSLog(@"3. notify work done");
        NSLog(@"avg3: %f", avg);
        
        free(dataPtr);
    });
    
    [self doSomeLongTimeTaskWithQueue:queue];
    [self doSomeLongTimeTaskWithQueue:nil];
}

#pragma mark

void average_async1(int data[], size_t len, dispatch_queue_t queue, void (^block)(float avg))
{
    // use global queue to do average() work
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        float avg = average(data, len);
        NSLog(@"Done average1");
        dispatch_async(queue, ^{
            block(avg);
        });
    });
}

void average_async2(int data[], size_t len, dispatch_queue_t queue, void (^block)(float avg))
{
    // use main dispatch queue to do average() work
    // FAULT: average() maybe block main thread
    float avg = average(data, len);
    NSLog(@"Done average2");
    dispatch_async(queue, ^{
        block(avg);
    });
}

void average_async3(int data[], size_t len, dispatch_queue_t queue, void (^block)(float avg))
{
    // use the same queue as completion block to do average() work
    // FAULT: completion block and average() are in the same queue, the same queue maybe have another long task.
    // If the order is average() -> long task -> call completion block, so completion block is not responsible.
    dispatch_async(queue, ^{
        float avg = average(data, len);
        NSLog(@"Done average3");
        dispatch_async(queue, ^{
            block(avg);
        });
    });
}

#pragma mark - Trivial Methods

float average(int data[], size_t len)
{
    float sum = 0;
    for (int i = 0; i < len; i++) {
        sum += data[i];
    }
    return sum / len;
}

- (void)doSomeLongTimeTaskWithQueue:(dispatch_queue_t)queue {
    
    if (queue) {
        dispatch_async(queue, ^{
            long i = 0;
            long long sum = 0;
            do {
                sum += i;
                i++;
            } while (i < 1000000000L);
        });
    }
    else {
        long i = 0;
        long long sum = 0;
        do {
            sum += i;
            i++;
        } while (i < 1000000000L);
    }
}

@end
