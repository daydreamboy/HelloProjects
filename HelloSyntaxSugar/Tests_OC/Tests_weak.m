//
//  Tests_weak.m
//  Tests_OC
//
//  Created by wesley_chen on 2019/6/14.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_weak : XCTestCase

@end

@implementation Tests_weak

- (void)dealloc {
    __weak typeof(self) weak_self = self; // ERROR: crash here
    NSLog(@"%@", weak_self);
}

#pragma mark -

- (void)test_weak_cause_crash_in_dealloc {
    {
        Tests_weak *object = [[Tests_weak alloc] init];
        NSLog(@"%@", object);
    }
    // Note: release the object after the end of code block
}

@end
