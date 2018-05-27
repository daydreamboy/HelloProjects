//
//  TimerRetainCycleViewController.m
//  HelloNSProxy
//
//  Created by wesley_chen on 2018/5/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "TimerRetainCycleViewController.h"

@interface TimerRetainCycleViewController ()
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation TimerRetainCycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

- (void)dealloc {
    NSLog(@"the bellow timer invalidate never called, because dealloc never called");
    [self.timer invalidate];
}

- (void)timerFired:(NSTimer *)timer {
    NSLog(@"timerFired");
}

@end
