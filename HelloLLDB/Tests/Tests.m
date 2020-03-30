//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2020/3/30.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCLLDBTool.h"
#import "Person.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_stringWithFormat_arg1_arg2_arg3_arg4_arg5 {
    id output;
    
    // Case 1
    output = [WCLLDBTool stringWithFormat:@"%@" arg1:@"abc"];
    XCTAssertEqualObjects(output, @"abc");
    
    // Case 2
    output = [WCLLDBTool stringWithFormat:@"%@ %@ %@" arg1:@"a" arg2:@"b" arg3:@"c"];
    XCTAssertEqualObjects(output, @"a b c");
}

- (void)test_filterArray_usingPredicateString_arg1_arg2_arg3_arg4_arg5 {
    NSArray * output;
    NSArray *array;
    
    array = @[
        [Person personWithName:@"Alice" age:15],
        [Person personWithName:@"Bob" age:20],
        [Person personWithName:@"Jane" age:15],
        [Person personWithName:@"Lily" age:16],
        [Person personWithName:@"Lucy" age:10],
    ];
    
    // Case 1
    output = [WCLLDBTool filterArray:array usingPredicateString:@"age == 10"];
    XCTAssert(output.count == 1);
    
    // Case 2
    output = [WCLLDBTool filterArray:array usingPredicateString:@"name LIKE 'L*'"];
    XCTAssert(output.count == 2);
    
    // Case 3
    output = [WCLLDBTool filterArray:array usingPredicateString:@"name LIKE %@" arg1:@"Bob"];
    XCTAssert(output.count == 1);
    XCTAssertEqualObjects([[output firstObject] valueForKey:@"name"], @"Bob");
    
    // Abnormal Case 1
    output = [WCLLDBTool filterArray:array usingPredicateString:@"name LIKE L*"]; // an exception occur
    XCTAssertNil(output);
    XCTAssert(output.count == 0);
}


@end
