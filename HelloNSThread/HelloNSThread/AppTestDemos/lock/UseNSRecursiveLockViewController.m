//
//  UseNSRecursiveLockViewController.m
//  HelloNSThread
//
//  Created by wesley_chen on 2019/3/20.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UseNSRecursiveLockViewController.h"

@interface UseNSRecursiveLockViewController ()
@property (nonatomic, strong) NSRecursiveLock *rcLock;
@property (nonatomic, strong) NSMutableDictionary *dictM;
@end

@implementation UseNSRecursiveLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rcLock = [[NSRecursiveLock alloc] init];
}

- (void)test_1_always_use_weak_object {
//    self.dictM = [NSMutableDictionary dictionary];
//
//    self.dictM[@"object"] = @"1";
//
//    __weak typeof(object) weak_object = object;
//    [NSThread detachNewThreadWithBlock:^{
//        NSLog(@"1. %@ (%p)", weak_object, [NSThread currentThread]);
//
//        [NSThread sleepForTimeInterval:5];
//
//        NSLog(@"2. %@ (%p)", weak_object, [NSThread currentThread]); // Maybe nil
//    }];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        for (NSInteger i = 0; i < 100; i++) {
//            [NSThread detachNewThreadWithBlock:^{
//                self.dictM[@"object"] = nil;
//                NSLog(@"set nil (%p %d)", [NSThread currentThread], (int)i);
//            }];
//        }
//    });
}

- (void)changeDictWithKey:(NSString *)key value:(NSString *)value {
//    [self.rcLock lock];
//    
//    self.dictM[key] = value;
//    
//    [self.rcLock unlock];
}

@end
