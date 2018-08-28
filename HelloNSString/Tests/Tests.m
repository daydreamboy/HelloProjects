//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2018/5/30.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCStringTool.h"

@interface Tests : XCTestCase
@end

@implementation Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)test_CGRectNull {
    NSValue *value = [NSValue valueWithCGRect:CGRectNull];
    NSLog(@"%@", value);
    
    CGRect rect = [value CGRectValue];
    if (CGRectIsNull(rect)) {
        NSLog(@"null rect");
    }
    else {
        NSLog(@"rect: %@", NSStringFromCGRect(rect));
    }
}

- (void)test_CGRectFromString {
    NSString *str;
    CGRect rect;
    
    str = @"{{1,2},{3,4}";
    rect = CGRectFromString(str);
    NSLog(@"rect: %@", NSStringFromCGRect(rect));
    
    str = @"{{1,2},{3,4}}";
    rect = CGRectFromString(str);
    NSLog(@"rect: %@", NSStringFromCGRect(rect));
    
    str = @"{{5,  6}, {7, 8}}";
    rect = CGRectFromString(str);
    NSLog(@"rect: %@", NSStringFromCGRect(rect));
}

- (void)test_rectFromString {
    NSString *str;
    
    // Case 1
    str = @"{{0,0 } , {0,0}}";
    XCTAssertTrue(CGRectEqualToRect([WCStringTool rectFromString:str], CGRectZero));
    
    // Case 2
    str = @"{{1,2},{3,4}}";
    XCTAssertTrue(CGRectEqualToRect([WCStringTool rectFromString:str], CGRectFromString(str)));
    
    // Case 3
    str = @"{{5,  6}   , {7, 8}}";
    XCTAssertTrue(CGRectEqualToRect([WCStringTool rectFromString:str], CGRectFromString(str)));
    
    // Abnormal Case 1
    str = @"{{1,2},{3,4}";
    XCTAssertTrue(CGRectEqualToRect([WCStringTool rectFromString:str], CGRectNull));
    XCTAssertTrue(CGRectIsNull([WCStringTool rectFromString:str]));
    
    // Abnormal Case 2: not allow 0.0, instead of just using 0.
    str = @"{{0.0,0.0},{0.0,0.0}";
    XCTAssertFalse(CGRectEqualToRect([WCStringTool rectFromString:str], CGRectZero));
    XCTAssertTrue(CGRectIsNull([WCStringTool rectFromString:str]));
}

- (void)test_UIEdgeInsetsFromString {
    NSString *str;
    
    // Case 1
    str = @"{1,2,3,4}";
    XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets([WCStringTool edgeInsetsValueFromString:str].UIEdgeInsetsValue, UIEdgeInsetsMake(1, 2, 3, 4)));
    
    // Case 2
    str = @"{0,0,0,0}";
    XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets([WCStringTool edgeInsetsValueFromString:str].UIEdgeInsetsValue, UIEdgeInsetsZero));
    
    // Case 3
    str = @"{1.1,2.2,3.3,4.4}";
    XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets([WCStringTool edgeInsetsValueFromString:str].UIEdgeInsetsValue, UIEdgeInsetsMake(1.1, 2.2, 3.3, 4.4)));
    
    // Case 3
    str = @"{1.1,2.2,3.3,4.4}";
    XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets([WCStringTool edgeInsetsValueFromString:str].UIEdgeInsetsValue, UIEdgeInsetsFromString(str)));
    
    // Abnornam Case 1
    str = @"{0.0,0,0,0}";
    XCTAssertNil([WCStringTool edgeInsetsValueFromString:str]);
    
    // Abnornam Case 2
    str = @"{{1,2},{3,4}}";
    XCTAssertNil([WCStringTool edgeInsetsValueFromString:str]);
}

