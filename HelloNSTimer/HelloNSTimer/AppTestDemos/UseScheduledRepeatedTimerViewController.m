//
//  UseScheduledRepeatedTimerViewController.m
//  HelloNSTimer
//
//  Created by wesley_chen on 2019/5/12.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UseScheduledRepeatedTimerViewController.h"
#import "WCWeakProxy.h"

@interface UseScheduledRepeatedTimerViewController ()
@property (nonatomic, weak) NSTimer *timerInMainThread;
@end

@implementation UseScheduledRepeatedTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    NSLog(@"NSTimer will be scheduled...");
    self.timerInMainThread = [NSTimer scheduledTimerWithTimeInterval:3 target:WCWeakProxy_NEW(self) selector:@selector(timerInMainThreadFired:) userInfo:nil repeats:YES];
    NSLog(@"NSTimer scheduled...");
}

- (void)dealloc {
    NSLog(@"NSTimer will be invalidated...");
    [_timerInMainThread invalidate];
    _timerInMainThread = nil;
    NSLog(@"NSTimer will be released...");
}

#pragma mark - NSTimer

- (void)timerInMainThreadFired:(NSTimer *)sender {
    NSLog(@"%@: The timer is fired.", NSStringFromSelector(_cmd));
    NSLog(@"The current thread: %@, is main thread: %@", [NSThread currentThread], [NSThread isMainThread] ? @"YES" : @"NO");
}

@end
