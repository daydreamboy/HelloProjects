//
//  WeakWrapperProxyViewController.m
//  HelloNSProxy
//
//  Created by wesley_chen on 2018/5/16.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WeakWrapperProxyViewController.h"
#import "WCWeakProxy.h"

@interface WeakWrapperProxyViewController ()
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation WeakWrapperProxyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Note: 让timer持有weakProxy，这里weakProxy不会自动释放
    WCWeakProxy *weakProxy = [WCWeakProxy proxyWithTarget:self];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakProxy selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

- (void)dealloc {
    [self.timer invalidate];
}

- (void)timerFired:(NSTimer *)timer {
    NSLog(@"timerFired");
}

@end
