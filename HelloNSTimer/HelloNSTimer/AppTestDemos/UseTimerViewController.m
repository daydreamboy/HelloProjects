//
//  UseTimerViewController.m
//  HelloNSTimer
//
//  Created by wesley_chen on 2019/5/6.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UseTimerViewController.h"

@interface UseTimerViewController ()
@property (nonatomic, strong) NSTimer *timerInBackground;
@end

@implementation UseTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSThread detachNewThreadWithBlock:^{
        self.timerInBackground = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerInBackgroundFired:) userInfo:nil repeats:YES];
    }];
}

#pragma mark - NSTimer

- (void)timerInBackgroundFired:(NSTimer *)sender {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

@end
