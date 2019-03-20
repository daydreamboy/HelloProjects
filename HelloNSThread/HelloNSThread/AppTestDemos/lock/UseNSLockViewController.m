//
//  UseNSLockViewController.m
//  HelloNSThread
//
//  Created by wesley_chen on 2019/3/20.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UseNSLockViewController.h"

@interface UseNSLockViewController ()
@property (nonatomic, strong) NSLock *lock;
@end

@implementation UseNSLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lock = [[NSLock alloc] init];
    self.lock.name = @"Simple Lock";
}

- (void)test_NSLock_tryLock {
    [NSThread detachNewThreadSelector:@selector(threadEntranceWithName:) toTarget:self withObject:@"MyThread 1"];
    [NSThread detachNewThreadSelector:@selector(threadEntranceWithName:) toTarget:self withObject:@"MyThread 2"];
    [NSThread detachNewThreadSelector:@selector(threadEntranceWithName:) toTarget:self withObject:@"MyThread 3"];
}

- (void)threadEntranceWithName:(NSString *)name {
    NSLog(@"start thread: %@", name);
    BOOL moreToDo = YES;
    while (moreToDo) {
        if ([self.lock tryLock]) {
            [NSThread sleepForTimeInterval:3];
            [self.lock unlock];
        }
    }
    NSLog(@"finish thread: %@", name);
}

@end
