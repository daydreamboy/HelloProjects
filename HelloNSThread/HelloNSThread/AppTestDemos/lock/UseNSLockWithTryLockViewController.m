//
//  UseNSLockWithTryLockViewController.m
//  HelloNSThread
//
//  Created by wesley_chen on 2019/3/21.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UseNSLockWithTryLockViewController.h"

#define LoopCountOfMainThread 50
#define LoopCountOfObjectThread 1000

static NSLock *sLock;

@interface MyObject3 : NSObject
+ (void)aMethod:(id)param;
@end

@implementation MyObject3
+ (void)aMethod:(id)param {
    int x;
    // Note: let LoopCountOfObjectThread bigger than LoopCountOfMainThread to make object thread
    // lives longer so it probably can get the lock and print `Object Thread says x is ...`
    for (x = 0; x < LoopCountOfObjectThread; ++x) {
        if ([sLock tryLock]) {
            printf("Object Thread says x is %i\n", x);
            usleep(1);
            [sLock unlock];
        }
        else {
            printf("Busy on Main Thread and skip this loop, x is %i\n", x);
        }
    }
}
@end

@implementation UseNSLockWithTryLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sLock = [[NSLock alloc] init];
    sLock.name = @"Use NSLock with tryLock";
    
    int x;
    [NSThread detachNewThreadSelector:@selector(aMethod:) toTarget:[MyObject3 class] withObject:nil];
    
    for (x = 0; x < LoopCountOfMainThread; ++x) {
        [sLock lock];
        printf("Main thread says x is %i\n", x);
        usleep(1);
        printf("Main thread lets go: %i\n",x);
        usleep(1);
        [sLock unlock];
    }
}

@end
