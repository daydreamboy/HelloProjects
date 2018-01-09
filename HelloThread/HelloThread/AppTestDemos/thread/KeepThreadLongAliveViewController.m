//
//  KeepThreadLongAliveViewController.m
//  HelloThread
//
//  Created by wesley_chen on 09/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "KeepThreadLongAliveViewController.h"

@interface KeepThreadLongAliveViewController ()

@end

@implementation KeepThreadLongAliveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test_start_a_long_alive_thread];
}

#pragma mark - Test Methods

- (void)test_start_a_long_alive_thread {
    NSThread *myThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint:) object:nil];
    [myThread start];
}

- (void)networkRequestThreadEntryPoint:(id)__unused object {
    // @see https://stackoverflow.com/a/20393653
    @autoreleasepool {
        [[NSThread currentThread] setName:@"My_AFNetworking"];
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

@end
