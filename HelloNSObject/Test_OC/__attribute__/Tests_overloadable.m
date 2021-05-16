//
//  Tests_overloadable.m
//  Tests_OC
//
//  Created by wesley_chen on 2021/2/15.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

__attribute__((overloadable))
static void logAnything(id obj) {
    NSLog(@"id: %@", obj);
}

__attribute__((overloadable))
static void logAnything(int number) {
    NSLog(@"int: %@", @(number));
}

__attribute__((overloadable))
static void logAnything(CGRect rect) {
    NSLog(@"CGRect: %@", NSStringFromCGRect(rect));
}

@interface Tests_overloadable : XCTestCase

@end

@implementation Tests_overloadable

- (void)test_overloadable {
    logAnything(@[@"1", @"2"]);
    logAnything(233);
    logAnything(CGRectMake(1, 2, 3, 4));
}

@end
