//
//  CheckNSObjectIsaVariableViewController.m
//  HelloObjCRuntime
//
//  Created by wesley chen on 17/1/10.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import "CheckNSObjectIsaVariableViewController.h"

#import <malloc/malloc.h>
#import <objc/runtime.h>

// NSObject declares Class isa as an ivar
@interface Derived : NSObject
{
    // placed a isa pointer ahead here which occupies 8 bytes in 64-bits system
@public // By default, ivars are @protected
    short a;    // 2 bytes
    // here padding two bytes after a
    int b;      // 4 bytes
}
@end
@implementation Derived @end


@interface CheckNSObjectIsaVariableViewController ()
@end

@implementation CheckNSObjectIsaVariableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self test];
}

- (void)test {
    // Example 1: get size of NSObject object
    NSObject *obj = [[NSObject alloc] init];
    NSLog(@"size(NSObject object): %ld", malloc_size((__bridge const void *)obj));
    NSData *objData = [NSData dataWithBytes:(__bridge const void *)(obj) length:malloc_size((__bridge const void *)(obj))];
    NSLog(@"NSObject object contains %@", objData);
    
    // Example 2: Check isa pointer
    NSLog(@"isa: %p", [obj class]);
    NSLog(@"size(isa): %lu", sizeof([obj class]));
    
    NSLog(@"---------------------------");
    
    // Example 3: get size of Derived object
    Derived *empty = [[Derived alloc] init];
    // access @public ivar by pointer
    empty->a = 0x1234;      // assign 2 bytes for short type
    empty->b = 0x12345678;  // assign 4 bytes for int type
    NSLog(@"size(Derived object): %ld", malloc_size((__bridge const void *)empty));
    objData = [NSData dataWithBytes:(__bridge const void *)(empty) length:malloc_size((__bridge const void *)(empty))];
    NSLog(@"Derived object contains %@", objData);
}

@end
