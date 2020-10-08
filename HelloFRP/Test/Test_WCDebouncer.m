//
//  Test_WCDebouncer.m
//  Test_WCDebouncer
//
//  Created by wesley_chen on 2020/10/6.
//

#import <XCTest/XCTest.h>
#import "WCDebouncer.h"

#define ITERATIONS 10000

@interface Test_WCDebouncer : XCTestCase
@property (nonatomic, strong) WCDebouncer *debouncer;
@end

@implementation Test_WCDebouncer

- (void)setUp {
    NSLog(@"\n");
    
    self.debouncer = [[WCDebouncer alloc] initWithDelay:0.3 serialQueue:nil];
}

- (void)tearDown {
    NSLog(@"\n");
    self.debouncer = nil;
}

- (void)test_debounceWithBlock {
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    CFTimeInterval startTime = CACurrentMediaTime();
    for (int i = 0; i < ITERATIONS; i++) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
            NSLog(@"submitted: %ld", (long)i);
            [self.debouncer debounceWithBlock:^{
                NSLog(@"handled: %ld", (long)i);
                dispatch_semaphore_signal(sema);
            }];
        });
    }

    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    CFTimeInterval endTime = CACurrentMediaTime();
    NSLog(@"Total time for %@ iterations: %g ns", @(ITERATIONS), ((endTime - startTime) * 1000000));
}

@end
