//
//  TimerInNonMainTheadNotFiredViewController.m
//  HelloNSTimer
//
//  Created by wesley_chen on 2019/5/12.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "TimerInNonMainTheadNotFiredViewController.h"

@interface TimerInNonMainTheadNotFiredViewController ()
@property (nonatomic, weak) NSTimer *timerInNonMainThread;
@end

@implementation TimerInNonMainTheadNotFiredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"NSTimer will be scheduled...");
        self.timerInNonMainThread = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        NSLog(@"NSTimer scheduled...");
    });
}

- (void)dealloc {
    [_timerInNonMainThread invalidate];
}

- (void)timerFired:(NSTimer *)timer {
    NSLog(@"%@: The timer is fired.", NSStringFromSelector(_cmd));
    NSLog(@"The current thread: %@, is main thread: %@", [NSThread currentThread], [NSThread isMainThread] ? @"YES" : @"NO");
}

@end
