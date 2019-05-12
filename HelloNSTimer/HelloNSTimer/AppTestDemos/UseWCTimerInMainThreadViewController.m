//
//  UseWCTimerInMainThreadViewController.m
//  HelloNSTimer
//
//  Created by wesley_chen on 2019/5/12.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UseWCTimerInMainThreadViewController.h"
#import "WCTimer.h"
#import "WCMacroBlock.h"

@interface UseWCTimerInMainThreadViewController ()
@property (nonatomic, strong) WCTimer *timer;
@end

@implementation UseWCTimerInMainThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    weakify(self);
    self.timer = [WCTimer timerWithTimeInterval:1 repeats:YES queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0) block:^(WCTimer * _Nonnull timer) {
        strongify(self);
        [self timerFired];
    }];
    if ([self.timer start]) {
        NSLog(@"timer started");
    }
    else {
        NSLog(@"timer start failed");
    }
}

- (void)dealloc {
    NSLog(@"dealloc");
    [self.timer stop];
}

- (void)timerFired {
    NSLog(@"timerFired");
}

@end
