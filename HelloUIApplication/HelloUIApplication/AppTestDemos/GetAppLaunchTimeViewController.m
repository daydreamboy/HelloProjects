//
//  GetAppLaunchTimeViewController.m
//  HelloUIApplication
//
//  Created by wesley_chen on 2021/3/23.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "GetAppLaunchTimeViewController.h"
#import "WCApplicationTool.h"

@interface GetAppLaunchTimeViewController ()
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation GetAppLaunchTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark -

- (void)timerFired:(id)timer {
    NSTimeInterval ts = [WCApplicationTool appProcessStartTime];
    NSLog(@"%f", ts);
}

@end
