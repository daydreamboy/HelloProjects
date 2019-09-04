//
//  Test_weak.m
//  Test_OC
//
//  Created by wesley_chen on 2019/6/14.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Test_weak : XCTestCase

@end

@implementation Test_weak

- (void)dealloc {
    __weak typeof(self) weak_self = self; // ERROR: crash here
    NSLog(@"%@", weak_self);
}

#pragma mark -

- (void)test_weak_cause_crash_in_dealloc {
    {
        Test_weak *object = [[Test_weak alloc] init];
        NSLog(@"%@", object);
    }
    // Note: release the object after the end of code block
}

@end
