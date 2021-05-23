//
//  Tests_used.m
//  Test_OC
//
//  Created by wesley_chen on 2021/5/23.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

__attribute__((used))
static NSString *funtion_not_call_but_still_keep_in_binary(void) {
    return NSStringFromClass([XCTestCase class]);
}
