//
//  GlobalConcurrentQueueViewController.m
//  HelloGCD
//
//  Created by wesley chen on 16/11/20.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "GlobalConcurrentQueueViewController.h"

@interface GlobalConcurrentQueueViewController ()

@end

@implementation GlobalConcurrentQueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    dispatch_queue_priority_t priority = DISPATCH_QUEUE_PRIORITY_HIGH;
    
    dispatch_async(dispatch_get_global_queue(priority, 0), ^{
        // set a breakpoint at below line to see threads
        // com.apple.root.user-initiated-qos
        NSLog(@"queue label with high: %s", dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL));
    });
    
    priority = DISPATCH_QUEUE_PRIORITY_DEFAULT;
    dispatch_async(dispatch_get_global_queue(priority, 0), ^{
        // set a breakpoint at below line to see threads
        // com.apple.root.default-qos
        NSLog(@"queue label with default: %s", dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL));
    });
    
    priority = DISPATCH_QUEUE_PRIORITY_LOW;
    dispatch_async(dispatch_get_global_queue(priority, 0), ^{
        // set a breakpoint at below line to see threads
        // com.apple.root.utility-qos
        NSLog(@"queue label with low: %s", dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL));
    });
    
    priority = DISPATCH_QUEUE_PRIORITY_BACKGROUND;
    dispatch_async(dispatch_get_global_queue(priority, 0), ^{
        // set a breakpoint at below line to see threads
        // com.apple.root.background-qos
        NSLog(@"queue label with backgroud: %s", dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL));
    });
}

@end
