//
//  UseWCDebouncerViewController.m
//  HelloFRP
//
//  Created by wesley_chen on 2020/10/8.
//

#import "UseWCDebouncerViewController.h"
#import "WCDebouncer.h"

#define ITERATIONS 10000

@interface UseWCDebouncerViewController ()
@property (nonatomic, strong) WCDebouncer *debouncer;
@end

@implementation UseWCDebouncerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.debouncer = [[WCDebouncer alloc] initWithDelay:0.5 serialQueue:nil];
    
    [self test_debounceWithBlock];
}

- (void)test_debounceWithBlock {
    //dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    static NSUInteger count = 0;
    
    CFTimeInterval startTime = CACurrentMediaTime();
    for (int i = 0; i < ITERATIONS; i++) {
//        dispatch_group_enter(group);
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
            count++;
            NSLog(@"submitted: %ld", (long)count);
            [self.debouncer debounceWithBlock:^{
                NSLog(@"handled: %ld", (long)count);
                //dispatch_semaphore_signal(sema);
            }];
        });
    }

    //dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    //CFTimeInterval endTime = CACurrentMediaTime();
    //NSLog(@"Total time for %@ iterations: %g ns", @(ITERATIONS), ((endTime - startTime) * 1000000));
}

@end