- (void)test_urlKeyValuePairsWithString {
    NSString *string;
    NSDictionary *dict;
    
    string = @"wangx://ut/card?page=Page_Message&event=2101&arg1=&arg2=&arg3=&flags=k1,k2,k3&cardtype=1001";
    dict = [WCStringTool keyValuePairsWithUrlString:string];
    NSLog(@"%@", dict);
    
    string = @"page=Page_Message&event=2101&arg1=&arg2=&arg3=&flags=k1,k2,k3&cardtype=1001";
    dict = [WCStringTool keyValuePairsWithUrlString:string];
    XCTAssertTrue(dict.count == 0);
}

- (void)test_valueWithUrlString_forKey {
    NSString *string;
    NSString *value;
    
    string = @"https://qngateway.taobao.com/gw/wwjs/multi.resource.emoticon.query?id=144";
    value = [WCStringTool valueWithUrlString:string forKey:@"id"];
    XCTAssertEqualObjects(value, @"144");
}

- (void)test_componentsWithString_delimeters {
    NSString *string;
    NSArray *components;
    
    // Case 1
    string = @"This is a test string, and should split into multiple parts by multiple delimeters.";
    components = [WCStringTool componentsWithString:string delimeters:@[@"and", @"multiple", @"a"]];
    for (NSString *part in components) {
        NSLog(@"`%@`", part);
    }
    NSLog(@"---------------------------------");
    
    // Case 2
    string = @"This is a test string, and should split into multiple parts by multiple delimeters.";
    components = [WCStringTool componentsWithString:string delimeters:@[@"multiple", @"a", @"and"]];
    for (NSString *part in components) {
        NSLog(@"`%@`", part);
    }
    NSLog(@"---------------------------------");
}

#pragma mark - Handle String As JSON

#pragma mark > JSON String to id/NSArray/NSDictionary

- (void)test_jsonObject {
    NSString *jsonDictString = @"{\"result_code\":\"9999\",\"message\":\"ok\",\"conf\":{\"d\":\"E9F8EE6FA52D548711BA59DEFABD948C\",\"switch\":\"1\",\"issync\":\"1\",\"mode\":\"2\",\"infoSwitch\":\"0\"}}";
    NSDictionary *dict = [WCStringTool JSONObjectWithString:jsonDictString];
    XCTAssertTrue([dict isKindOfClass:[NSDictionary class]]);
    
    NSString *jsonArrayString = @"[{\"id\": \"1\", \"name\":\"Aaa\"}, {\"id\": \"2\", \"name\":\"Bbb\"}]";
    NSArray *arr = [WCStringTool JSONObjectWithString:jsonArrayString];
    XCTAssertTrue([arr isKindOfClass:[NSArray class]]);
    
    NSString *plainString = @"hello, world]";
    id jsonObject = [WCStringTool JSONObjectWithString:plainString];
    XCTAssertNil(jsonObject);
}

- (void)test_jsonDict {
    NSString *jsonDictString = @"{\"result_code\":\"9999\",\"message\":\"ok\",\"conf\":{\"d\":\"E9F8EE6FA52D548711BA59DEFABD948C\",\"switch\":\"1\",\"issync\":\"1\",\"mode\":\"2\",\"infoSwitch\":\"0\"}}";
    NSDictionary *dict = [WCStringTool JSONDictWithString:jsonDictString];
    XCTAssert([dict isKindOfClass:[NSDictionary class]], @"%@ should be NSDictionary", dict);
    
    NSLog(@"%@", [dict valueForKeyPath:@"result_code"]);
    NSLog(@"%@", [dict valueForKeyPath:@"conf.infoSwitch"]);
    
    NSString *jsonArrayString = @"[{\"id\": \"1\", \"name\":\"Aaa\"}, {\"id\": \"2\", \"name\":\"Bbb\"}]";
    NSDictionary *fakeDict = [WCStringTool JSONDictWithString:jsonArrayString];
    XCTAssertNil(fakeDict, @"%@ should be nil", fakeDict);
    
    XCTAssertEqualObjects(@(1), [WCStringTool JSONDictWithString:@"{\"\":true}"][@""]);
    XCTAssertEqualObjects(@(0), [WCStringTool JSONDictWithString:@"{\"\":false}"][@""]);
    XCTAssertEqualObjects([NSNull null], [WCStringTool JSONDictWithString:@"{\"\":null}"][@""]);
}

