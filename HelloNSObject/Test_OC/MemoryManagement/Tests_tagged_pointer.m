//
//  Tests_tagged_pointer.m
//  Test_OC
//
//  Created by wesley_chen on 2021/6/17.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>

@interface Tests_tagged_pointer : XCTestCase

@end

@implementation Tests_tagged_pointer

- (void)test_check_tagged_pointer_NSString {
    // Case 1
    {
        NSString *a = @"a";
        NSString *b = [[a mutableCopy] copy];
        NSLog(@"%p %p %@", a, b, object_getClass(b));
    }
    
    // Case 2
    {
        NSString *a = @"b";
        NSString *b = [[a mutableCopy] copy];
        NSLog(@"%p %p %@", a, b, object_getClass(b));
    }
}

- (void)test_check_tagged_pointer_NSNumber {
    NSNumber *number1 = @10;
    NSNumber *number2 = @11;
    NSNumber *number3 = @12;

    NSLog(@"%p %@", number1, object_getClass(number1));
    NSLog(@"%p %@", number2, object_getClass(number2));
    NSLog(@"%p %@", number3, object_getClass(number3));
}

- (void)test_check_tagged_pointer_NSDate {
}

@end
