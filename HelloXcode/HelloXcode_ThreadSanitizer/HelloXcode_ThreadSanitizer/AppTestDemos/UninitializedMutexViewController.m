//
//  UninitializedMutexViewController.m
//  HelloXcode_ThreadSanitizer
//
//  Created by wesley_chen on 2018/11/20.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UninitializedMutexViewController.h"
#include <pthread.h>

@interface UninitializedMutexViewController ()

@end

@implementation UninitializedMutexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test_perform_work1];
    [self test_perform_work2];
}

#pragma mark - Test Methods

static pthread_mutex_t mutex1;

- (void)test_perform_work1 {
    pthread_mutex_lock(&mutex1); // Error: uninitialized mutex
    // ...
    pthread_mutex_unlock(&mutex1);
}

static pthread_once_t once = PTHREAD_ONCE_INIT;
static pthread_mutex_t mutex2;

void init()
{
    pthread_mutex_init(&mutex2, NULL);
}

- (void)test_perform_work2 {
    pthread_once(&once, init); // Correct
    pthread_mutex_lock(&mutex2);
    // ...
    pthread_mutex_unlock(&mutex2);
}

@end
