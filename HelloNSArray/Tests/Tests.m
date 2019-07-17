//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2018/12/4.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCArrayTool.h"
#import "Person.h"

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

#pragma mark - Modification

- (void)test_moveObjectWithArray_fromIndex_toIndex {
    NSArray *array;
    NSArray *output;
    NSArray *expected;
    
    // Case 1
    output = [WCArrayTool moveObjectWithArray:array fromIndex:0 toIndex:0];
    XCTAssertNil(output);
    
    // Case 2
    array = @[ @1, @2, @3, @4 ];
    output = [WCArrayTool moveObjectWithArray:array fromIndex:0 toIndex:0];
    XCTAssertEqualObjects(output, array);
    
    // Case 3
    array =  @[ @1, @2, @3, @4 ];
    output = [WCArrayTool moveObjectWithArray:array fromIndex:0 toIndex:3];
    expected =  @[ @2, @3, @4, @1 ];
    XCTAssertEqualObjects(output, expected);
    
    // Case 4
    array =  @[ @1, @2, @3, @4 ];
    output = [WCArrayTool moveObjectWithArray:array fromIndex:3 toIndex:0];
    expected = @[ @4, @1, @2, @3 ];
    XCTAssertEqualObjects(output, expected);
    
    // Case 5
    array =  @[ @1, @2, @3, @4 ];
    output = [WCArrayTool moveObjectWithArray:array fromIndex:3 toIndex:2];
    expected = @[ @1, @2, @4, @3 ];
    XCTAssertEqualObjects(output, expected);
}

- (void)test_insertObjectsWithArray_objects_atIndex {
    NSArray *array;
    NSArray *output;
    NSArray *expected;
    
    // Case 1
    array = @[];
    output = [WCArrayTool insertObjectsWithArray:array objects:@[@1, @2] atIndex:0];
    expected = @[@1, @2];
    XCTAssertEqualObjects(output, expected);
    
    // Case 2
    array = @[ @3 ];
    output = [WCArrayTool insertObjectsWithArray:array objects:@[@1, @2] atIndex:0];
    expected = @[ @1, @2, @3 ];
    XCTAssertEqualObjects(output, expected);
    
    // Case 3
    array = @[ @1, @2 ];
    output = [WCArrayTool insertObjectsWithArray:array objects:@[@3] atIndex:2];
    expected = @[ @1, @2, @3 ];
    XCTAssertEqualObjects(output, expected);
    
    // Case 4
    array = @[ @1, @3 ];
    output = [WCArrayTool insertObjectsWithArray:array objects:@[@2] atIndex:1];
    expected = @[ @1, @2, @3 ];
    XCTAssertEqualObjects(output, expected);
    
    // Case 5
    array = @[ @1, @2 ];
    output = [WCArrayTool insertObjectsWithArray:array objects:@[] atIndex:1];
    expected = @[ @1, @2 ];
    XCTAssertEqualObjects(output, expected);
    
    // Abnormal Case 1
    array = @[ @1, @2 ];
    output = [WCArrayTool insertObjectsWithArray:array objects:@[@3] atIndex:3];
    expected = @[ @1, @2 ];
    XCTAssertEqualObjects(output, expected);
}

