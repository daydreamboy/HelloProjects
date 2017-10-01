//
//  CreateQueueInactiveViewController.m
//  HelloGCD
//
//  Created by wesley chen on 16/12/17.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "CreateQueueInactiveViewController.h"

@interface CreateQueueInactiveViewController ()

@end

@implementation CreateQueueInactiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self test_create_inactive_serial_queue];
}

- (void)test_create_inactive_serial_queue {
    dispatch_queue_t queue = dispatch_queue_create("com.example.inactiveQueue1", DISPATCH_QUEUE_SERIAL_INACTIVE);
    dispatch_async(queue, ^{
        NSLog(@"do async task1");
    });
    
    dispatch_activate(queue);
    NSLog(@"after active");
}

@end
