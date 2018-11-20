//
//  ThreadLeakViewController.m
//  HelloXcode_ThreadSanitizer
//
//  Created by wesley_chen on 2018/11/20.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "ThreadLeakViewController.h"
#include <pthread.h>

@interface ThreadLeakViewController ()

@end

@implementation ThreadLeakViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self test_thread_leak];
    [self test_case_1_not_thread_leak];
//    [self test_case_2_not_thread_leak];
//    [self test_case_3_not_thread_leak];
}

#pragma mark - Test Methods

void *run()
{
    sleep(5);
    NSLog(@"exit\n");
    pthread_exit(0);
}

- (void)test_thread_leak {
    pthread_t thread;
    pthread_create(&thread, NULL, run, NULL); // Error: thread leak
    sleep(1);
}

- (void)test_case_1_not_thread_leak {
    pthread_t thread;
    pthread_create(&thread, NULL, run, NULL);
    sleep(1);
    pthread_join(thread, NULL); // Correct
    NSLog(@"test_case_1_not_thread_leak");
}

- (void)test_case_2_not_thread_leak {
    pthread_t thread;
    pthread_create(&thread, NULL, run, NULL);
    pthread_detach(thread); // Correct
    sleep(1);
}

// @see https://www.ibm.com/support/knowledgecenter/en/SSLTBW_2.3.0/com.ibm.zos.v2r3.bpxbd00/ptades.htm
- (void)test_case_3_not_thread_leak {
    pthread_attr_t attr;
    pthread_attr_init(&attr);
    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED); // Correct
    
    pthread_t thread;
    pthread_create(&thread, &attr, run, NULL);
    sleep(1);
    
    pthread_attr_destroy(&attr);
}

@end
