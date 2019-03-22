//
//  UseNSLockViewController.m
//  HelloNSThread
//
//  Created by wesley_chen on 2019/3/20.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UseNSLockViewController.h"

static NSLock *sLock;

@interface MyObject2 : NSObject
+ (void)aMethod:(id)param;
@end

@implementation MyObject2
+ (void)aMethod:(id)param {
    int x;
    for (x = 0; x < 50; ++x) {
        [sLock lock];
        printf("Object Thread says x is %i\n", x);
        usleep(1);
        [sLock unlock];
    }
}
@end

@implementation UseNSLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sLock = [[NSLock alloc] init];
    sLock.name = @"Use NSLock";
    
    int x;
    [NSThread detachNewThreadSelector:@selector(aMethod:) toTarget:[MyObject2 class] withObject:nil];
    
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
