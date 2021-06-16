//
//  Tests_tagged_pointer.m
//  Test_OC
//
//  Created by wesley_chen on 2021/6/17.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_tagged_pointer : XCTestCase

@end

@implementation Tests_tagged_pointer

- (void)test_check_tagged_pointer_NSString {
    NSString *string;
    
    // Case 1
    string = @"a";
    NSLog(@"%@", NSStringFromClass([string class]));
}

- (void)test_check_tagged_pointer_NSNumber {
}

- (void)test_check_tagged_pointer_NSDate {
}

@end