- (void)test_jsonArray {
    NSString *jsonArrayString = @"[{\"id\": \"1\", \"name\":\"Aaa\"}, {\"id\": \"2\", \"name\":\"Bbb\"}]";
    NSArray *arr = [WCStringTool JSONArrayWithString:jsonArrayString];
    XCTAssert([arr isKindOfClass:[NSArray class]], @"%@ should be NSArray", arr);
    
    NSString *jsonDictString = @"{\"result_code\":\"9999\",\"message\":\"ok\",\"conf\":{\"d\":\"E9F8EE6FA52D548711BA59DEFABD948C\",\"switch\":\"1\",\"issync\":\"1\",\"mode\":\"2\",\"infoSwitch\":\"0\"}}";
    NSArray *fakedArr =  [WCStringTool JSONArrayWithString:jsonDictString];
    XCTAssertNil(fakedArr, @"%@ should be nil", fakedArr);
}

#pragma mark - Handle String As Plain

#pragma mark > URL Encode/Decode

- (void)test_URLEscapeStringWithString {
    NSString *originalString;
    NSString *encodedString;
    NSString *decodedString;
    
    // Case 1
    originalString = @"https://h5.m.taobao.com/istore-coupon/detail/index.html?seller_id=2649119619&coupon_id=486841666328&spm=a2141.8336399.3095317.2-0";
    encodedString = [WCStringTool URLEscapeStringWithString:originalString];
    decodedString = [WCStringTool URLUnescapeStringWithString:encodedString];
    
    NSLog(@"%@", encodedString);
    NSLog(@"%@", [originalString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]);
    NSLog(@"%@", decodedString);
    XCTAssertEqualObjects(originalString, decodedString);
    NSLog(@"-----------------------");
    
    // Case 2
    originalString = @"👴🏻👮🏽";
    encodedString = [WCStringTool URLEscapeStringWithString:originalString];
    decodedString = [WCStringTool URLUnescapeStringWithString:encodedString];
    
    NSLog(@"%@", encodedString);
    NSLog(@"%@", [originalString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]);
    NSLog(@"%@", decodedString);
    XCTAssertEqualObjects(originalString, decodedString);
    NSLog(@"-----------------------");
    
    // Case 3
    //  @sa https://en.wikipedia.org/wiki/Percent-encoding
    //  @sa online tool: http://meyerweb.com/eric/tools/dencoder/
    //
    // Test unescape characters [].
    XCTAssertEqualObjects([WCStringTool URLEscapeStringWithString:@"["], @"[");
    XCTAssertEqualObjects([WCStringTool URLEscapeStringWithString:@"]"], @"]");
    XCTAssertEqualObjects([WCStringTool URLEscapeStringWithString:@"."], @".");
    
    // Test escape characters :/?&=;+!@#$()',*
    XCTAssertEqualObjects([WCStringTool URLEscapeStringWithString:@":"], @"%3A");
    XCTAssertEqualObjects([WCStringTool URLEscapeStringWithString:@"/"], @"%2F");
    XCTAssertEqualObjects([WCStringTool URLEscapeStringWithString:@"?"], @"%3F");
    XCTAssertEqualObjects([WCStringTool URLEscapeStringWithString:@"&"], @"%26");
    XCTAssertEqualObjects([WCStringTool URLEscapeStringWithString:@"="], @"%3D");
    XCTAssertEqualObjects([WCStringTool URLEscapeStringWithString:@";"], @"%3B");
    XCTAssertEqualObjects([WCStringTool URLEscapeStringWithString:@"+"], @"%2B");
    XCTAssertEqualObjects([WCStringTool URLEscapeStringWithString:@"!"], @"%21");
    XCTAssertEqualObjects([WCStringTool URLEscapeStringWithString:@"@"], @"%40");
    XCTAssertEqualObjects([WCStringTool URLEscapeStringWithString:@"#"], @"%23");
    XCTAssertEqualObjects([WCStringTool URLEscapeStringWithString:@"$"], @"%24");
    XCTAssertEqualObjects([WCStringTool URLEscapeStringWithString:@"("], @"%28");
    XCTAssertEqualObjects([WCStringTool URLEscapeStringWithString:@")"], @"%29");
    XCTAssertEqualObjects([WCStringTool URLEscapeStringWithString:@"'"], @"%27");
    XCTAssertEqualObjects([WCStringTool URLEscapeStringWithString:@","], @"%2C");
    XCTAssertEqualObjects([WCStringTool URLEscapeStringWithString:@"*"], @"%2A");
    
    // Letters and numbers
    XCTAssertEqualObjects([WCStringTool URLEscapeStringWithString:@"a"], @"a");
    XCTAssertEqualObjects([WCStringTool URLEscapeStringWithString:@"Z"], @"Z");
    XCTAssertEqualObjects([WCStringTool URLEscapeStringWithString:@"0"], @"0");
    XCTAssertEqualObjects([WCStringTool URLEscapeStringWithString:@"1234567890"], @"1234567890");
    
    // Non-ASCII characters
    XCTAssertEqualObjects([WCStringTool URLEscapeStringWithString:@"中文"], @"%E4%B8%AD%E6%96%87");
}

