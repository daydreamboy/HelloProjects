//
//  Test.m
//  Test
//
//  Created by wesley_chen on 11/02/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCJSONTool.h"

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

- (void)test_NSArray_jsonString {
    NSArray *arr = @[ @"1", @"hello", @"", @(3.14) ];
    NSLog(@"plain json of array: %@", [arr JSONString]);
    
    NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithArray:arr];
    NSLog(@"readable json of array: \n%@", [mutableArr JSONStringWithReadability]);
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
    jsonString = [dict JSONString];
    NSLog(@"plain json of dictionary: %@", jsonString);
    
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
    jsonString = [mutableDict JSONStringWithReadability];
    NSLog(@"readable json of dictionary: \n%@", jsonString);
    
    NSLog(@"===========================================");
    // case 2: invalid json
    dict = @{
             @"now": [NSDate date],
             };
    jsonString = [dict JSONString];
    XCTAssertNil(jsonString);
    
    NSLog(@"===========================================");
    // case 3: invalid json
    dict = @{
             @(1) : @(YES), // Error occurred in jsong parsing
             };
    jsonString = [dict JSONString];
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
    jsonString = [dict JSONString];
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
