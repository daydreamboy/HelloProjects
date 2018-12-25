//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2018/12/4.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCArrayTool.h"

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

- (void)test_arrayWithArray_moveItemAtIndex_toIndex {
    NSArray *array;
    NSArray *output;
    NSArray *expected;
    
    // Case 1
    output = [WCArrayTool arrayWithArray:array moveItemAtIndex:0 toIndex:0];
    XCTAssertNil(output);
    
    // Case 2
    array = @[ @1, @2, @3, @4 ];
    output = [WCArrayTool arrayWithArray:array moveItemAtIndex:0 toIndex:0];
    XCTAssertEqualObjects(output, array);
    
    // Case 3
    array =  @[ @1, @2, @3, @4 ];
    output = [WCArrayTool arrayWithArray:array moveItemAtIndex:0 toIndex:3];
    expected =  @[ @2, @3, @4, @1 ];
    XCTAssertEqualObjects(output, expected);
    
    // Case 4
    array =  @[ @1, @2, @3, @4 ];
    output = [WCArrayTool arrayWithArray:array moveItemAtIndex:3 toIndex:0];
    expected = @[ @4, @1, @2, @3 ];
    XCTAssertEqualObjects(output, expected);
    
    // Case 5
    array =  @[ @1, @2, @3, @4 ];
    output = [WCArrayTool arrayWithArray:array moveItemAtIndex:3 toIndex:2];
    expected = @[ @1, @2, @4, @3 ];
    XCTAssertEqualObjects(output, expected);
}

- (void)test_subarrayWithArray_range {
    NSArray *array;
    NSArray *output;
    NSArray *expected;
    
    // Case 1
    output = [WCArrayTool subarrayWithArray:array range:NSMakeRange(0, 1)];
    XCTAssertNil(output);
    
    // Case 2
    array = @[ @1, @2, @3, @4 ];
    output = [WCArrayTool subarrayWithArray:array range:NSMakeRange(0, 1)];
    expected = @[ @1 ];
    XCTAssertEqualObjects(output, expected);
    
    output = [WCArrayTool subarrayWithArray:array range:NSMakeRange(0, 5)];
    XCTAssertNil(output);
    
    output = [WCArrayTool subarrayWithArray:array range:NSMakeRange(4, 0)];
    expected = @[];
    XCTAssertEqualObjects(output, expected);
    
    output = [WCArrayTool subarrayWithArray:array range:NSMakeRange(4, 1)];
    XCTAssertNil(output);
}

- (void)test_subarrayWithArray_atLocation_length {
    NSArray *array;
    NSArray *output;
    NSArray *expected;
    
    // Case 1
    output = [WCArrayTool subarrayWithArray:array atLocation:0 length:1];
    XCTAssertNil(output);
    
    // Case 2
    array = @[ @1, @2, @3, @4 ];
    output = [WCArrayTool subarrayWithArray:array atLocation:0 length:1];
    expected = @[ @1 ];
    XCTAssertEqualObjects(output, expected);
    
    output = [WCArrayTool subarrayWithArray:array atLocation:0 length:5];
    expected = @[ @1, @2, @3, @4 ];
    XCTAssertEqualObjects(output, expected);
    
    output = [WCArrayTool subarrayWithArray:array atLocation:3 length:0];
    expected = @[];
    XCTAssertEqualObjects(output, expected);
    
    output = [WCArrayTool subarrayWithArray:array atLocation:3 length:1];
    expected = @[ @4 ];
    XCTAssertEqualObjects(output, expected);
    
    output = [WCArrayTool subarrayWithArray:array atLocation:4 length:0];
    expected = @[];
    XCTAssertEqualObjects(output, expected);
    
    output = [WCArrayTool subarrayWithArray:array atLocation:4 length:1];
    XCTAssertNil(output);
    
    output = [WCArrayTool subarrayWithArray:array atLocation:4 length:2];
    XCTAssertNil(output);
}

@end
