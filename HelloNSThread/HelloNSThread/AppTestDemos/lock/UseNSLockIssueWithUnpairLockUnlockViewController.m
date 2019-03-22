//
//  UseNSLockIssueWithUnpairLockUnlockViewController.m
//  HelloNSThread
//
//  Created by wesley_chen on 2019/3/21.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UseNSLockIssueWithUnpairLockUnlockViewController.h"

static NSLock *sLock;

@interface MyObject6 : NSObject
+ (void)aMethod:(id)param;
@end

@implementation MyObject6
+ (void)aMethod:(id)param {
    int x;
    for (x = 0; x < 50; ++x) {
        if ([sLock tryLock]) {
            printf("Object Thread says x is %i\n", x);
            usleep(1);
            [sLock unlock];
        }
        else {
            // Error: this thread does not acquire the lock at this point,
            // but relinquish the lcok to make lock not works
            [sLock unlock];
            printf("Busy on Main Thread and skip this loop, x is %i\n", x);
        }
    }
}
@end

@implementation UseNSLockIssueWithUnpairLockUnlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sLock = [[NSLock alloc] init];
    sLock.name = @"Use NSLock with tryLock";
    
    int x;
    [NSThread detachNewThreadSelector:@selector(aMethod:) toTarget:[MyObject6 class] withObject:nil];
    
    for(x = 0; x < 50; ++x) {
        [sLock lock];
        // Note: make two printf to be atomic
        printf("Main thread says x is %i\n", x);
        usleep(1);
        printf("Main thread lets go: %i\n",x);
        usleep(1);
        [sLock unlock];
    }
}

@end
