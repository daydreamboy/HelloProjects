//
//  Test__builtin_return_address.m
//  Tests_OC
//
//  Created by wesley_chen on 2021/3/21.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Test__builtin_return_address : XCTestCase

@end

@implementation Test__builtin_return_address

void get_function_address(void)
{
    void *current_function_ptr = get_function_address;
    printf("current: %p\n", current_function_ptr);
    printf("return: %p\n", __builtin_return_address(0));
}

- (void)test__builtin_return_address {
    get_function_address();
}

@end
