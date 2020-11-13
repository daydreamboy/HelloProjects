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


#define UICOLOR_R_COLOR(color) (((color) >> 24) & 0xFF)
#define UICOLOR_G_COLOR(color) (((color) >> 16) & 0xFF)
#define UICOLOR_B_COLOR(color) (((color) >> 8) & 0xFF)
#define UICOLOR_A_COLOR(color) ((color) & 0xFF)

#ifndef UICOLOR_RGBA
#define UICOLOR_RGBA(color) ([UIColor colorWithRed: (((color) >> 24) & 0xFF) / 255.0 green: (((color) >> 16) & 0xFF) / 255.0 blue: (((color) >> 8) & 0xFF) / 255.0 alpha: ((color) & 0xFF) / 255.0])
#endif

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

#pragma mark - String

- (void)test_stringWithFormat_arg1_arg2_arg3_arg4_arg5 {
    id output;
    
    // Case 1
    output = [WCLLDBTool stringWithFormat:@"%@" arg1:@"abc"];
    XCTAssertEqualObjects(output, @"abc");
    
    // Case 2
    output = [WCLLDBTool stringWithFormat:@"%@ %@ %@" arg1:@"a" arg2:@"b" arg3:@"c"];
    XCTAssertEqualObjects(output, @"a b c");
}

- (void)test_dumpString_outputToFileName {
    BOOL output;
    NSString *string;
    
    string = @"abc";
    output = [WCLLDBTool dumpString:string outputToFileName:nil];
    XCTAssertTrue(output);
}

- (void)test_stringWithInputFileName {
    NSString *output;
    
    output = [WCLLDBTool stringWithInputFileName:nil];
    XCTAssertTrue(output);
}

- (void)test_stringWithInputFileName_crash {
    NSString *output;
    
    @autoreleasepool {
        output = @"12345"; // Note: use `e output = (id)[WCLLDBTool stringWithInputFileName:nil]` to overwrite
        NSLog(@"%@", output);
    }
    XCTAssertTrue(output);
}

#pragma mark - Array

- (void)test_filterArray_usingPredicateString_arg1_arg2_arg3_arg4_arg5 {
    NSArray *output;
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

- (void)test_iterateArray_keyPath_outputToFileName {
    NSArray *filteredArray;
    NSArray *array;
    BOOL output;
    
    array = @[
        [Person personWithName:@"Alice" age:15],
        [Person personWithName:@"Bob" age:20],
        [Person personWithName:@"Jane" age:15],
        [Person personWithName:@"Lily" age:16],
        [Person personWithName:@"Lucy" age:10],
    ];
    
    // Case 1
    filteredArray = [WCLLDBTool filterArray:array usingPredicateString:@"name LIKE 'L*'"];
    output = [WCLLDBTool iterateArray:filteredArray keyPath:@"name" outputToFileName:nil];
    XCTAssertTrue(output);
}

#pragma mark -

- (void)test_RGBAHexStringFromUIColor {
    id output;
    UIColor *color;
    
    // Case 1
    color = UICOLOR_RGBA(0x111F2C3D);
    output = [WCLLDBTool RGBAHexStringFromUIColor:color];
    XCTAssertEqualObjects(output, @"#111F2C3D");
}

- (void)test_print_UIEdgeInsets_variable {
    UIEdgeInsets insets = UIEdgeInsetsMake(1, 2, 3, 4);
    [self callee:insets];
}

- (void)callee:(UIEdgeInsets)insets {
    NSLog(@"%@", NSStringFromUIEdgeInsets(insets)); // p *(UIEdgeInsets *)($rbp+16)
}

@end