- (void)test_URLUnescapeStringWithString {
    XCTAssertEqualObjects([WCStringTool URLUnescapeStringWithString:@"%E5%88%B7%E6%96%B0%E8%BF%87%E4%BA%8E%E9%A2%91%E7%B9%81%EF%BC%8C%E8%AF%B7%E7%A8%8D%E5%90%8E%E5%86%8D%E8%AF%95"], @"刷新过于频繁，请稍后再试");
}

- (void)test_substringWithString_atLocation_length {
    NSString *str1 = @"2014-11-07 18:36:04";
    
    XCTAssertEqualObjects(@"11-07", [WCStringTool substringWithString:str1 atLocation:5 length:5]);
    XCTAssertEqualObjects(@"18:36:04", [WCStringTool substringWithString:str1 atLocation:11 length:NSUIntegerMax]);
    XCTAssertEqualObjects(@"4", [WCStringTool substringWithString:str1 atLocation:str1.length - 1 length:1]);
    XCTAssertEqualObjects(@"4", [WCStringTool substringWithString:str1 atLocation:str1.length - 1 length:4]);
    XCTAssertEqualObjects(@"", [WCStringTool substringWithString:@"abc" atLocation:0 length:0]);
    XCTAssertEqualObjects(@"a", [WCStringTool substringWithString:@"abc" atLocation:0 length:1]);
    
    XCTAssertNil([WCStringTool substringWithString:str1 atLocation:str1.length length:1]);
    XCTAssertNil([WCStringTool substringWithString:@"" atLocation:0 length:1]);
    XCTAssertNil([WCStringTool substringWithString:@"" atLocation:0 length:0]);
    NSString *nilString = nil;
    XCTAssertNil([WCStringTool substringWithString:nilString atLocation:0 length:1]);
}

- (void)test_firstSubstringWithString_substringInCharacterSet {
    NSString *originalString;
    NSString *substring;
    
    // case 1
    originalString = @"*_?.幸运号This's my string：01234adbc5678";
    substring = [WCStringTool firstSubstringWithString:originalString substringInCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
    XCTAssertEqualObjects(substring, @"01234");
    
    // case 2
    originalString = @"*_?.This's my string.";
    substring = [WCStringTool firstSubstringWithString:originalString substringInCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]];
    XCTAssertNil(substring);
}

@end








