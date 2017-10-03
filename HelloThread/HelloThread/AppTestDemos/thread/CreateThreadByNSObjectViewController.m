//
//  CreateThreadByNSObjectViewController.m
//  HelloThread
//
//  Created by wesley_chen on 2017/10/3.
//  Copyright © 2017年 wesley_chen. All rights reserved.
//

#import "CreateThreadByNSObjectViewController.h"

@interface CreateThreadByNSObjectViewController ()

@end

@implementation CreateThreadByNSObjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test_create_thread_with_NSObject_category];
}

#pragma mark - Test Methods

- (void)test_create_thread_with_NSObject_category {
    id param = @"Something";
    // Note: delcared in NSObject (NSThreadPerformAdditions)
    [self performSelectorInBackground:@selector(doSomething:) withObject:param];
}

- (void)doSomething:(id)argument {
    @autoreleasepool {
        // do thread work here
        NSLog(@"thread: %@, argument: %@", [NSThread currentThread], argument);
    }
}

@end
