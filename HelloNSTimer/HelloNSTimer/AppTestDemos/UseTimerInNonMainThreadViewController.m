//
//  UseTimerInNonMainThreadViewController.m
//  HelloNSTimer
//
//  Created by wesley_chen on 2019/5/12.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UseTimerInNonMainThreadViewController.h"
#import "WCWeakProxy.h"
#import "WCMacroBlock.h"

@interface UseTimerInNonMainThreadViewController ()
@property (nonatomic, weak) NSTimer *timerInNonMainThread;
@end

@implementation UseTimerInNonMainThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weak_self = self;
    //weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //strongify(self);
        NSLog(@"NSTimer will be scheduled...");
        weak_self.timerInNonMainThread = [NSTimer scheduledTimerWithTimeInterval:1 target:WCWeakProxy_NEW(weak_self) selector:@selector(timerFired:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:weak_self.timerInNonMainThread forMode:NSDefaultRunLoopMode];
        NSLog(@"NSTimer scheduled...");
        [[NSRunLoop currentRunLoop] run];
        NSLog(@"block task is over...");
    });
}

- (void)dealloc {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.timerInNonMainThread invalidate]; // Don't use weakSelf in dealloc
    });
}

- (void)timerFired:(NSTimer *)timer {
    NSLog(@"%@: The timer is fired.", NSStringFromSelector(_cmd));
    NSLog(@"The current thread: %@, is main thread: %@", [NSThread currentThread], [NSThread isMainThread] ? @"YES" : @"NO");
}

@end
