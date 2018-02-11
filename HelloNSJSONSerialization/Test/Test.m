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

- (void)test_NSArray_ssonString {
    NSArray *arr = @[ @"1", @"hello", @"", @(3.14) ];
    NSLog(@"plain json of array: %@", [arr jsonString]);
    
    NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithArray:arr];
    NSLog(@"readable json of array: \n%@", [mutableArr jsonStringWithReadability]);
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
    jsonString = [dict jsonString];
    NSLog(@"plain json of dictionary: %@", jsonString);
    
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
    jsonString = [mutableDict jsonStringWithReadability];
    NSLog(@"readable json of dictionary: \n%@", jsonString);
    
    NSLog(@"===========================================");
    // case 2: invalid json
    dict = @{
             @"now": [NSDate date],
             };
    jsonString = [dict jsonString];
    XCTAssertNil(jsonString);
    
    NSLog(@"===========================================");
    // case 3: invalid json
    dict = @{
             @(1) : @(YES), // Error occurred in jsong parsing
             };
    jsonString = [dict jsonString];
    XCTAssertNil(jsonString);
}

- (void)test_WCJSONTool {
    NSDictionary *dict;
    NSString *jsonString;
    
    // case 1: normal
    dict = @{
             @"str": @"valueOfStr",
             @"url": @"http://www.baidu.com/",
             @"num": @(3.14),
             @"key": @"中文汉字"
             };
    jsonString = [dict jsonString];
    NSMutableDictionary *dictM = [WCJSONTool mutableDictionaryWithJSONString:jsonString];
    XCTAssertTrue([dictM isKindOfClass:[NSMutableDictionary class]]);
    NSLog(@"mutuable dictionary: %@", dictM);
}

@end
