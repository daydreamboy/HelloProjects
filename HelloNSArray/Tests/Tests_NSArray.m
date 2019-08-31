//
//  Tests_NSArray.m
//  Tests
//
//  Created by wesley_chen on 2019/1/4.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_NSArray : XCTestCase

@end

@implementation Tests_NSArray

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_valueForKey {
    NSArray *arr;
    NSArray *output;
    NSArray *expected;
    
    // Case 1
    arr = @[
            @{
                @"key": @"value1",
                },
            @{
                @"key": @"value2",
                },
            @{
                @"key": @"value3",
                },
            @{
                @"key": @"value4",
                },
            @{
                @"key": @"value5",
                },
            ];
    
    output = [arr valueForKey:@"key"];
    expected = @[
                 @"value1",
                 @"value2",
                 @"value3",
                 @"value4",
                 @"value5"
                 ];
    XCTAssertEqualObjects(output, expected);
}


- (void)test_NSMutableArray {
    NSMutableArray *arrM;
    
    // Case 1
    arrM = [NSMutableArray arrayWithCapacity:3];
    arrM[1] = @"1";
    NSLog(@"%@", arrM);
    //XCTAssertEqualObjects(output, expected);
}

@end