- (void)test_collapsedArrayWithArray_keyPaths {
    id item1;
    id item2;
    id item3;
    
    NSArray *uniqueArray;
    NSMutableArray *redundantArray;
    
    // Case 1:
    redundantArray = [NSMutableArray array];
    
    item1 = @"item1";
    [redundantArray addObject:item1];
    
    item2 = @"item1";
    [redundantArray addObject:item2];
    
    item3 = [item1 mutableCopy];
    [redundantArray addObject:item3];
    
    uniqueArray = [WCArrayTool collapsedArrayWithArray:redundantArray keyPaths:nil];
    XCTAssertTrue(uniqueArray.count == 1);
    
    // Case 2:
    redundantArray = [NSMutableArray array];
    
    item1 = [NSString stringWithFormat:@"%@", @"item1"];
    [redundantArray addObject:item1];
    
    item2 = [NSString stringWithFormat:@"%@", @"item1"];
    [redundantArray addObject:item2];
    
    item3 = item1;
    [redundantArray addObject:item3];
    
    uniqueArray = [WCArrayTool collapsedArrayWithArray:redundantArray keyPaths:nil];
    XCTAssertTrue(uniqueArray.count == 1);
    
    // Case 3:
    redundantArray = [NSMutableArray array];
    
    item1 = [NSString stringWithFormat:@"%@", @"item1"];
    [redundantArray addObject:item1];
    
    item2 = [NSString stringWithFormat:@"%@", @"item2"];
    [redundantArray addObject:item2];
    
    item3 = item1;
    [redundantArray addObject:item3];
    
    uniqueArray = [WCArrayTool collapsedArrayWithArray:redundantArray keyPaths:nil];
    XCTAssertTrue(uniqueArray.count == 2);
    
    // Case 4:
    redundantArray = [NSMutableArray array];
    
    [redundantArray addObject:@"item1"];
    [redundantArray addObject:@"item2"];
    [redundantArray addObject:[@"item1" copy]];
    
    uniqueArray = [WCArrayTool collapsedArrayWithArray:redundantArray keyPaths:nil];
    XCTAssertTrue(uniqueArray.count == 2);
    
    // Case 5
    redundantArray = [NSMutableArray array];
    [redundantArray addObject:[Person personWithFirstName:@"Lily" lastName:@"Smith" age:20]];
    [redundantArray addObject:[Person personWithFirstName:@"Lily" lastName:@"Smith" age:20]];
    [redundantArray addObject:[Person personWithFirstName:@"Lucy" lastName:@"Smith" age:22]];
    [redundantArray addObject:[Person personWithFirstName:@"Sam" lastName:@"Olivier" age:26]];
    [redundantArray addObject:[Person personWithFirstName:@"Laurence" lastName:@"Olivier" age:19]];
    [redundantArray addObject:[Person personWithFirstName:@"Lucy" lastName:@"Olivier" age:22]];
    
    uniqueArray = [WCArrayTool collapsedArrayWithArray:redundantArray keyPaths:@[ @"firstName", @"lastName", @"age" ]];
    XCTAssertTrue(uniqueArray.count == 5);
    
    uniqueArray = [WCArrayTool collapsedArrayWithArray:redundantArray keyPaths:@[ @"firstName" ]];
    XCTAssertTrue(uniqueArray.count == 4);
    
    uniqueArray = [WCArrayTool collapsedArrayWithArray:redundantArray keyPaths:@[ @"lastName" ]];
    XCTAssertTrue(uniqueArray.count == 2);
    
    uniqueArray = [WCArrayTool collapsedArrayWithArray:redundantArray keyPaths:@[ @"age" ]];
    XCTAssertTrue(uniqueArray.count == 4);
}

#pragma mark - Subarray

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

#pragma mark - Assistant Methods

- (void)test_arrayWithLetters {
    // Case 1: uppercase letters
    NSArray *uppercaseLetters = [WCArrayTool arrayWithLetters:YES];
    
    NSUInteger i = 0;
    for (char ch = 'A'; ch <= 'Z'; ch++) {
        NSString *letter = [NSString stringWithFormat:@"%c", ch];
        XCTAssertEqualObjects(uppercaseLetters[i], letter);
        i++;
    }
    
    // Case 2: lowercase letters
    NSArray *lowercaseLetters = [WCArrayTool arrayWithLetters:NO];
    
    NSUInteger j = 0;
    for (char ch = 'a'; ch <= 'z'; ch++) {
        NSString *letter = [NSString stringWithFormat:@"%c", ch];
        XCTAssertEqualObjects(lowercaseLetters[j], letter);
        j++;
    }
}

@end
