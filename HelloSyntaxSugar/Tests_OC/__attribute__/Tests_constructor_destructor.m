//
//  Tests_constructor_destructor.m
//  Tests_OC
//
//  Created by wesley_chen on 2021/2/15.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

__attribute__((constructor))
static void beforeMain(void) {
    NSLog(@"test_constructor_destructor: beforeMain");
}

__attribute__((destructor))
static void afterMain(void) {
    NSLog(@"test_constructor_destructor: afterMain");
}

@interface Tests_constructor_destructor : XCTestCase

@end

@implementation Tests_constructor_destructor

- (void)test_constructor_destructor {
    // Note: empty on purpose
}

@end
