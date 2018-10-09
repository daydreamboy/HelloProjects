//
//  Test.m
//  Test
//
//  Created by wesley_chen on 11/02/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCJSONTool.h"

// >= `11.0`
#ifndef IOS11_OR_LATER
#define IOS11_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@interface Test : XCTestCase

@end

@implementation Test

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

#pragma mark - Object to String

- (void)test_JSONStringWithObject_printOptions {
    // Case 1
    XCTAssertEqualObjects([WCJSONTool JSONStringWithObject:@YES printOptions:kNilOptions], @"true");
    XCTAssertEqualObjects([WCJSONTool JSONStringWithObject:@NO printOptions:kNilOptions], @"false");
    XCTAssertEqualObjects([WCJSONTool JSONStringWithObject:@1 printOptions:kNilOptions], @"1");
    XCTAssertEqualObjects([WCJSONTool JSONStringWithObject:@0 printOptions:kNilOptions], @"0");
    
    if (IOS11_OR_LATER) {
        XCTAssertEqualObjects([WCJSONTool JSONStringWithObject:@3.14 printOptions:kNilOptions], @"3.1400000000000001");
        XCTAssertEqualObjects([WCJSONTool JSONStringWithObject:@(-3.14) printOptions:kNilOptions], @"-3.1400000000000001");
    }
    else {
        XCTAssertEqualObjects([WCJSONTool JSONStringWithObject:@3.14 printOptions:kNilOptions], @"3.14");
        XCTAssertEqualObjects([WCJSONTool JSONStringWithObject:@(-3.14) printOptions:kNilOptions], @"-3.14");
    }
    
    // Case 2
    XCTAssertEqualObjects([WCJSONTool JSONStringWithObject:[NSNull null] printOptions:kNilOptions], @"null");
    
    // Case 3
    XCTAssertEqualObjects([WCJSONTool JSONStringWithObject:@"null" printOptions:kNilOptions], @"null");
    
    // Case 4
    NSArray *arr;
    arr = @[ [NSNull null], @"null" ];
    XCTAssertEqualObjects([WCJSONTool JSONStringWithObject:arr printOptions:kNilOptions], @"[null,\"null\"]");
    
    // Case 5
    NSDictionary *dict;
    dict = @{ @"null": [NSNull null] };
    XCTAssertEqualObjects([WCJSONTool JSONStringWithObject:dict printOptions:kNilOptions], @"{\"null\":null}");
}

- (void)test_JSONStringWithObject_printOptions_filterInvalidObjects {
    NSArray *arr;
    NSDictionary *dict;
    
    // Case 1
    arr = @[ [NSDate date], @"1" ];
    XCTAssertEqualObjects([WCJSONTool JSONStringWithObject:arr printOptions:kNilOptions filterInvalidObjects:YES], @"[\"1\"]");
    
    // Case 2
    dict = @{ @(1): @"1" };
    XCTAssertEqualObjects([WCJSONTool JSONStringWithObject:dict printOptions:kNilOptions filterInvalidObjects:YES], @"{}");
    
    // Case 3
    dict = @{
             @(1): @"1",
             @"null": [NSNull null],
             @"date": [NSDate date],
             };
    XCTAssertEqualObjects([WCJSONTool JSONStringWithObject:dict printOptions:kNilOptions filterInvalidObjects:YES], @"{\"null\":null}");
}

#pragma mark -

- (void)test_NSArray_JSONString {
    NSArray *arr;
    NSString *JSONString;
    
    // Case 1
    arr = @[ @"1", @"hello", @"", @(3.14) ];
    JSONString = [WCJSONTool JSONStringWithObject:arr printOptions:kNilOptions];
    XCTAssertNotNil(JSONString);
    NSLog(@"plain json of array: %@", JSONString);
    
    // Case 2
    arr = @[ @"1", @"hello", @"" ];
    JSONString = [WCJSONTool JSONStringWithObject:arr printOptions:kNilOptions];
    XCTAssertEqualObjects(JSONString, @"[\"1\",\"hello\",\"\"]");
    
    // Case 2
    NSMutableArray *arrM = [[NSMutableArray alloc] initWithArray:arr];
    NSLog(@"readable json of array: \n%@", [WCJSONTool JSONStringWithObject:arrM printOptions:NSJSONWritingPrettyPrinted]);
}

- (void)test_NSDictionary_jsonString {
    NSDictionary *dict;
    NSString *jsonString;
    
    // case 1: normal
    dict = @{
             @"str": @"valueOfStr",
             @"url": @"http://www.baidu.com/",
             @"num": @(3.14),
             //@(1) : @(YES), // Error occurred in jsong parsing
             @"key": @"中文汉字"
             };
    jsonString = [WCJSONTool JSONStringWithObject:dict printOptions:kNilOptions];
    NSLog(@"plain json of dictionary: %@", jsonString);
    
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
    jsonString = [WCJSONTool JSONStringWithObject:mutableDict printOptions:NSJSONWritingPrettyPrinted];
    NSLog(@"readable json of dictionary: \n%@", jsonString);
    
    NSLog(@"===========================================");
    // case 2: invalid json
    dict = @{
             @"now": [NSDate date],
             };
    jsonString = [WCJSONTool JSONStringWithObject:dict printOptions:kNilOptions];
    XCTAssertNil(jsonString);
    
    NSLog(@"===========================================");
    // case 3: invalid json
    dict = @{
             @(1) : @(YES), // Error occurred in jsong parsing
             };
    jsonString = [WCJSONTool JSONStringWithObject:dict printOptions:kNilOptions];
    XCTAssertNil(jsonString);
}

- (void)test_WCJSONTool_mutableDictionaryWithJSONString {
    NSDictionary *dict;
    NSString *jsonString;
    
    // case 1: normal
    dict = @{
             @"str": @"valueOfStr",
             @"url": @"http://www.baidu.com/",
             @"num": @(3.14),
             @"key": @"中文汉字"
             };
    jsonString = [WCJSONTool JSONStringWithObject:dict printOptions:kNilOptions];
    NSMutableDictionary *dictM = [WCJSONTool JSONMutableDictWithString:jsonString];
    XCTAssertTrue([dictM isKindOfClass:[NSMutableDictionary class]]);
    NSLog(@"mutuable dictionary: %@", dictM);
}

- (void)test_JSONEscapedStringWithString {
    NSString *string;
    
    // Case 1
    string = @"It's \"Tom\".\n"; // the original string is `It's "Tom".\n` in memory
    XCTAssertEqualObjects([WCJSONTool JSONEscapedStringWithString:string], @"It's \\\"Tom\\\".\\n");
    
    // Case 2: string must escaped when filled in JSON string node
    string = @"wangx://menu/present/template?container=dialog&body={\"template\":{\"data\":{\"text\":\"http://www.taobao.com\"},\"id\":20001},\"header\":{\"title\":\"标题\"}}";
    
    NSString *JSONString = [NSString stringWithFormat:@"{\"action\": \"%@\" }", [WCJSONTool JSONEscapedStringWithString:string]];
    NSDictionary *dict = [WCJSONTool JSONDictWithString:JSONString];
    XCTAssertEqualObjects(dict[@"action"], string);
}

- (void)test_nil {
    @try {
        NSAssert(NO, @"test");
    }
    @catch (NSException *e) {
        NSLog(@"%@", e);
    }
}

@end
