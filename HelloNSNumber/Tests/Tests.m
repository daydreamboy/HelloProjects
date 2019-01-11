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

- (void)test_checkNumberAsBooleanWithNumber {
    NSNumber *number;
    BOOL isBooleanNumber;
    
    // Case 1
    number = @1;
    isBooleanNumber = [WCNumberTool checkNumberAsBooleanWithNumber:number];
    XCTAssertFalse(isBooleanNumber);
    
    number = @0;
    isBooleanNumber = [WCNumberTool checkNumberAsBooleanWithNumber:number];
    XCTAssertFalse(isBooleanNumber);
    
    // Case 1
    number = @YES;
    isBooleanNumber = [WCNumberTool checkNumberAsBooleanWithNumber:number];
    XCTAssertTrue(isBooleanNumber);
    
    number = @(NO);
    isBooleanNumber = [WCNumberTool checkNumberAsBooleanWithNumber:number];
    XCTAssertTrue(isBooleanNumber);
    
    // Case 1
    number = @3.14;
    isBooleanNumber = [WCNumberTool checkNumberAsBooleanWithNumber:number];
    XCTAssertFalse(isBooleanNumber);
    
    // Case 1
    number = @('a');
    isBooleanNumber = [WCNumberTool checkNumberAsBooleanWithNumber:number];
    XCTAssertFalse(isBooleanNumber);
    
    number = [NSNumber numberWithChar:'b'];
    isBooleanNumber = [WCNumberTool checkNumberAsBooleanWithNumber:number];
    XCTAssertFalse(isBooleanNumber);
}

@end
