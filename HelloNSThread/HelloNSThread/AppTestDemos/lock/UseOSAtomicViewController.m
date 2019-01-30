//
//  UseOSAtomicViewController.m
//  HelloThread
//
//  Created by wesley_chen on 2017/10/3.
//  Copyright © 2017年 wesley_chen. All rights reserved.
//

#import "UseOSAtomicViewController.h"

#import <libkern/OSAtomic.h>

void * sharedBuffer(void)
{
    // Note: behave as dispatch_once
    static void * buffer;
    if (buffer == NULL) {
        void * newBuffer = calloc(1, 1024);
        if (!OSAtomicCompareAndSwapPtr(NULL, newBuffer, &buffer)) {
            free(newBuffer);
        }
    }
    return buffer;
}

@interface UseOSAtomicViewController ()

@end

@implementation UseOSAtomicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test_OSAtomic];
}

#pragma mark - Test Methods

- (void)test_OSAtomic {
    void *sharedInstance = sharedBuffer();
    NSLog(@"%p", sharedInstance);
}

@end
