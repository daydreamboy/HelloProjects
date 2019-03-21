//
//  MultiThreadExampleViewController.m
//  HelloNSThread
//
//  Created by wesley_chen on 2019/3/21.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "MultiThreadExampleViewController.h"

@interface MyObject1 : NSObject
+ (void)aMethod:(id)param;
@end

@implementation MyObject1
+ (void)aMethod:(id)param {
    int x;
    for (x = 0; x < 50; ++x) {
        printf("Object Thread says x is %i\n", x);
        usleep(1);
    }
}
@end

// Note: the example modified from http://softpixel.com/~cwright/programming/threads/threads.cocoa.php
@interface MultiThreadExampleViewController ()

@end

@implementation MultiThreadExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int x;
    [NSThread detachNewThreadSelector:@selector(aMethod:) toTarget:[MyObject1 class] withObject:nil];
    
    for(x = 0; x < 50; ++x) {
        printf("Main thread says x is %i\n", x);
        usleep(1);
        printf("Main thread lets go: %i\n",x);
        usleep(1);
    }
}

@end
