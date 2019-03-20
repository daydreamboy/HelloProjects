//
//  PerformDispatchBlockOnThreadViewController.m
//  HelloThread
//
//  Created by wesley_chen on 09/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "PerformDispatchBlockOnThreadViewController.h"
#import "WCThreadTool.h"

@interface PerformDispatchBlockOnThreadViewController ()
@property (nonatomic, strong) NSThread *sharedThread;
@end

@implementation PerformDispatchBlockOnThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self start_a_long_alive_thread];
    
    [self test_WCThreadTool_performBlock_onThread];
    [self test_WCThreadTool_performBlock_onThread_withObject];
}

- (void)start_a_long_alive_thread {
    NSThread *myThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint:) object:nil];
    [myThread start];
    self.sharedThread = myThread;
}

- (void)networkRequestThreadEntryPoint:(id)__unused object {
    @autoreleasepool {
        [[NSThread currentThread] setName:@"My_AFNetworking"];
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

#pragma mark - Test Methods

- (void)test_WCThreadTool_performBlock_onThread {
    
    dispatch_block_t block = ^{
        NSLog(@"block called on %@", [NSThread currentThread]);
    };
    
    [WCThreadTool performBlock:block onThread:self.sharedThread waitUntilDone:NO];
}

- (void)test_WCThreadTool_performBlock_onThread_withObject {
    
    void (^block)(id) = ^(id object){
        NSLog(@"block called on %@ with arg1 `%@`", [NSThread currentThread], object);
    };
    
    id param = @"an object";
    [WCThreadTool performBlock:block onThread:self.sharedThread withObject:param waitUntilDone:NO];
}

@end
