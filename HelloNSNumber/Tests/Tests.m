//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2018/9/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCNumberTool.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_WCNumberTool_factorialWithNumber {
    NSLog(@"0! = %@", [WCNumberTool factorialWithNumber:@(0)]);
    NSLog(@"1! = %@", [WCNumberTool factorialWithNumber:@(1)]);
    NSLog(@"2! = %@", [WCNumberTool factorialWithNumber:@(2)]);
    NSLog(@"3! = %@", [WCNumberTool factorialWithNumber:@(3)]);
    NSLog(@"4! = %@", [WCNumberTool factorialWithNumber:@(4)]);
    NSLog(@"5! = %@", [WCNumberTool factorialWithNumber:@(5)]);
    NSLog(@"6! = %@", [WCNumberTool factorialWithNumber:@(6)]);
    NSLog(@"7! = %@", [WCNumberTool factorialWithNumber:@(7)]);
    NSLog(@"8! = %@", [WCNumberTool factorialWithNumber:@(8)]);
}

@end
