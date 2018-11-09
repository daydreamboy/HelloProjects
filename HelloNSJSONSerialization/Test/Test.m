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

#define STR_OF_JSON(...) @#__VA_ARGS__

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
    NSArray *arr;
    NSDictionary *dict;
    NSString *JSONString;
    
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
    
    arr = @[ [NSNull null], @"null" ];
    XCTAssertEqualObjects([WCJSONTool JSONStringWithObject:arr printOptions:kNilOptions], @"[null,\"null\"]");
    
    // Case 5
    dict = @{ @"null": [NSNull null] };
    XCTAssertEqualObjects([WCJSONTool JSONStringWithObject:dict printOptions:kNilOptions], @"{\"null\":null}");
    
    // Case 6
    arr = @[ @"1", @"hello", @"", @(3.14) ];
    JSONString = [WCJSONTool JSONStringWithObject:arr printOptions:kNilOptions];
    XCTAssertNotNil(JSONString);
    NSLog(@"plain json of array: %@", JSONString);
    
    // Case 7
    arr = @[ @"1", @"hello", @"" ];
    JSONString = [WCJSONTool JSONStringWithObject:arr printOptions:kNilOptions];
    XCTAssertEqualObjects(JSONString, @"[\"1\",\"hello\",\"\"]");
    
    // Case 8
    NSMutableArray *arrM = [[NSMutableArray alloc] initWithArray:arr];
    NSLog(@"readable json of array: \n%@", [WCJSONTool JSONStringWithObject:arrM printOptions:NSJSONWritingPrettyPrinted]);
    
    // case 1: normal
    dict = @{
             @"str": @"valueOfStr",
             @"url": @"http://www.baidu.com/",
             @"num": @(3.14),
             //@(1) : @(YES), // Error occurred in jsong parsing
             @"key": @"中文汉字"
             };
    JSONString = [WCJSONTool JSONStringWithObject:dict printOptions:kNilOptions];
    NSLog(@"plain json of dictionary: %@", JSONString);
    
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
    JSONString = [WCJSONTool JSONStringWithObject:mutableDict printOptions:NSJSONWritingPrettyPrinted];
    NSLog(@"readable json of dictionary: \n%@", JSONString);
    
    NSLog(@"===========================================");
    // case 2: invalid json
    dict = @{
             @"now": [NSDate date],
             };
    JSONString = [WCJSONTool JSONStringWithObject:dict printOptions:kNilOptions];
    XCTAssertNil(JSONString);
    
    NSLog(@"===========================================");
    // case 3: invalid json
    dict = @{
             @(1) : @(YES), // Error occurred in jsong parsing
             };
    JSONString = [WCJSONTool JSONStringWithObject:dict printOptions:kNilOptions];
    XCTAssertNil(JSONString);
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

- (void)test_JSONMutableDictWithString {
    NSDictionary *dict;
    NSString *jsonString;
    NSMutableDictionary *dictM;
    
    // Case 1: normal
    dict = @{
             @"str": @"valueOfStr",
             @"url": @"http://www.baidu.com/",
             @"num": @(3.14),
             @"key": @"中文汉字"
             };
    jsonString = [WCJSONTool JSONStringWithObject:dict printOptions:kNilOptions];
    dictM = [WCJSONTool JSONMutableDictWithString:jsonString];
    XCTAssertTrue([dictM isKindOfClass:[NSMutableDictionary class]]);
    NSLog(@"mutuable dictionary: %@", dictM);
    
    
    // Case 2
    jsonString = STR_OF_JSON(
                             {"api":"mtop.taobao.amp2.im.msgAction","v":"1.0","needecode":true,"needsession":true,"params":{"sessionViewId":"0_U_1956212549#3_2554606548#3_1_1956212549#3","msgCode":"0_U_2554606548_1956212549_1539096778077_185571796986","map":{"op":"like"}}}
                             );
    
    dictM = [WCJSONTool JSONMutableDictWithString:jsonString];
    XCTAssertTrue([dictM isKindOfClass:[NSMutableDictionary class]]);
    NSLog(@"mutuable dictionary: %@", dictM);
}

- (void)test_JSONEscapedStringWithString {
    NSString *string;
    NSString *outputString;
    
    // Case 1
    string = @"It's \"Tom\".\n"; // the original string is `It's "Tom".\n` in memory
    XCTAssertEqualObjects([WCJSONTool JSONEscapedStringWithString:string], @"It's \\\"Tom\\\".\\n");
    
    // Case 2: string must escaped when filled in JSON string node
    string = @"wangx://menu/present/template?container=dialog&body={\"template\":{\"data\":{\"text\":\"http://www.taobao.com\"},\"id\":20001},\"header\":{\"title\":\"标题\"}}";
    
    NSString *JSONString = [NSString stringWithFormat:@"{\"action\": \"%@\" }", [WCJSONTool JSONEscapedStringWithString:string]];
    NSDictionary *dict = [WCJSONTool JSONDictWithString:JSONString];
    XCTAssertEqualObjects(dict[@"action"], string);
    
    // Case 3
    string = STR_OF_JSON(
                         [
                          {
                              "title": "这是标题1这是标题1这是标题1这是标题1这是标题1这是标题1这是标题1这是标题1",
                              "action": "wangwang://p2pconversation/sendText?text=dGhpcyBpcyBhIGV4YW1wbGU=&toLongId=Y250YW9iYW9rYW5nYXJvbzg1NjcyMTU=&asLocal=0"
                          },
                          {
                              "title": "这是标题2",
                              "action": "wangwang://p2pconversation/sendText?text=dGhpcyBpcyBhIGV4YW1wbGU=&toLongId=Y250YW9iYW9rYW5nYXJvbzg1NjcyMTU=&asLocal=1&asReceiver=1"
                          }
                          ]
    );
    outputString = [WCJSONTool JSONEscapedStringWithString:string];
    NSLog(@"%@", outputString);
}

#pragma mark - 

- (void)test_nil {
    @try {
        NSAssert(NO, @"test");
    }
    @catch (NSException *e) {
        NSLog(@"%@", e);
    }
}

@end
