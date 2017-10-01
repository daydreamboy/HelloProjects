//
//  GetCommonQueuesViewController.m
//  HelloGCD
//
//  Created by wesley chen on 16/11/20.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "GetCommonQueuesViewController.h"

@interface GetCommonQueuesViewController ()
@property (nonatomic, strong) dispatch_queue_t queue;
@end

@implementation GetCommonQueuesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 3 ways to get common queues
    
    // 1. use dispatch_get_current_queue (Deprecated. Only for debuggin and testing)
    dispatch_queue_t currentQueue = dispatch_get_current_queue();
    NSLog(@"1. %s in %@", dispatch_queue_get_label(currentQueue), NSStringFromSelector(_cmd));
    
    /*
    dispatch_async(dispatch_queue_create("com.wc.myQueueu", NULL), ^{
        dispatch_queue_t currentQueue = dispatch_get_current_queue(); // will crash here
        NSLog(@"%s in %@", dispatch_queue_get_label(currentQueue), NSStringFromSelector(_cmd));
    });
     */
    
    _queue = dispatch_queue_create("com.wc.myQueueu2", NULL);
    dispatch_async(_queue, ^{
        dispatch_queue_t currentQueue = dispatch_get_current_queue();
        NSLog(@"2. %s in %@", dispatch_queue_get_label(currentQueue), NSStringFromSelector(_cmd));
    });
    
    // 2. use dispatch_get_main_queue
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_queue_t currentQueue = dispatch_get_current_queue();
        NSLog(@"3. %s in %@", dispatch_queue_get_label(currentQueue), NSStringFromSelector(_cmd));
    });
    
    // 3. use dispatch_get_global_queue
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_queue_t currentQueue = dispatch_get_current_queue();
        NSLog(@"4. %s in %@", dispatch_queue_get_label(currentQueue), NSStringFromSelector(_cmd));
    });
}

@end
