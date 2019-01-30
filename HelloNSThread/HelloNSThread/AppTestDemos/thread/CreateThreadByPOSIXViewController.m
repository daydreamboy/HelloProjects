//
//  CreateThreadByPOSIXViewController.m
//  HelloThread
//
//  Created by wesley_chen on 2017/10/3.
//  Copyright © 2017年 wesley_chen. All rights reserved.
//

#import "CreateThreadByPOSIXViewController.h"

#import <assert.h>
#import <pthread.h>


void* PosixThreadMainRoutine(void* data)
{
    // do some work here
    NSLog(@"PosixThreadMainRoutine called");
    NSLog(@"thread: %@", [NSThread currentThread]);
    
    return NULL;
}

void LaunchThread()
{
    // Create the thread using POSIX routines
    pthread_attr_t attr;
    pthread_t posixThreadID;
    int returnVal;
    
    returnVal = pthread_attr_init(&attr);
    assert(!returnVal);
    
    returnVal = pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
    assert(!returnVal);
    
    int threadError = pthread_create(&posixThreadID, &attr, &PosixThreadMainRoutine, NULL);
    
    returnVal = pthread_attr_destroy(&attr);
    assert(!returnVal);
    
    if (threadError != 0) {
        // Report an error
    }
}


@interface CreateThreadByPOSIXViewController ()

@end

@implementation CreateThreadByPOSIXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test_create_thread_with_pthread];
}

- (void)test_create_thread_with_pthread {
    LaunchThread();
}

@end
