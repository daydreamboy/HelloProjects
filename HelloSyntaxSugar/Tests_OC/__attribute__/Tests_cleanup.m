//
//  Tests_cleanup.m
//  Tests_OC
//
//  Created by wesley_chen on 2021/2/19.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

static void stringCleanUp(__strong NSString **string) {
    NSLog(@"%@", *string);
}

@interface Tests_cleanup : XCTestCase

@end

@implementation Tests_cleanup

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_cleanup {
    // 在某个方法中：
    {
        __strong NSString *string __attribute__((cleanup(stringCleanUp))) = @"sunnyxx";
    } // 当运行到这个作用域结束时，自动调用stringCleanUp
}

@end
