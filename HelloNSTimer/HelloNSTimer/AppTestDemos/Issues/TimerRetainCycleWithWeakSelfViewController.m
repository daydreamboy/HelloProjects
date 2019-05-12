//
//  TimerRetainCycleWithWeakSelfViewController.m
//  HelloNSTimer
//
//  Created by wesley_chen on 2019/5/12.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "TimerRetainCycleWithWeakSelfViewController.h"

@interface TimerRetainCycleWithWeakSelfViewController ()
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation TimerRetainCycleWithWeakSelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weak_self = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:weak_self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

- (void)dealloc {
    NSLog(@"the bellow timer invalidate never called, because dealloc never called");
    [_timer invalidate];
}

- (void)timerFired:(NSTimer *)timer {
    NSLog(@"timerFired");
}

@end
