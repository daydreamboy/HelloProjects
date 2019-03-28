//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2019/3/26.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCObjectTool.h"
#import "Thing.h"
#import "Person.h"

#define STR_OF_JSON(...) @#__VA_ARGS__

@interface Tests : XCTestCase
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) NSArray *arr;
@end

@implementation Tests

- (void)setUp {
    NSLog(@"\n");

    self.dict = @{
        @"int": @(1),
        @"float": @(3.14f),
        @"double": @(3.1425926314),
        @"bool": @(YES),
        @"dict": @{
            @"string1": @"value1",
            @"string2": @"value2",
            @"null": [NSNull null],
        },
        @"dict2": @{
            @"string1": @"value1",
            @"string2": @"value2"
        },
        @{
            @"key": @"value"
        }: @"string",
        @(YES): @(1),
        @(0): @(NO),
        [NSNull null]: @"null",
        @"empty dict": @{},
        @"中文key": @"中文value"
    };

    self.arr = @[
        @(1),
        @"string",
        @(3.14),
        @(NO),
        [NSNull null],
        @[
            @(1),
            @"string",
            @(3.14),
            @(NO),
            [NSNull null],
        ],
        self.dict,
        @""
    ];
}

- (void)tearDown {
    NSLog(@"\n");
}

#pragma mark - Test Methods

- (void)test_dumpedStringWithObject {
    NSDictionary *dict;
    NSArray *arr;
    NSString *output;
    NSString *expected;
    
    // Case 1
    dict = @{
             @"int": @(1),
             @"float": @(3.14f),
             @"double": @(3.1425926314),
             @"bool": @(YES),
             @"dict": @{
                     @"string1": @"value1",
                     @"string2": @"value2",
                     @"null": [NSNull null],
                     },
             @"dict2": @{
                     @"string1": @"value1",
                     @"string2": @"value2"
                     },
             @{
                 @"key": @"value"
             }: @"string",
             @(YES): @(1),
             @(0): @(NO),
             [NSNull null]: @"null",
             @"empty dict": @{},
             @"中文key": @"中文value"
             };
    
    output = [WCObjectTool dumpedStringWithObject:dict];
    NSLog(@"%@", output);
    expected = @R"JSON(
{
    "double" : 3.1425926314,
    "dict" : {
        "string1" : "value1",
        "string2" : "value2",
        "null" : null
    },
    "int" : 1,
    "dict2" : {
        "string1" : "value1",
        "string2" : "value2"
    },
    {
        "key" : "value"
    } : "string",
    0 : false,
    "float" : 3.14,
    "中文key" : "中文value",
    true : 1,
    null : "null",
    "empty dict" : {
        
    },
    "bool" : true
}JSON");
    XCTAssertEqualObjects(output, expected);
    
    // Case 2
    dict = @{};
    
    output = [WCObjectTool dumpedStringWithObject:dict];
    NSLog(@"%@", output);
    
    NSLog(@"===============================================\n");
    
    dict = @{
             @"special chars": @"It's \"Tom\".\n"
             };
    
    output = [WCObjectTool dumpedStringWithObject:dict];
    NSLog(@"%@", output);
}

@end
