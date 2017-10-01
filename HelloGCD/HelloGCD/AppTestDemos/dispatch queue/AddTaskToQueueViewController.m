//
//  AddTaskToQueueViewController.m
//  HelloGCD
//
//  Created by wesley chen on 16/11/20.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "AddTaskToQueueViewController.h"

@interface ContextData : NSObject
@property (nonatomic, copy) NSString *name;
@end

@implementation ContextData
- (void)dealloc {
    NSLog(@"dealloc: %@", self);
}
@end

@interface AddTaskToQueueViewController ()

@end

@implementation AddTaskToQueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // TODO: Toggle the following lines to test
    
    [self test_submit_task_asynchronously];
    //[self test_submit_task_synchronously];
    //[self test_doDeadLockOnMainDispatchQueue];
    //[self test_doDeadLockOnSerialDispatchQueue];
    //[self test_doDeadLockOnNestedCall];
}

#pragma mark - Test Methods

#pragma mark > Asynchronous

- (void)test_submit_task_asynchronously {
    dispatch_queue_t queue = dispatch_queue_create("com.wc.test1", NULL);
    
    dispatch_async(queue, ^{
        NSLog(@"do async work in block");
    });
    
    NSLog(@"The first block may or may not have run");
    NSLog(@"The first block may or may not have run");
    NSLog(@"The first block may or may not have run");
    NSLog(@"The first block may or may not have run");
    NSLog(@"The first block may or may not have run");
    
    ContextData *context = [ContextData new];
    context.name = @"test1";
    
    dispatch_async_f(queue, (__bridge_retained void *)(context), &dispatch_function_1);
}

void dispatch_function_1(void *context)
{
    ContextData *data = (__bridge_transfer ContextData *)(context);
    NSLog(@"context data's name: %@", data.name);
    NSLog(@"do async work in function");
}

#pragma mark > Synchronous

- (void)test_submit_task_synchronously {
    dispatch_queue_t queue = dispatch_queue_create("com.wc.test2", NULL);
    
    dispatch_sync(queue, ^{
        NSLog(@"do sync work in block");
    });
    
    NSLog(@"wait the first block finished");
    NSLog(@"wait the first block finished");
    NSLog(@"wait the first block finished");
    NSLog(@"wait the first block finished");
    NSLog(@"wait the first block finished");
    
    ContextData *context = [ContextData new];
    context.name = @"test2";
    
    dispatch_async_f(queue, (__bridge_retained void *)(context), &dispatch_function_2);
}

void dispatch_function_2(void *context)
{
    ContextData *data = (__bridge_transfer ContextData *)(context);
    NSLog(@"context data's name: %@", data.name);
    NSLog(@"do sync work in function");
}

#pragma mark > Dead Lock

- (void)test_doDeadLockOnMainDispatchQueue {
    dispatch_sync(dispatch_get_main_queue(), ^{ // Error: dead lock here!!!
        NSLog(@"should nevet output");
    });
    NSLog(@"should never output");
}

- (void)test_doDeadLockOnSerialDispatchQueue {
    dispatch_queue_t queue = dispatch_queue_create("com.wc.test3", NULL);
    
    dispatch_async(queue, ^{
        
        NSLog(@"will dead lock");
        dispatch_sync(queue, ^{ // Error: dead lock here!!!
           NSLog(@"should never output");
        });
    });
}

static dispatch_queue_t queueA;
static dispatch_queue_t queueB;

void baz(void)
{
    printf("baz called");
}

void foo(void)
{
    dispatch_sync(queueB, ^(){
        bar();
    });
}

void bar(void)
{
    dispatch_sync(queueA, ^(){ // Error: dead lock here!!!
        baz();
    });
}

- (void)test_doDeadLockOnNestedCall {
    queueA = dispatch_queue_create("com.wc.example.queueA", 0);
    queueB = dispatch_queue_create("com.wc.example.queueB", 0);
    
    // @see https://www.objc.io/issues/2-concurrency/low-level-concurrency-apis/
    dispatch_sync(queueA, ^(){
        foo();
    });
}

@end
