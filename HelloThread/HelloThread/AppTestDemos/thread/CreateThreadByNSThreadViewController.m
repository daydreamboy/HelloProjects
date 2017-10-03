//
//  CreateThreadByNSThreadViewController.m
//  HelloThread
//
//  Created by wesley_chen on 2017/10/3.
//  Copyright © 2017年 wesley_chen. All rights reserved.
//

#import "CreateThreadByNSThreadViewController.h"

@interface CreateThreadByNSThreadViewController ()

@end

@implementation CreateThreadByNSThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"main thread: %@", [NSThread currentThread]);
    
    [self test_create_thread_with_NSThread_1];
    [self test_create_thread_with_NSThread_2];
}

#pragma mark - Test Methods

- (void)test_create_thread_with_NSThread_1 {
    id param = @"an object";
    // Note: selector is an entry function for starting a new thread
    [NSThread detachNewThreadSelector:@selector(threadEntryMethod1:) toTarget:self withObject:param];
}

- (void)threadEntryMethod1:(id)argument {
    NSLog(@"thread: %@, argument: %@", [NSThread currentThread], argument);
}

- (void)test_create_thread_with_NSThread_2 {
    id param = @"an object";
    NSThread *myThread = [[NSThread alloc] initWithTarget:self selector:@selector(threadEntryMethod2:) object:param];
    [myThread start];
}

- (void)threadEntryMethod2:(id)argument {
    NSLog(@"thread: %@, argument: %@", [NSThread currentThread], argument);
}

@end
