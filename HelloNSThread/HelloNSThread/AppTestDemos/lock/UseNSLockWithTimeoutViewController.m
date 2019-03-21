//
//  UseNSLockWithTimeoutViewController.m
//  HelloNSThread
//
//  Created by wesley_chen on 2019/3/21.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UseNSLockWithTimeoutViewController.h"

static NSLock *sLock;

@interface MyObject4 : NSObject
+ (void)aMethod:(id)param;
@end

@implementation MyObject4
+ (void)aMethod:(id)param {
    int x;
    for(x = 0; x < 50; ++x) {
        NSTimeInterval timeInUSecond = 1 / 1000.0 / 1000.0 * 20;
        NSDate *deadline = [NSDate dateWithTimeInterval:timeInUSecond sinceDate:[NSDate date]];
        if ([sLock lockBeforeDate:deadline]) {
            printf("Object Thread says x is %i\n", x);
            usleep(1);
            [sLock unlock];
        }
        else {
            printf("timeout, x is %i\n", x); // x is sequenced and ordered
        }
    }
}
@end

@implementation UseNSLockWithTimeoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sLock = [[NSLock alloc] init];
    sLock.name = @"Use NSLock with lockBeforeDate";
    
    int x;
    [NSThread detachNewThreadSelector:@selector(aMethod:) toTarget:[MyObject4 class] withObject:nil];
    
    for(x = 0; x < 50; ++x) {
        [sLock lock];
        printf("Main thread says x is %i\n", x);
        usleep(1);
        printf("Main thread lets go: %i\n",x);
        usleep(1);
        [sLock unlock];
    }
}

@end
