//
//  CreateSignalDispatchSourceViewController.m
//  HelloGCD
//
//  Created by wesley chen on 17/1/1.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import "CreateSignalDispatchSourceViewController.h"

@interface CreateSignalDispatchSourceViewController ()

@end

@implementation CreateSignalDispatchSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

void InstallSignalHandler()
{
    // make sure the signal does not terminate the application
    signal(SIGHUP, SIG_IGN);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_SIGNAL, SIGHUP, 0, queue);
    
    if (source) {
        dispatch_source_set_event_handler(source, ^{
            MyProcessSIGHUP();
        });
        
        // start processing signals
        dispatch_resume(source);
    }
}

void MyProcessSIGHUP()
{
    
}

@end
