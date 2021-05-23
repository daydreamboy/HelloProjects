//
//  Tests_weak.m
//  Test_OC
//
//  Created by wesley_chen on 2021/5/23.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Tests_weak_class1.h"
#import "Tests_weak_class2.h"

@interface Tests_weak : XCTestCase
@end

NSString *bar_maybe_exist_yet_another(void) {
    return NSStringFromClass([Tests_weak class]);
}

NSString * __attribute__((weak)) weak_bar_maybe_exist_yet_another(void) {
    return NSStringFromClass([Tests_weak class]);
}

NSString *weak_bar_not_exist(void) __attribute__((weak));

@implementation Tests_weak

- (void)test_only_one_strong_multiple_weak {
    NSString *output;
    output = foo_maybe_exist_yet_another();
    NSLog(@"%@", output);
    
    XCTAssertEqualObjects(output, @"Tests_weak_class2");
}

- (void)test_multiple_strong_one_weak {
    NSString *output;
    // Note: expect use bar_maybe_exist_yet_another function in this file, but not in fact
    output = bar_maybe_exist_yet_another();
    NSLog(@"%@", output);
    
    XCTAssertEqualObjects(output, @"Tests_weak_class2");
}

- (void)test_no_strong_multiple_weak {
    NSString *output;
    output = weak_bar_maybe_exist_yet_another();
    NSLog(@"%@", output);
    
    XCTAssertEqualObjects(output, @"Tests_weak_class1");
}

- (void)test_weak_function_definition_not_exist {
    // Link Error: "_weak_bar_not_exist" not found
    //weak_bar_not_exist();
}

@end
