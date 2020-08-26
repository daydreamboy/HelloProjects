//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2018/5/30.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCStringTool.h"

#define STR_OF_JSON(...) @#__VA_ARGS__

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

- (void)test_componentsWithString_delimeters {
    NSString *string;
    NSArray *components;
    NSArray *expected;
    
    // Case 1
    string = @"This is a test string, and should split into multiple parts by multiple delimeters.";
    components = [WCStringTool componentsWithString:string delimeters:@[@"and", @"multiple", @"a"]];
    expected = @[
        @"This is ",
        @" test string, ",
        @" should split into ",
        @" p",
        @"rts by ",
        @" delimeters.",
    ];
    for (NSUInteger i = 0; i < components.count; ++i) {
        XCTAssertEqualObjects(components[i], expected[i]);
    }
    
    // Case 2
    string = @"This is a test string, and should split into multiple parts by multiple delimeters.";
    components = [WCStringTool componentsWithString:string delimeters:@[@"multiple", @"a", @"and"]];
    expected = @[
        @"This is ",
        @" test string, ",
        @"nd should split into ",
        @" p",
        @"rts by ",
        @" delimeters.",
    ];
    for (NSUInteger i = 0; i < components.count; ++i) {
        XCTAssertEqualObjects(components[i], expected[i]);
    }
    
    // Case 3
    string = @"/:^_^/:^_^/:^_^/:^_^/:^_^";
    components = [WCStringTool componentsWithString:string delimeters:@[@"/:^_^"]];
    XCTAssertTrue(components.count == 0);
    NSLog(@"%@", components);
}

- (void)test_componentsWithString_delimeters_ {
    NSString *string;
    NSArray *components;
    NSArray *expected;
    
    // Case 1
    string = @"abcsabc";
    components = [WCStringTool componentsWithString:string delimeters:@[@"s", @"b"] mode:WCStringSplitInComponentsModeIncludeDelimiter];
    expected = @[
        @"a",
        @"b",
        @"c",
        @"s",
        @"a",
        @"b",
        @"c",
    ];
    for (NSUInteger i = 0; i < components.count; ++i) {
        XCTAssertEqualObjects(components[i], expected[i]);
    }
    
    // Case 2
    string = @"abcsabc";
    components = [WCStringTool componentsWithString:string delimeters:@[@"s"] mode:WCStringSplitInComponentsModeIncludeDelimiter];
    expected = @[
        @"abc",
        @"s",
        @"abc",
    ];
    for (NSUInteger i = 0; i < components.count; ++i) {
        XCTAssertEqualObjects(components[i], expected[i]);
    }
    
    // Case 3
    string = @"abcsabc";
    components = [WCStringTool componentsWithString:string delimeters:@[@"abc", @"s"] mode:WCStringSplitInComponentsModeIncludeDelimiter];
    expected = @[
        @"abc",
        @"s",
        @"abc",
    ];
    for (NSUInteger i = 0; i < components.count; ++i) {
        XCTAssertEqualObjects(components[i], expected[i]);
    }
}

- (void)test_componentsWithString_charactersInSet_substringRangs {
    NSString *string;
    NSArray *components;
    NSMutableArray *componentRanges = [NSMutableArray array];
    NSCharacterSet *characterSet = [[self URLAllowedCharacterSet] invertedSet];
    
    // Case 1
    string = @"http://www.google.com/item.htm?id=1中文中文中文http://www.google.com/item.htm?id=2中文中文中文";
    components = [WCStringTool componentsWithString:string charactersInSet:[self URLAllowedCharacterSet] substringRangs:componentRanges];
    XCTAssertTrue(components.count == componentRanges.count);
    for (NSInteger i = 0; i < components.count; i++) {
        NSString *component = components[i];
        NSRange range = [componentRanges[i] rangeValue];
        NSString *substring = [string substringWithRange:range];
        XCTAssertEqualObjects(component, substring);
    }
    
    // Case 1
    string = @"http://www.google.com/item.htm?id=1中文中文中文http://www.google.com/item.htm?id=2中文中文中文";
    components = [WCStringTool componentsWithString:string charactersInSet:characterSet substringRangs:componentRanges];
    XCTAssertTrue(components.count == componentRanges.count);
    for (NSInteger i = 0; i < components.count; i++) {
        NSString *component = components[i];
        NSRange range = [componentRanges[i] rangeValue];
        NSString *substring = [string substringWithRange:range];
        XCTAssertEqualObjects(component, substring);
    }
    
    // Case 2
    string = @"http://www.google.com/item.htm?id=1 http://www.google.com/item.htm?id=2中文中文中文http://www.google.com/item.htm?id=%E6%B5%8B%E8%AF%95中文中文中文http://www.google.com/item.htm?id=3";
    components = [WCStringTool componentsWithString:string charactersInSet:characterSet substringRangs:componentRanges];
    XCTAssertTrue(components.count == componentRanges.count);
    for (NSInteger i = 0; i < components.count; i++) {
        NSString *component = components[i];
        NSRange range = [componentRanges[i] rangeValue];
        NSString *substring = [string substringWithRange:range];
        XCTAssertEqualObjects(component, substring);
    }
}

#pragma mark - Handle String As Text In UILabel

- (void)test_interpolatedStringWithCamelCaseString_separator {
    NSString *string;
    NSString *output;
    
    // Case 1
    string = @"ThisStringIsJoined";
    output = [WCStringTool interpolatedStringWithCamelCaseString:string separator:@" "];
    XCTAssertEqualObjects(output, @"This String Is Joined");
    
    // Case 2
    string = @"HelloHTMLGoodbye";
    output = [WCStringTool interpolatedStringWithCamelCaseString:string separator:@" "];
    XCTAssertEqualObjects(output, @"Hello HTMLGoodbye");
    
    // Case 3
    string = @"ILoveObjectiveC";
    output = [WCStringTool interpolatedStringWithCamelCaseString:string separator:@" "];
    XCTAssertEqualObjects(output, @"ILove Objective C");
    
    // Case 3
    string = @"ThisStringIsJoined";
    output = [WCStringTool interpolatedStringWithCamelCaseString:string separator:@"_"];
    XCTAssertEqualObjects(output, @"This_String_Is_Joined");
}

#pragma mark - Handle String As JSON

#pragma mark > JSON String to id/NSArray/NSDictionary
/*
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
*/

#pragma mark - Handle String As Url (for checking url strictly, use WCURLTool instead)

- (void)test_keyValuePairsWithUrlString {
    NSString *urlString;
    NSDictionary *output;
    
    // Case 1
    urlString = @"wangx://p2pconversation/sendText?toLongId=amFjaw==&text=aHR0cHM6Ly9kZXRhaWwudG1hbGwuY29tL2l0ZW0uaHRtP2lkPTU3MzY2NjQ2MDM1NSZhbGlfcmVmaWQ9YTNfNDIwNDMyXzEwMDY6MTExMDgxNzMyMjpOOiVFOSU5QiU4NiVFNiU4OCU5MCVFNyU4MSVCNjpmYzc4NjljYjZlM2M3OGU4ZjJkYjZkYjg4NTNkNzViZSZhbGlfdHJhY2tpZD0xX2ZjNzg2OWNiNmUzYzc4ZThmMmRiNmRiODg1M2Q3NWJlJnNwbT1hMjMwci4xLjE0LjE=";
    output = [WCStringTool keyValuePairsWithUrlString:urlString];
    XCTAssertTrue([output isKindOfClass:[NSDictionary class]]);
    XCTAssertEqualObjects(output[@"text"], @"aHR0cHM6Ly9kZXRhaWwudG1hbGwuY29tL2l0ZW0uaHRtP2lkPTU3MzY2NjQ2MDM1NSZhbGlfcmVmaWQ9YTNfNDIwNDMyXzEwMDY6MTExMDgxNzMyMjpOOiVFOSU5QiU4NiVFNiU4OCU5MCVFNyU4MSVCNjpmYzc4NjljYjZlM2M3OGU4ZjJkYjZkYjg4NTNkNzViZSZhbGlfdHJhY2tpZD0xX2ZjNzg2OWNiNmUzYzc4ZThmMmRiNmRiODg1M2Q3NWJlJnNwbT1hMjMwci4xLjE0LjE=");
    XCTAssertEqualObjects(output[@"toLongId"], @"amFjaw==");

    // Case 2
    urlString = @"?toLongId=amFjaw==&text=aHR0cHM6Ly9kZXRhaWwudG1hbGwuY29tL2l0ZW0uaHRtP2lkPTU3MzY2NjQ2MDM1NSZhbGlfcmVmaWQ9YTNfNDIwNDMyXzEwMDY6MTExMDgxNzMyMjpOOiVFOSU5QiU4NiVFNiU4OCU5MCVFNyU4MSVCNjpmYzc4NjljYjZlM2M3OGU4ZjJkYjZkYjg4NTNkNzViZSZhbGlfdHJhY2tpZD0xX2ZjNzg2OWNiNmUzYzc4ZThmMmRiNmRiODg1M2Q3NWJlJnNwbT1hMjMwci4xLjE0LjE=";
    output = [WCStringTool keyValuePairsWithUrlString:urlString];
    XCTAssertTrue([output isKindOfClass:[NSDictionary class]]);
    XCTAssertEqualObjects(output[@"text"], @"aHR0cHM6Ly9kZXRhaWwudG1hbGwuY29tL2l0ZW0uaHRtP2lkPTU3MzY2NjQ2MDM1NSZhbGlfcmVmaWQ9YTNfNDIwNDMyXzEwMDY6MTExMDgxNzMyMjpOOiVFOSU5QiU4NiVFNiU4OCU5MCVFNyU4MSVCNjpmYzc4NjljYjZlM2M3OGU4ZjJkYjZkYjg4NTNkNzViZSZhbGlfdHJhY2tpZD0xX2ZjNzg2OWNiNmUzYzc4ZThmMmRiNmRiODg1M2Q3NWJlJnNwbT1hMjMwci4xLjE0LjE=");
    XCTAssertEqualObjects(output[@"toLongId"], @"amFjaw==");

    // Case 3
    urlString = @"wangx://p2pconversation/sendText?abc";
    output = [WCStringTool keyValuePairsWithUrlString:urlString];
    XCTAssertTrue([output isKindOfClass:[NSDictionary class]]);
    XCTAssertTrue(output.count == 0);

    // Case 4
    urlString = @"wangx://p2pconversation/sendText";
    output = [WCStringTool keyValuePairsWithUrlString:urlString];
    XCTAssertNil(output);

    // Case 5
    urlString = @"wangx://p2pconversation/sendText?&";
    output = [WCStringTool keyValuePairsWithUrlString:urlString];
    XCTAssertTrue([output isKindOfClass:[NSDictionary class]]);
    XCTAssertTrue(output.count == 0);

    // Case 6
    urlString = @"wangx://p2pconversation/sendText?&&&";
    output = [WCStringTool keyValuePairsWithUrlString:urlString];
    XCTAssertTrue([output isKindOfClass:[NSDictionary class]]);
    XCTAssertTrue(output.count == 0);

    // Case 7
    urlString = @"abc?key1=A&key2=B";
    output = [WCStringTool keyValuePairsWithUrlString:urlString];
    XCTAssertTrue([output isKindOfClass:[NSDictionary class]]);
    XCTAssertTrue(output.count == 2);

    // Case 8
    urlString = @"abc@key1=A#key2=B";
    output = [WCStringTool keyValuePairsWithUrlString:urlString];
    XCTAssertNil(output);
    
    // Case 9
    urlString = @"https://item.taobao.com/item.htm?spm=a230r.1.14.13.63956cb9lNHIdB&id=573299987166&ns=1&abbucket=15#detail";
    output = [WCStringTool keyValuePairsWithUrlString:urlString];
    XCTAssertTrue([output isKindOfClass:[NSDictionary class]]);
    XCTAssertTrue(output.count == 4);
    XCTAssertEqualObjects(output[@"spm"], @"a230r.1.14.13.63956cb9lNHIdB");
    XCTAssertEqualObjects(output[@"id"], @"573299987166");
    XCTAssertEqualObjects(output[@"ns"], @"1");
    XCTAssertEqualObjects(output[@"abbucket"], @"15");
    
    // Case 10
    urlString = @"wangwang://p2sconversation/package?serviceType=cloud_auto_reply&toId=cntaobao顾家家居旗舰店:海恬&number=3&bizType=1&sendChatMsg=#免费3D设计#&bizId=10974940&sign=D5CEA3CFCC64B73C0A5551EDBBD6EFAE1EF8DE33A77D5B9F4DCC97FC7B6DD8B4&fromId=cntaobaowc测试账号1000&questionText=#免费3D设计#";
    output = [WCStringTool keyValuePairsWithUrlString:urlString];
    XCTAssertTrue([output isKindOfClass:[NSDictionary class]]);
    XCTAssertTrue(output.count == 9);
    XCTAssertEqualObjects(output[@"serviceType"], @"cloud_auto_reply");
    XCTAssertEqualObjects(output[@"toId"], @"cntaobao顾家家居旗舰店:海恬");
    XCTAssertEqualObjects(output[@"number"], @"3");
    XCTAssertEqualObjects(output[@"bizType"], @"1");
    XCTAssertEqualObjects(output[@"sendChatMsg"], @"#免费3D设计#");
    XCTAssertEqualObjects(output[@"sign"], @"D5CEA3CFCC64B73C0A5551EDBBD6EFAE1EF8DE33A77D5B9F4DCC97FC7B6DD8B4");
    XCTAssertEqualObjects(output[@"fromId"], @"cntaobaowc测试账号1000");
    XCTAssertEqualObjects(output[@"questionText"], @"#免费3D设计#");
    
    // Case 11
    urlString = @"wangwang://h5/open?url=https%3A//detail.tmall.com/item.htm?id%3D588030695393%26o2oGuideId%3D4112631319%26storeId%3D184261499%26buyerId%3D3488920881%26needDot%3Dfalse%26cloudstoreSource%3Ddaogou";
    output = [WCStringTool keyValuePairsWithUrlString:urlString];
    XCTAssertTrue([output isKindOfClass:[NSDictionary class]]);
    XCTAssertTrue(output.count == 1);
    XCTAssertEqualObjects(output[@"url"], @"https%3A//detail.tmall.com/item.htm?id%3D588030695393%26o2oGuideId%3D4112631319%26storeId%3D184261499%26buyerId%3D3488920881%26needDot%3Dfalse%26cloudstoreSource%3Ddaogou");
}

#pragma mark - Handle String As Plain

#pragma mark > URL Encode/Decode

- (void)test_URLEscapeStringWithString {
    NSString *originalString;
    NSString *encodedString;
    NSString *decodedString;
    
    // Case 1
    originalString = @"https://h5.m.taobao.com/istore-coupon/detail/index.html?seller_id=2649119619&coupon_id=486841666328&spm=a2141.8336399.3095317.2-0";
    encodedString = [WCStringTool URLEscapedStringWithString:originalString];
    decodedString = [WCStringTool URLUnescapedStringWithString:encodedString];
    
    NSLog(@"%@", encodedString);
    NSLog(@"%@", [originalString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]);
    NSLog(@"%@", decodedString);
    XCTAssertEqualObjects(originalString, decodedString);
    NSLog(@"-----------------------");
    
    // Case 2
    originalString = @"👴🏻👮🏽";
    encodedString = [WCStringTool URLEscapedStringWithString:originalString];
    decodedString = [WCStringTool URLUnescapedStringWithString:encodedString];
    
    NSLog(@"%@", encodedString);
    NSLog(@"%@", [originalString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]);
    NSLog(@"%@", decodedString);
    XCTAssertEqualObjects(originalString, decodedString);
    NSLog(@"-----------------------");
    
    // Case 3
    //  @sa https://en.wikipedia.org/wiki/Percent-encoding
    //  @sa online tool: http://meyerweb.com/eric/tools/dencoder/
    //
    // Test unescape characters .
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@"."], @".");
    
    // Test escape characters :/?&=;+!@#$()',*[]{}
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@":"], @"%3A");
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@"/"], @"%2F");
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@"?"], @"%3F");
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@"&"], @"%26");
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@"="], @"%3D");
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@";"], @"%3B");
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@"+"], @"%2B");
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@"!"], @"%21");
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@"@"], @"%40");
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@"#"], @"%23");
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@"$"], @"%24");
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@"("], @"%28");
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@")"], @"%29");
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@"'"], @"%27");
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@","], @"%2C");
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@"*"], @"%2A");
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@"["], @"%5B");
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@"]"], @"%5D");
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@"{"], @"%7B");
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@"}"], @"%7D");
    
    // Letters and numbers
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@"a"], @"a");
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@"Z"], @"Z");
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@"0"], @"0");
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@"1234567890"], @"1234567890");
    
    // Non-ASCII characters
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@"中文"], @"%E4%B8%AD%E6%96%87");
}

- (void)test_URLUnescapeStringWithString {
    XCTAssertEqualObjects([WCStringTool URLUnescapedStringWithString:@"%E5%88%B7%E6%96%B0%E8%BF%87%E4%BA%8E%E9%A2%91%E7%B9%81%EF%BC%8C%E8%AF%B7%E7%A8%8D%E5%90%8E%E5%86%8D%E8%AF%95"], @"刷新过于频繁，请稍后再试");
}

- (void)test_substringWithString_atLocation_length {
    // Case 1
    NSString *string;
    NSString *output;
    string = @"2014-11-07 18:36:04";
    
    XCTAssertEqualObjects(@"11-07", [WCStringTool substringWithString:string atLocation:5 length:5]);
    XCTAssertEqualObjects(@"18:36:04", [WCStringTool substringWithString:string atLocation:11 length:NSUIntegerMax]);
    XCTAssertEqualObjects(@"4", [WCStringTool substringWithString:string atLocation:string.length - 1 length:1]);
    XCTAssertEqualObjects(@"4", [WCStringTool substringWithString:string atLocation:string.length - 1 length:4]);
    XCTAssertEqualObjects(@"", [WCStringTool substringWithString:string atLocation:string.length length:1]);
    
    XCTAssertEqualObjects(@"", [WCStringTool substringWithString:@"abc" atLocation:0 length:0]);
    XCTAssertEqualObjects(@"a", [WCStringTool substringWithString:@"abc" atLocation:0 length:1]);
    XCTAssertEqualObjects(@"", [WCStringTool substringWithString:@"abc" atLocation:3 length:0]);
    XCTAssertEqualObjects(@"", [WCStringTool substringWithString:@"abc" atLocation:3 length:1]);
    XCTAssertEqualObjects(@"", [WCStringTool substringWithString:@"abc" atLocation:3 length:NSUIntegerMax]);
    XCTAssertEqualObjects(@"", [WCStringTool substringWithString:@"" atLocation:0 length:1]);
    XCTAssertEqualObjects(@"", [WCStringTool substringWithString:@"" atLocation:0 length:0]);
    
    // Case
    NSString *nilString = nil;
    XCTAssertNil([WCStringTool substringWithString:nilString atLocation:0 length:1]);
    
    // Case 2
    string = @"123";
    XCTAssertEqualObjects(@"123", [WCStringTool substringWithString:string atLocation:0 length:3]);
    XCTAssertEqualObjects(@"23", [WCStringTool substringWithString:string atLocation:1 length:2]);
    
    string = @"123";
    output = [WCStringTool substringWithString:string atLocation:0 length:4];
    XCTAssertEqualObjects(string, @"123");
}

- (void)test_substringWithString_range {
    NSString *string;
    NSString *output;
    
    // Case 1
    string = @"2014-11-07 18:36:04";
    output = [WCStringTool substringWithString:string range:NSMakeRange(5, 5)];
    XCTAssertEqualObjects(output, @"11-07");
    
    output = [WCStringTool substringWithString:string range:NSMakeRange(string.length - 1, 1)];
    XCTAssertEqualObjects(output, @"4");
    
    output = [WCStringTool substringWithString:string range:NSMakeRange(string.length - 1, 4)];
    XCTAssertNil(output);
    
    output = [WCStringTool substringWithString:string range:NSMakeRange(string.length, 1)];
    XCTAssertNil(output);
    
    // Case 2
    string = @"abc";
    output = [WCStringTool substringWithString:string range:NSMakeRange(0, 1)];
    XCTAssertEqualObjects(output, @"a");
    
    // Abnormal Case 1
    output = [WCStringTool substringWithString:string range:NSMakeRange(0, 4)];
    XCTAssertNil(output);
    
    output = [WCStringTool substringWithString:string range:NSMakeRange(3, 0)];
    XCTAssertEqualObjects(output, @"");
    
    output = [WCStringTool substringWithString:string range:NSMakeRange(3, 1)];
    XCTAssertNil(output);
    
    output = [WCStringTool substringWithString:string range:NSMakeRange(0, 0)];
    XCTAssertEqualObjects(output, @"");
    
    output = [string substringWithRange:NSMakeRange(0, 0)];
    XCTAssertEqualObjects(output, @"");
    
    // Case 3
    string = @"";
    output = [WCStringTool substringWithString:string range:NSMakeRange(0, 1)];
    XCTAssertNil(output);
    
    output = [WCStringTool substringWithString:string range:NSMakeRange(0, 0)];
    XCTAssertEqualObjects(output, @"");
    
    output = [WCStringTool substringWithString:string range:NSMakeRange(1, 0)];
    XCTAssertNil(output);

    output = [string substringWithRange:NSMakeRange(0, 0)];
    XCTAssertEqualObjects(output, @"");
    
    // Case 4
    string = nil;
    output = [WCStringTool substringWithString:string range:NSMakeRange(0, 1)];
    XCTAssertNil(output);

    output = [WCStringTool substringWithString:string range:NSMakeRange(0, 0)];
    XCTAssertNil(output);
    
    // Case 5
    string = @"123";
    output = [WCStringTool substringWithString:string range:NSMakeRange(2, 0)];
    XCTAssertEqualObjects(output, @"");

    output = [string substringWithRange:NSMakeRange(3, 0)];
    XCTAssertEqualObjects(output, @"");

    output = [WCStringTool substringWithString:string range:NSMakeRange(3, 1)];
    XCTAssertNil(output);

    output = [WCStringTool substringWithString:string range:NSMakeRange(4, 0)];
    XCTAssertNil(output);

    output = [WCStringTool substringWithString:string range:NSMakeRange(3, NSUIntegerMax)];
    XCTAssertNil(output);
    
    output = [WCStringTool substringWithString:string range:NSMakeRange(NSUIntegerMax, 3)];
    XCTAssertNil(output);
    
    output = [WCStringTool substringWithString:string range:NSMakeRange(-1, 3)];
    XCTAssertNil(output);
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

#pragma mark > String Validation

- (void)test_checkStringAsEmailWithString {
    XCTAssertTrue([WCStringTool checkStringAsEmailWithString:@"me@163.com"]);
    XCTAssertTrue([WCStringTool checkStringAsEmailWithString:@"me.2000@163.com"]);
    XCTAssertTrue([WCStringTool checkStringAsEmailWithString:@"123456@qq.com"]);
    XCTAssertTrue([WCStringTool checkStringAsEmailWithString:@"1@t.cn"]);
    XCTAssertTrue([WCStringTool checkStringAsEmailWithString:@"test@gmai-l.com"]);
    XCTAssertTrue([WCStringTool checkStringAsEmailWithString:@"test@qq.com.cn"]);
    
    XCTAssertFalse([WCStringTool checkStringAsEmailWithString:@"email@provider..com"]);
    XCTAssertFalse([WCStringTool checkStringAsEmailWithString:@"email@provider."]);
    XCTAssertFalse([WCStringTool checkStringAsEmailWithString:@"email@provider"]);
    XCTAssertFalse([WCStringTool checkStringAsEmailWithString:@"email@provider@provider.com"]);
}

- (void)test_checkStringContainsCharactersAscendOrDescendWithString_charactersLength {
    XCTAssertTrue([WCStringTool checkStringContainsCharactersAscendOrDescendWithString:@"123" charactersLength:2]);
    XCTAssertTrue([WCStringTool checkStringContainsCharactersAscendOrDescendWithString:@"324" charactersLength:2]);
    XCTAssertTrue([WCStringTool checkStringContainsCharactersAscendOrDescendWithString:@"123456" charactersLength:5]);
    XCTAssertTrue([WCStringTool checkStringContainsCharactersAscendOrDescendWithString:@"abcdefg" charactersLength:7]);
    XCTAssertTrue([WCStringTool checkStringContainsCharactersAscendOrDescendWithString:@"gfedcba" charactersLength:7]);
    XCTAssertFalse([WCStringTool checkStringContainsCharactersAscendOrDescendWithString:@"gfedcba" charactersLength:8]);
    XCTAssertFalse([WCStringTool checkStringContainsCharactersAscendOrDescendWithString:@"123123" charactersLength:5]);
}

- (void)test_checkStringUniformedBySingleCharacterWithString {
    XCTAssertTrue([WCStringTool checkStringUniformedBySingleCharacterWithString:@""]);
    XCTAssertTrue([WCStringTool checkStringUniformedBySingleCharacterWithString:@"a"]);
    XCTAssertTrue([WCStringTool checkStringUniformedBySingleCharacterWithString:@"aaaaaaaaa"]);
    XCTAssertTrue([WCStringTool checkStringUniformedBySingleCharacterWithString:@"😁😁😁😁"]);
    XCTAssertTrue([WCStringTool checkStringUniformedBySingleCharacterWithString:@"\n\n\n\n\n"]);
    XCTAssertTrue([WCStringTool checkStringUniformedBySingleCharacterWithString:@"        "]);
    XCTAssertTrue([WCStringTool checkStringUniformedBySingleCharacterWithString:@"9999999999"]);
    XCTAssertTrue([WCStringTool checkStringUniformedBySingleCharacterWithString:@"0"]);
    
    NSString *nilString = nil;
    XCTAssertFalse([WCStringTool checkStringUniformedBySingleCharacterWithString:nilString]);
    XCTAssertFalse([WCStringTool checkStringUniformedBySingleCharacterWithString:@"aaaaz"]);
    XCTAssertFalse([WCStringTool checkStringUniformedBySingleCharacterWithString:@"\t\n\t\t"]);
    XCTAssertFalse([WCStringTool checkStringUniformedBySingleCharacterWithString:@"😁😂"]);
}

- (void)test_checkStringAsNoneNegativeIntegerWithString {
    XCTAssertFalse([WCStringTool checkStringAsNoneNegativeIntegerWithString:@""]);
    XCTAssertFalse([WCStringTool checkStringAsNoneNegativeIntegerWithString:@"110abc"]);
    XCTAssertFalse([WCStringTool checkStringAsNoneNegativeIntegerWithString:@"110\n"]);
    XCTAssertFalse([WCStringTool checkStringAsNoneNegativeIntegerWithString:@"110 "]);
    XCTAssertFalse([WCStringTool checkStringAsNoneNegativeIntegerWithString:@"110.1"]);
    XCTAssertFalse([WCStringTool checkStringAsNoneNegativeIntegerWithString:@".10"]);
    XCTAssertFalse([WCStringTool checkStringAsNoneNegativeIntegerWithString:@"110."]);
    XCTAssertFalse([WCStringTool checkStringAsNoneNegativeIntegerWithString:@"  "]);
    XCTAssertFalse([WCStringTool checkStringAsNoneNegativeIntegerWithString:@"\t"]);
    XCTAssertFalse([WCStringTool checkStringAsNoneNegativeIntegerWithString:@"+1000"]);
    XCTAssertFalse([WCStringTool checkStringAsNoneNegativeIntegerWithString:@"-1000"]);
    XCTAssertFalse([WCStringTool checkStringAsNoneNegativeIntegerWithString:@"010"]);
    XCTAssertFalse([WCStringTool checkStringAsNoneNegativeIntegerWithString:@"000"]);
    
    XCTAssertTrue([WCStringTool checkStringAsNoneNegativeIntegerWithString:@"0"]);
    XCTAssertTrue([WCStringTool checkStringAsNoneNegativeIntegerWithString:@"10"]);
    XCTAssertTrue([WCStringTool checkStringAsNoneNegativeIntegerWithString:@"123"]);
    XCTAssertTrue([WCStringTool checkStringAsNoneNegativeIntegerWithString:@"10000000000000000000000000000000000000000000000000000000000000000000000000000000"]);
}

- (void)test_checkStringAsPositiveIntegerWithString {
    XCTAssertFalse([WCStringTool checkStringAsPositiveIntegerWithString:@"0"]);
    XCTAssertFalse([WCStringTool checkStringAsPositiveIntegerWithString:@""]);
    XCTAssertFalse([WCStringTool checkStringAsPositiveIntegerWithString:@"\n"]);
    XCTAssertFalse([WCStringTool checkStringAsPositiveIntegerWithString:@" "]);
    XCTAssertFalse([WCStringTool checkStringAsPositiveIntegerWithString:@"01"]);
    XCTAssertFalse([WCStringTool checkStringAsPositiveIntegerWithString:@"abc"]);
    XCTAssertFalse([WCStringTool checkStringAsPositiveIntegerWithString:@"\\"]);
    XCTAssertFalse([WCStringTool checkStringAsPositiveIntegerWithString:@"+1"]);
    XCTAssertFalse([WCStringTool checkStringAsPositiveIntegerWithString:@"-1"]);
    XCTAssertFalse([WCStringTool checkStringAsPositiveIntegerWithString:@"1.1"]);
    XCTAssertFalse([WCStringTool checkStringAsPositiveIntegerWithString:@"1."]);
    XCTAssertFalse([WCStringTool checkStringAsPositiveIntegerWithString:@"😂"]);
    NSString *nilString = nil;
    XCTAssertFalse([WCStringTool checkStringAsPositiveIntegerWithString:nilString]);
    
    XCTAssertTrue([WCStringTool checkStringAsPositiveIntegerWithString:@"1"]);
    XCTAssertTrue([WCStringTool checkStringAsPositiveIntegerWithString:@"10"]);
    XCTAssertTrue([WCStringTool checkStringAsPositiveIntegerWithString:@"99999"]);
}

- (void)test_checkStringComposedOfNumbersWithString {
    XCTAssertFalse([WCStringTool checkStringComposedOfNumbersWithString:@"abc"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfNumbersWithString:@" "]);
    XCTAssertFalse([WCStringTool checkStringComposedOfNumbersWithString:@""]);
    XCTAssertFalse([WCStringTool checkStringComposedOfNumbersWithString:@"\t"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfNumbersWithString:@"\\"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfNumbersWithString:@"0ac"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfNumbersWithString:@"a100"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfNumbersWithString:@"-100"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfNumbersWithString:@"+100"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfNumbersWithString:@"1.1"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfNumbersWithString:@"123😂"]);
    NSString *nilString = nil;
    XCTAssertFalse([WCStringTool checkStringComposedOfNumbersWithString:nilString]);
    
    XCTAssertTrue([WCStringTool checkStringComposedOfNumbersWithString:@"0"]);
    XCTAssertTrue([WCStringTool checkStringComposedOfNumbersWithString:@"0001"]);
    XCTAssertTrue([WCStringTool checkStringComposedOfNumbersWithString:@"40"]);
    XCTAssertTrue([WCStringTool checkStringComposedOfNumbersWithString:@"1000000"]);
    XCTAssertTrue([WCStringTool checkStringComposedOfNumbersWithString:@"1001"]);
}

- (void)test_checkStringComposedOfLettersWithString {
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersWithString:@""]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersWithString:@" "]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersWithString:@"100"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersWithString:@"000"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersWithString:@"0"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersWithString:@"\t"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersWithString:@"abc123"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersWithString:@"123abc"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersWithString:@"abc\n"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersWithString:@"abc "]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersWithString:@"abc😂"]);
    NSString *nilString = nil;
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersWithString:nilString]);
    
    XCTAssertTrue([WCStringTool checkStringComposedOfLettersWithString:@"abcABC"]);
    XCTAssertTrue([WCStringTool checkStringComposedOfLettersWithString:@"a"]);
    XCTAssertTrue([WCStringTool checkStringComposedOfLettersWithString:@"A"]);
    XCTAssertTrue([WCStringTool checkStringComposedOfLettersWithString:@"Zz"]);
    XCTAssertTrue([WCStringTool checkStringComposedOfLettersWithString:@"abcdefghijklmnopqrstuvwxyz"]);
    XCTAssertTrue([WCStringTool checkStringComposedOfLettersWithString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"]);
    XCTAssertTrue([WCStringTool checkStringComposedOfLettersWithString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"]);
}

- (void)test_checkStringComposedOfLettersLowercaseWithString {
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersLowercaseWithString:@""]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersLowercaseWithString:@" "]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersLowercaseWithString:@"100"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersLowercaseWithString:@"000"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersLowercaseWithString:@"0"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersLowercaseWithString:@"\t"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersLowercaseWithString:@"abc123"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersLowercaseWithString:@"123abc"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersLowercaseWithString:@"abc\n"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersLowercaseWithString:@"abc "]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersLowercaseWithString:@"abc😂"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersLowercaseWithString:@"A"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersLowercaseWithString:@"Zz"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersLowercaseWithString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersLowercaseWithString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"]);
    NSString *nilString = nil;
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersLowercaseWithString:nilString]);
    
    XCTAssertTrue([WCStringTool checkStringComposedOfLettersLowercaseWithString:@"abcdefghijklmnopqrstuvwxyz"]);
    XCTAssertTrue([WCStringTool checkStringComposedOfLettersLowercaseWithString:@"a"]);
}

- (void)test_checkStringComposedOfLettersUppercaseWithString {
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersUppercaseWithString:@""]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersUppercaseWithString:@" "]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersUppercaseWithString:@"100"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersUppercaseWithString:@"000"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersUppercaseWithString:@"0"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersUppercaseWithString:@"\t"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersUppercaseWithString:@"abc123"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersUppercaseWithString:@"123abc"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersUppercaseWithString:@"abc\n"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersUppercaseWithString:@"abc "]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersUppercaseWithString:@"abc😂"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersUppercaseWithString:@"abcABC"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersUppercaseWithString:@"a"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersUppercaseWithString:@"Zz"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersUppercaseWithString:@"abcdefghijklmnopqrstuvwxyz"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersUppercaseWithString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"]);
    
    NSString *nilString = nil;
    XCTAssertFalse([WCStringTool checkStringComposedOfLettersUppercaseWithString:nilString]);
    
    XCTAssertTrue([WCStringTool checkStringComposedOfLettersUppercaseWithString:@"A"]);
    XCTAssertTrue([WCStringTool checkStringComposedOfLettersUppercaseWithString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"]);
}

- (void)test_checkStringComposedOfChineseCharactersWithString {
    XCTAssertFalse([WCStringTool checkStringComposedOfChineseCharactersWithString:@""]);
    XCTAssertFalse([WCStringTool checkStringComposedOfChineseCharactersWithString:@"a中"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfChineseCharactersWithString:@"中a"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfChineseCharactersWithString:@"中 文"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfChineseCharactersWithString:@"、中文"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfChineseCharactersWithString:@"中文\b"]);
    XCTAssertFalse([WCStringTool checkStringComposedOfChineseCharactersWithString:@"中文😂"]);
    NSString *nilString = nil;
    XCTAssertFalse([WCStringTool checkStringComposedOfChineseCharactersWithString:nilString]);
    XCTAssertFalse([WCStringTool checkStringComposedOfChineseCharactersWithString:@" "]);
    
    XCTAssertTrue([WCStringTool checkStringComposedOfChineseCharactersWithString:@"中文"]);
    XCTAssertTrue([WCStringTool checkStringComposedOfChineseCharactersWithString:@"中"]);
    XCTAssertTrue([WCStringTool checkStringComposedOfChineseCharactersWithString:@"中文是中国汉字"]);
}

- (void)test_checkStringAsAlphanumericWithString {
    XCTAssertTrue([WCStringTool checkStringAsAlphanumericWithString:@"abc"]);
    XCTAssertTrue([WCStringTool checkStringAsAlphanumericWithString:@"ABC"]);
    XCTAssertTrue([WCStringTool checkStringAsAlphanumericWithString:@"abc123"]);
    XCTAssertTrue([WCStringTool checkStringAsAlphanumericWithString:@"ABC123"]);
    XCTAssertTrue([WCStringTool checkStringAsAlphanumericWithString:@"abcABC"]);
    XCTAssertTrue([WCStringTool checkStringAsAlphanumericWithString:@"abcABC123"]);
    
    XCTAssertFalse([WCStringTool checkStringAsAlphanumericWithString:@"!@#"]);
    XCTAssertFalse([WCStringTool checkStringAsAlphanumericWithString:@""]);
    NSString *nilString = nil;
    XCTAssertFalse([WCStringTool checkStringAsAlphanumericWithString:nilString]);
    XCTAssertFalse([WCStringTool checkStringAsAlphanumericWithString:@" "]);
    XCTAssertFalse([WCStringTool checkStringAsAlphanumericWithString:@"中文"]);
}

- (void)test_checkStringURLEscapedWithString {
    NSString *urlEscapedString;
    
    // Case 1: 中文
    urlEscapedString = @"%E4%B8%AD%E6%96%87";
    XCTAssertTrue([WCStringTool checkStringURLEscapedWithString:urlEscapedString]);
    
    // Case 2: 😆
    urlEscapedString = @"%F0%9F%98%86";
    XCTAssertTrue([WCStringTool checkStringURLEscapedWithString:urlEscapedString]);
    
    // Case 3: Thisis中文
    urlEscapedString = @"Thisis%E4%B8%AD%E6%96%87";
    XCTAssertTrue([WCStringTool checkStringURLEscapedWithString:urlEscapedString]);
    
    // Case 4: 1234567=+?, for `?` should not encode
    urlEscapedString = @"1234567%3D%2B%3F";
    XCTAssertFalse([WCStringTool checkStringURLEscapedWithString:urlEscapedString]);
    
    // Case 5: This is a url escaped string: 中文
    urlEscapedString = @"This is a url escaped string: %E4%B8%AD%E6%96%87";
    XCTAssertFalse([WCStringTool checkStringURLEscapedWithString:urlEscapedString]);
}

- (void)test_checkStringContainsChineseCharactersWithString {
    NSString *string;
    
    // Case 1
    string = @"%E4%B8%AD%E6%96%87";
    XCTAssertFalse([WCStringTool checkStringContainsChineseCharactersWithString:string]);
    
    // Case 2
    string = @"1234567890？";
    XCTAssertFalse([WCStringTool checkStringContainsChineseCharactersWithString:string]);
    
    // Case 3:
    string = @"Thisis中文";
    XCTAssertTrue([WCStringTool checkStringContainsChineseCharactersWithString:string]);
    
    // Case 4
    string = @"123456789零";
    XCTAssertTrue([WCStringTool checkStringContainsChineseCharactersWithString:string]);
}

- (void)test_checkStringContainsAllCharactersWithString_allCharacters {
    NSString *string;
    NSString *allCharacters;
    BOOL result;
    
    // Case 1
    string = @"abcd";
    allCharacters = @"[,]";
    result = [WCStringTool checkStringContainsAllCharactersWithString:string allCharacters:allCharacters];
    XCTAssertFalse(result);
    
    string = @"abcd[";
    allCharacters = @"[,]";
    result = [WCStringTool checkStringContainsAllCharactersWithString:string allCharacters:allCharacters];
    XCTAssertFalse(result);
    
    string = @"abcd[,";
    allCharacters = @"[,]";
    result = [WCStringTool checkStringContainsAllCharactersWithString:string allCharacters:allCharacters];
    XCTAssertFalse(result);
    
    string = @"abcd[,]";
    allCharacters = @"[,]";
    result = [WCStringTool checkStringContainsAllCharactersWithString:string allCharacters:allCharacters];
    XCTAssertTrue(result);
    
    string = @"abcd[,]";
    allCharacters = @"[,][,]";
    result = [WCStringTool checkStringContainsAllCharactersWithString:string allCharacters:allCharacters];
    XCTAssertTrue(result);
}

#pragma mark > Split String

- (void)test_componentsWithString_gapRanges {
    NSString *string;
    NSArray *gaps;
    NSArray *components;
    
    // Case 1
    string = @"This is a long string";
    gaps = [WCStringTool rangesOfSubstringWithString:string substring:@"s"];
    components = [WCStringTool componentsWithString:string gapRanges:gaps];
    NSLog(@"%@", components);
    
    // Case 2
    string = @"This is a long string";
    gaps = [WCStringTool rangesOfSubstringWithString:string substring:@"is "];
    components = [WCStringTool componentsWithString:string gapRanges:gaps];
    NSLog(@"%@", components);
    
    // Case 3
    string = @"0123456789";
    gaps = @[
             [NSValue valueWithRange:NSMakeRange(1, 1)],
             [NSValue valueWithRange:NSMakeRange(3, 2)],
             [NSValue valueWithRange:NSMakeRange(6, 3)],
             ];
    components = [WCStringTool componentsWithString:string gapRanges:gaps];
    NSLog(@"%@", components);
}

- (void)test_keyValuePairsWithString_usingConnector_usingSeparator {
    NSString *string;
    NSDictionary *keyValues;
    
    // Case
    string = @"Mon:Monday#Tue:Tuesday#Wed:Wednesday#Thurs:Thursday#Fri:Friday#Sat:Saturday#Sun:Sunday";
    keyValues = [WCStringTool keyValuePairsWithString:string usingConnector:@":" usingSeparator:@"#"];
    XCTAssertEqualObjects(keyValues[@"Mon"], @"Monday");
    XCTAssertEqualObjects(keyValues[@"Tue"], @"Tuesday");
    XCTAssertEqualObjects(keyValues[@"Wed"], @"Wednesday");
    XCTAssertEqualObjects(keyValues[@"Thurs"], @"Thursday");
    XCTAssertEqualObjects(keyValues[@"Fri"], @"Friday");
    XCTAssertEqualObjects(keyValues[@"Sat"], @"Saturday");
    XCTAssertEqualObjects(keyValues[@"Sun"], @"Sunday");
    XCTAssertNil(keyValues[@"today"]);
    
    // Case
    string =  @"Q=u%3D360H1491330706%26n%3D%26le%3DoT10MKA0ZvH0ZUSkYzAioD%3D%3D%26m%3D%26qid%3D1491330706%26im%3D1_t00df551a583a87f4e9%26src%3Dmpc_caipiao_os_100000%26t%3D1;T=s%3D70657b22272b33d114f2b6a6d8efcf5c%26t%3D1433590027%26lm%3D%26lf%3D1%26sk%3Db5dcb4c7fa89fe4215b2fea0d7d98d31%26mt%3D1433590027%26rc%3D%26v%3D2.0%26a%3D1";
    keyValues = [WCStringTool keyValuePairsWithString:string usingConnector:@"=" usingSeparator:@";"];
    XCTAssertEqualObjects(keyValues[@"Q"], @"u%3D360H1491330706%26n%3D%26le%3DoT10MKA0ZvH0ZUSkYzAioD%3D%3D%26m%3D%26qid%3D1491330706%26im%3D1_t00df551a583a87f4e9%26src%3Dmpc_caipiao_os_100000%26t%3D1");
    XCTAssertEqualObjects(keyValues[@"T"], @"s%3D70657b22272b33d114f2b6a6d8efcf5c%26t%3D1433590027%26lm%3D%26lf%3D1%26sk%3Db5dcb4c7fa89fe4215b2fea0d7d98d31%26mt%3D1433590027%26rc%3D%26v%3D2.0%26a%3D1");
}

#pragma mark > String Generation

- (void)test_randomStringWithLength {
    NSLog(@"random string: %@", [WCStringTool randomStringWithLength:20]);
    NSLog(@"random string: %@", [WCStringTool randomStringWithLength:20]);
    NSLog(@"random string: %@", [WCStringTool randomStringWithLength:40]);
    NSLog(@"random string: %@", [WCStringTool randomStringWithLength:40]);
}

- (void)test_randomStringWithCharacters_length {
    NSString *characters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.-_";
    
    NSLog(@"random string: %@", [WCStringTool randomStringWithCharacters:characters length:20]);
    NSLog(@"random string: %@", [WCStringTool randomStringWithCharacters:characters length:20]);
    NSLog(@"random string: %@", [WCStringTool randomStringWithCharacters:characters length:40]);
    NSLog(@"random string: %@", [WCStringTool randomStringWithCharacters:characters length:40]);
}

- (void)test_spacedStringWithString_format {
    XCTAssertEqualObjects([WCStringTool spacedStringWithString:@"1234567890" format:@"XXX XXXX XXXX"], @"123 4567 890");
    XCTAssertEqualObjects([WCStringTool spacedStringWithString:@"1234567890" format:@"XXX XXX XXXX"], @"123 456 7890");
    XCTAssertEqualObjects([WCStringTool spacedStringWithString:@"123456789012" format:@"XXX XXXX XXXX"], @"123 4567 89012");
    XCTAssertEqualObjects([WCStringTool spacedStringWithString:@"1234" format:@"XXX XXXX XXXX"], @"123 4");
    XCTAssertEqualObjects([WCStringTool spacedStringWithString:@"123456789012" format:@" X XX XXX"], @" 1 23 456789012");
    XCTAssertEqualObjects([WCStringTool spacedStringWithString:@"abc" format:@" X X X "], @" a b c");
    XCTAssertEqualObjects([WCStringTool spacedStringWithString:@"abcd" format:@" X X X "], @" a b c d");
    XCTAssertEqualObjects([WCStringTool spacedStringWithString:@"abcd" format:@" X X "], @" a b cd");
    
    // abnormal cases
    XCTAssertEqualObjects([WCStringTool spacedStringWithString:@" 1 2 3 4 5 6 7 8 9 0 " format:@"XXX XXXX XXXX"], @"123 4567 890");
    XCTAssertEqualObjects([WCStringTool spacedStringWithString:@" 1 2 3 4 5 6 7 8 9 0 " format:@"ZZZZZZzzzzzzzzzzzzzzzzzzzz"], @"1234567890");
    XCTAssertEqualObjects([WCStringTool spacedStringWithString:@"1234567890" format:@"X"], @"1234567890");
    XCTAssertEqualObjects([WCStringTool spacedStringWithString:@"1234567890" format:@"ZZZZZZzzzzzzzzzzzzzzzzzzzz"], @"1234567890");
    XCTAssertEqualObjects([WCStringTool spacedStringWithString:@"1234567890" format:@""], @"1234567890");
    XCTAssertEqualObjects([WCStringTool spacedStringWithString:@"" format:@""], @"");
    XCTAssertEqualObjects([WCStringTool spacedStringWithString:@"" format:@"123456"], @"");
    XCTAssertEqualObjects([WCStringTool spacedStringWithString:@"" format:@"aa aa"], @"");
    XCTAssertEqualObjects([WCStringTool spacedStringWithString:@"  " format:@"aa aa"], @"");
}

- (void)test_formattedStringWithString_format_arguments {
    NSString *string;
    NSArray *args;
    
    // Case 1
    args = @[
             @"He",
             @"llo",
             @"wo",
             @"r",
             @"ld"
             ];
    string = [WCStringTool stringWithFormat:@"%@%@, %@%@%@!" arguments:args];
    NSLog(@"%@", string);
    XCTAssertEqualObjects(string, @"Hello, world!");
    
    // Case 2
    args = @[
             @(1),
             @"2",
             @".",
             @"1",
             @(12.1f)
             ];
    string = [WCStringTool stringWithFormat:@"%@%@%@%@ = %@" arguments:args];
    NSLog(@"%@", string);
    XCTAssertEqualObjects(string, @"12.1 = 12.1");
    
    // Case 3
    args = @[
             @"a",
             @"b",
             @"c"
             ];
    string = [WCStringTool stringWithFormat:@"%@%@" arguments:args];
    NSLog(@"%@", string);
    XCTAssertEqualObjects(string, @"ab");
    
    // Abnormal Case 1
    args = @[
             @"a",
             @"b",
             @"c"
             ];
    string = [WCStringTool stringWithFormat:@"Hello" arguments:args];
    NSLog(@"%@", string);
    XCTAssertEqualObjects(string, @"Hello");
    
    // Abnormal Case 2
    args = @[
             ];
    string = [WCStringTool stringWithFormat:@"Hello" arguments:args];
    NSLog(@"%@", string);
    XCTAssertEqualObjects(string, @"Hello");
}

- (void)test_insertSeparatorWithString_separator_atInterval {
    NSString *inputString;
    NSString *outputString;
    
    // Case 1：每隔1个字符插入一个"."
    inputString = @"您的操作过于频繁，验证码可能有延迟请收到后再输入";
    outputString = [WCStringTool insertSeparatorWithString:inputString separator:@"." atInterval:1];
    NSLog(@"%@", outputString);
    
    // Case 2：每隔10个字符插入一个"\n"
    inputString = @"您的操作过于频繁，验证码可能有延迟请收到后再输入";
    outputString = [WCStringTool insertSeparatorWithString:inputString separator:@"\n" atInterval:10];
    NSLog(@"%@", outputString);
}

- (void)test_collapseAdjacentCharactersWithString_characters {
    // Omit spaces
    NSString *inputString;
    
    inputString = @"  Hello      this  is a   long       string!   ";
    NSLog(@"\"%@\"", [WCStringTool collapseAdjacentCharactersWithString:inputString characters:@" "]);
    NSLog(@"-----------------------------");
    
    //
    inputString = @"\n\n\nHello\t\t\tthis is a   long       string!   ";
    NSLog(@"\"%@\"", [WCStringTool collapseAdjacentCharactersWithString:inputString characters:@" \n\t"]);
    NSLog(@"-----------------------------");
    
    inputString = @"😄😄😄😄Hello    😂😂😂😂this  is a   long😁😁😁😁😁😁       string!   ";
    NSLog(@"\"%@\"", [WCStringTool collapseAdjacentCharactersWithString:inputString characters:@" 😄😂😁"]);
    NSLog(@"-----------------------------");
    
    inputString = @"AAABBCDDDDEEFF";
    NSLog(@"\"%@\"", [WCStringTool collapseAdjacentCharactersWithString:inputString characters:@"ABCDEf"]);
    NSLog(@"-----------------------------");
}

- (void)test_truncatedStringWithString_limitedToLength_truncatingStyle_separator {
    NSString *inputString;
    NSString *output;
    
    // Case 1
    inputString = @"Hello, World!";
    output = [WCStringTool truncatedStringWithString:inputString limitedToLength:5 truncatingStyle:WCStringTruncatingStyleTrail separator:nil];
    XCTAssertTrue(output.length == 5);
    XCTAssertEqualObjects(output, @"He...");
    
    // Case 2
    inputString = @"Hello, World!";
    output = [WCStringTool truncatedStringWithString:inputString limitedToLength:5 truncatingStyle:WCStringTruncatingStyleHead separator:nil];
    XCTAssertTrue(output.length == 5);
    XCTAssertEqualObjects(output, @"...d!");
    
    // Case 3
    inputString = @"Hello, World!";
    output = [WCStringTool truncatedStringWithString:inputString limitedToLength:5 truncatingStyle:WCStringTruncatingStyleMiddle separator:nil];
    XCTAssertTrue(output.length == 5);
    XCTAssertEqualObjects(output, @"H...!");
    
    // Case 4
    inputString = @"Hello, World!";
    output = [WCStringTool truncatedStringWithString:inputString limitedToLength:5 truncatingStyle:WCStringTruncatingStyleNone separator:nil];
    XCTAssertTrue(output.length == 13);
    XCTAssertEqualObjects(output, @"Hello, World!");
    
    // Case 5
    inputString = @"Hello";
    output = [WCStringTool truncatedStringWithString:inputString limitedToLength:5 truncatingStyle:WCStringTruncatingStyleMiddle separator:nil];
    XCTAssertTrue(output.length == 5);
    XCTAssertEqualObjects(output, @"Hello");
}

#pragma mark > String Modification

- (void)test_replaceCharactersInRangesWithString_ranges_replacementStrings_replacementRanges {
    NSString *inputString;
    NSArray<NSValue *> *ranges;
    NSArray<NSString *> *replacements;
    NSMutableArray<NSValue *> *replacementRanges = [NSMutableArray array];
    NSString *outputString;
    
    // Case 1
    inputString = @"0123456789";
    ranges = @[
               [NSValue valueWithRange:NSMakeRange(0, 1)],
               [NSValue valueWithRange:NSMakeRange(1, 1)],
               [NSValue valueWithRange:NSMakeRange(2, 1)],
               [NSValue valueWithRange:NSMakeRange(3, 1)],
               [NSValue valueWithRange:NSMakeRange(4, 1)],
               [NSValue valueWithRange:NSMakeRange(5, 1)],
               [NSValue valueWithRange:NSMakeRange(6, 1)],
               [NSValue valueWithRange:NSMakeRange(7, 1)],
               [NSValue valueWithRange:NSMakeRange(8, 1)],
               [NSValue valueWithRange:NSMakeRange(9, 1)],
               ];
    replacements = @[
                     @"Aa",
                     @"Bb",
                     @"Cc",
                     @"Dd",
                     @"Ee",
                     @"Ff",
                     @"Gg",
                     @"Hh",
                     @"Ii",
                     @"Jj",
                     ];

    outputString = [WCStringTool replaceCharactersInRangesWithString:inputString ranges:ranges replacementStrings:replacements replacementRanges:replacementRanges];
    XCTAssertEqualObjects(outputString, @"AaBbCcDdEeFfGgHhIiJj");
    XCTAssertTrue(replacementRanges.count == replacements.count);
    for (NSInteger i = 0; i < replacements.count; i++) {
        NSRange range1 = [outputString rangeOfString:replacements[i]];
        NSRange range2 = [replacementRanges[i] rangeValue];
        
        XCTAssertTrue(NSEqualRanges(range1, range2));
    }

    // Case 2
    inputString = @"0123456789";
    ranges = @[
               [NSValue valueWithRange:NSMakeRange(1, 3)],
               [NSValue valueWithRange:NSMakeRange(7, 3)],
               ];
    replacements = @[
                     @"A",
                     @"B",
                     ];

    outputString = [WCStringTool replaceCharactersInRangesWithString:inputString ranges:ranges replacementStrings:replacements replacementRanges:replacementRanges];
    XCTAssertEqualObjects(outputString, @"0A456B");
    XCTAssertTrue(replacementRanges.count == replacements.count);
    for (NSInteger i = 0; i < replacements.count; i++) {
        NSRange range1 = [outputString rangeOfString:replacements[i]];
        NSRange range2 = [replacementRanges[i] rangeValue];
        
        XCTAssertTrue(NSEqualRanges(range1, range2));
    }

    // Case 3
    inputString = @"0123456789";
    ranges = @[
               [NSValue valueWithRange:NSMakeRange(1, 3)],
               [NSValue valueWithRange:NSMakeRange(7, 2)],
               ];
    replacements = @[
                     @"A",
                     @"B",
                     ];

    outputString = [WCStringTool replaceCharactersInRangesWithString:inputString ranges:ranges replacementStrings:replacements replacementRanges:replacementRanges];
    XCTAssertEqualObjects(outputString, @"0A456B9");
    XCTAssertTrue(replacementRanges.count == replacements.count);
    for (NSInteger i = 0; i < replacements.count; i++) {
        NSRange range1 = [outputString rangeOfString:replacements[i]];
        NSRange range2 = [replacementRanges[i] rangeValue];
        
        XCTAssertTrue(NSEqualRanges(range1, range2));
    }
    
    // Case 4
    inputString = @"0123456789";
    ranges = @[
               [NSValue valueWithRange:NSMakeRange(1, 3)],
               [NSValue valueWithRange:NSMakeRange(5, 1)],
               [NSValue valueWithRange:NSMakeRange(7, 2)],
               ];
    replacements = @[
                     @"A",
                     @"BCD",
                     @"E",
                     ];
    
    outputString = [WCStringTool replaceCharactersInRangesWithString:inputString ranges:ranges replacementStrings:replacements replacementRanges:replacementRanges];
    XCTAssertEqualObjects(outputString, @"0A4BCD6E9");
    XCTAssertTrue(replacementRanges.count == replacements.count);
    for (NSInteger i = 0; i < replacements.count; i++) {
        NSRange range1 = [outputString rangeOfString:replacements[i]];
        NSRange range2 = [replacementRanges[i] rangeValue];
        
        XCTAssertTrue(NSEqualRanges(range1, range2));
    }
    
    // Case 5
    inputString = @"0123456789";
    ranges = @[
               [NSValue valueWithRange:NSMakeRange(1, 3)],
               [NSValue valueWithRange:NSMakeRange(5, 1)],
               [NSValue valueWithRange:NSMakeRange(7, 2)],
               ];
    replacements = @[
                     @"",
                     @"",
                     @"",
                     ];
    
    outputString = [WCStringTool replaceCharactersInRangesWithString:inputString ranges:ranges replacementStrings:replacements replacementRanges:replacementRanges];
    XCTAssertEqualObjects(outputString, @"0469");
    XCTAssertTrue(replacementRanges.count == replacements.count);
    XCTAssertTrue(NSEqualRanges([replacementRanges[0] rangeValue], NSMakeRange(1, 0)));
    XCTAssertTrue(NSEqualRanges([replacementRanges[1] rangeValue], NSMakeRange(2, 0)));
    XCTAssertTrue(NSEqualRanges([replacementRanges[2] rangeValue], NSMakeRange(3, 0)));
    
    
    // Case 6
    inputString = @"0123456789";
    ranges = @[
               [NSValue valueWithRange:NSMakeRange(1, 3)],
               [NSValue valueWithRange:NSMakeRange(7, 2)],
               ];
    replacements = @[
                     @"",
                     @"",
                     ];
    
    outputString = [WCStringTool replaceCharactersInRangesWithString:inputString ranges:ranges replacementStrings:replacements replacementRanges:replacementRanges];
    XCTAssertEqualObjects(outputString, @"04569");
    XCTAssertTrue(replacementRanges.count == replacements.count);
    XCTAssertTrue(NSEqualRanges([replacementRanges[0] rangeValue], NSMakeRange(1, 0)));
    XCTAssertTrue(NSEqualRanges([replacementRanges[1] rangeValue], NSMakeRange(4, 0)));
    
    // Case 7
    inputString = @"0123456789";
    ranges = @[
               [NSValue valueWithRange:NSMakeRange(1, 3)],
               [NSValue valueWithRange:NSMakeRange(7, 2)],
               ];
    replacements = @[
                     @"123",
                     @"78",
                     ];
    
    outputString = [WCStringTool replaceCharactersInRangesWithString:inputString ranges:ranges replacementStrings:replacements replacementRanges:replacementRanges];
    XCTAssertEqualObjects(outputString, @"0123456789");
    XCTAssertTrue(replacementRanges.count == replacements.count);
    for (NSInteger i = 0; i < replacements.count; i++) {
        NSRange range1 = [outputString rangeOfString:replacements[i]];
        NSRange range2 = [replacementRanges[i] rangeValue];
        
        XCTAssertTrue(NSEqualRanges(range1, range2));
    }
    
    // Case 8
    inputString = @"0中文12345678😆9";
    ranges = @[
               [NSValue valueWithRange:NSMakeRange(1, 2)],
               // Note: 😆'length is 2
               [NSValue valueWithRange:NSMakeRange(11, 2)],
               ];
    replacements = @[
                     @"鐘文",
                     @"😄",
                     ];

    outputString = [WCStringTool replaceCharactersInRangesWithString:inputString ranges:ranges replacementStrings:replacements replacementRanges:replacementRanges];
    XCTAssertEqualObjects(outputString, @"0鐘文12345678😄9");
    XCTAssertTrue(replacementRanges.count == replacements.count);
    for (NSInteger i = 0; i < replacements.count; i++) {
        NSRange range1 = [outputString rangeOfString:replacements[i]];
        NSRange range2 = [replacementRanges[i] rangeValue];
        
        XCTAssertTrue(NSEqualRanges(range1, range2));
    }
    
    // Case 9
    inputString = @"0123456789";
    ranges = @[
               [NSValue valueWithRange:NSMakeRange(9, 1)],
               [NSValue valueWithRange:NSMakeRange(8, 1)],
               [NSValue valueWithRange:NSMakeRange(7, 1)],
               [NSValue valueWithRange:NSMakeRange(6, 1)],
               [NSValue valueWithRange:NSMakeRange(5, 1)],
               [NSValue valueWithRange:NSMakeRange(4, 1)],
               [NSValue valueWithRange:NSMakeRange(3, 1)],
               [NSValue valueWithRange:NSMakeRange(2, 1)],
               [NSValue valueWithRange:NSMakeRange(1, 1)],
               [NSValue valueWithRange:NSMakeRange(0, 1)],
               ];
    replacements = @[
                     @"Jj",
                     @"Ii",
                     @"Hh",
                     @"Gg",
                     @"Ff",
                     @"Ee",
                     @"Dd",
                     @"Cc",
                     @"Bb",
                     @"Aa",
                     ];

    outputString = [WCStringTool replaceCharactersInRangesWithString:inputString ranges:ranges replacementStrings:replacements replacementRanges:replacementRanges];
    XCTAssertEqualObjects(outputString, @"AaBbCcDdEeFfGgHhIiJj");
    XCTAssertTrue(replacementRanges.count == replacements.count);
    for (NSInteger i = 0; i < replacements.count; i++) {
        NSRange range1 = [outputString rangeOfString:replacements[i]];
        NSRange range2 = [replacementRanges[i] rangeValue];
        
        XCTAssertTrue(NSEqualRanges(range1, range2));
    }

    // Case 10
    inputString = @"0123456789";
    ranges = @[];
    replacements = @[];

    outputString = [WCStringTool replaceCharactersInRangesWithString:inputString ranges:ranges replacementStrings:replacements replacementRanges:replacementRanges];
    XCTAssertEqualObjects(outputString, @"0123456789");
    
    // Case 11
    inputString = @"0123456789";
    ranges = @[
               [NSValue valueWithRange:NSMakeRange(0, 0)],
               ];
    replacements = @[
                     @"",
                     ];
    
    outputString = [WCStringTool replaceCharactersInRangesWithString:inputString ranges:ranges replacementStrings:replacements replacementRanges:replacementRanges];
    XCTAssertEqualObjects(outputString, @"0123456789");

    // Abnormal Case 1: range out of bounds
    inputString = @"0123456789";
    ranges = @[
               [NSValue valueWithRange:NSMakeRange(0, 11)],
               ];
    replacements = @[
                     @"A",
                     ];

    outputString = [WCStringTool replaceCharactersInRangesWithString:inputString ranges:ranges replacementStrings:replacements replacementRanges:replacementRanges];
    XCTAssertNil(outputString);
    
    // Abnormal Case 2: ranges has intersection
    inputString = @"0123456789";
    ranges = @[
               [NSValue valueWithRange:NSMakeRange(0, 3)],
               [NSValue valueWithRange:NSMakeRange(1, 1)],
               ];
    replacements = @[
                     @"A",
                     @"B",
                     ];
    
    outputString = [WCStringTool replaceCharactersInRangesWithString:inputString ranges:ranges replacementStrings:replacements replacementRanges:nil];
    XCTAssertNil(outputString);
}

#pragma mark > String Conversion

#pragma mark >> String to CGRect/UIEdgeInsets/UIColor

- (void)test_numberFromString_encodedType {
    NSString *string;
    
    // Case 1
    string = @"3.14159";
    XCTAssertEqualObjects([WCStringTool numberFromString:string encodedType:@encode(double)], @(3.14159));
    
    // Case 2
    string = @"-3.14159";
    XCTAssertEqualObjects([WCStringTool numberFromString:string encodedType:@encode(double)], @(-3.14159));
    
    // Case 3
    string = @"-3.14159";
    XCTAssertEqualObjects([WCStringTool numberFromString:string encodedType:@encode(float)], @(-3.14159f));
    
    // Case 4
    string = @"-3.14159";
    XCTAssertEqualObjects([WCStringTool numberFromString:string encodedType:@encode(int)], @(-3));
    
    // Case 5
    string = @"-3.5";
    XCTAssertEqualObjects([WCStringTool numberFromString:string encodedType:@encode(int)], @(-3));
    
    // Case 6
    string = @"3.5";
    XCTAssertEqualObjects([WCStringTool numberFromString:string encodedType:@encode(int)], @(3));
    
    // Case 7
    string = @"0001";
    XCTAssertEqualObjects([WCStringTool numberFromString:string encodedType:@encode(int)], @1);
    
    // Case 8
    string = @"-0001";
    XCTAssertEqualObjects([WCStringTool numberFromString:string encodedType:@encode(int)], @(-1));
    
    // Case 9
    string = [NSString stringWithFormat:@"%ld", LONG_MAX];
    XCTAssertEqualObjects([WCStringTool numberFromString:string encodedType:@encode(long)], @(LONG_MAX));
    
    // Case 10
    string = @"Y";
    XCTAssertEqualObjects([WCStringTool numberFromString:string encodedType:@encode(BOOL)], @YES);
    
    // Case 11
    string = @"true";
    XCTAssertEqualObjects([WCStringTool numberFromString:string encodedType:@encode(BOOL)], @YES);
    
    // Case 12
    string = @"  t";
    XCTAssertEqualObjects([WCStringTool numberFromString:string encodedType:@encode(BOOL)], @YES);
    
    // Case 13
    string = @"NO";
    XCTAssertEqualObjects([WCStringTool numberFromString:string encodedType:@encode(BOOL)], @NO);
    
    // Case 14
    string = @"0";
    XCTAssertEqualObjects([WCStringTool numberFromString:string encodedType:@encode(BOOL)], @NO);
    
    // Case 15
    string = @"abc";
    XCTAssertEqualObjects([WCStringTool numberFromString:string encodedType:@encode(BOOL)], @NO);
    
    // Case 16
    string = @"abc";
    XCTAssertNil([WCStringTool numberFromString:string encodedType:@encode(id)]);
    
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

#pragma mark >> Unicode

- (void)test_unescapedUnicodeStringWithString {
    NSString *string;
    NSString *output;
    
    // Case 1: unescape UTF-8
    string = @"\\u5404\\u500b\\u90fd";
    output = [WCStringTool unescapeUTF8EncodingStringWithString:string];
    XCTAssertEqualObjects(output, @"各個都");
    
    // Case 2: unescape non-standard UTF-8 which has \U and 4 length
    string = @"\\U5378\\U8f7d\\U5e94\\U7528";
    output = [WCStringTool unescapeUTF8EncodingStringWithString:string];
    XCTAssertEqualObjects(output, @"卸载应用");
    
    string = ESCAPE_UNICODE_CSTR("\U5e97\U94fa\U6d4b\U8bd5\U8d26\U53f7");
    output = [WCStringTool unescapeUTF8EncodingStringWithString:string];
    XCTAssertEqualObjects(output, @"店铺测试账号");
    
    // Note: Xcode not allow c string to use "\U03C0", must be "\u03C0", so use ESCAPE_UNICODE_CSTR macro to escape it
    string = ESCAPE_UNICODE_CSTR("\U03C0"); // It's not same as π
    output = [WCStringTool unescapeUTF8EncodingStringWithString:string];
    XCTAssertEqualObjects(output, @"π");
    
    // Case 3: no need to unescape
    string = @"\u03C0"; // It's same as π
    output = [WCStringTool unescapeUTF8EncodingStringWithString:string];
    XCTAssertEqualObjects(output, @"π");
    
    string = @"";
    output = [WCStringTool unescapeUTF8EncodingStringWithString:string];
    XCTAssertEqualObjects(output, @"");
    
    string = @"a normal string";
    output = [WCStringTool unescapeUTF8EncodingStringWithString:string];
    XCTAssertEqualObjects(output, @"a normal string");
    
    NSString *nilString;
    string = nilString;
    output = [WCStringTool unescapeUTF8EncodingStringWithString:string];
    XCTAssertNil(output);

    // Case 4: unescape Unicode not UTF-8 encoding
    string = @"\\U0001F30D";
    output = [WCStringTool unescapeUTF8EncodingStringWithString:string];
    XCTAssertNotEqualObjects(output, @"🌍");
}

- (void)test_unicodePointStringWithString {
    NSString *string;
    NSString *output;
    
    // Case 1
    string = @"A";
    output = [WCStringTool unicodePointStringWithString:string];
    XCTAssertEqualObjects(output, @"\\U00000041");
    //NSLog(@"\U00000041"); // Error: Character 'A' cannot be specified by a universal character name
    
    // Case 2
    string = @"🌍";
    output = [WCStringTool unicodePointStringWithString:string];
    XCTAssertEqualObjects(output, @"\\U0001F30D");
    NSLog(@"\U0001F30D");
    
    // Case 3
    string = @"";
    output = [WCStringTool unicodePointStringWithString:string];
    XCTAssertEqualObjects(output, @"\\U0000F8FF");
    NSLog(@"\U0000F8FF");
    NSLog(@"\uF8FF");
    
    // Case 4
    string = @"🌍🌞";
    output = [WCStringTool unicodePointStringWithString:string];
    XCTAssertEqualObjects(output, @"\\U0001F30D\\U0001F31E");
    NSLog(@"\U0001F30D\U0001F31E");
    
    // Case 5
    string = @"\n";
    output = [WCStringTool unicodePointStringWithString:string];
    XCTAssertEqualObjects(output, @"\\U0000000A");
    //NSLog(@"\U0000000A"); // Error: Universal character name refers to a control character
    //NSLog(@"\u000A"); // Error: Universal character name refers to a control character
    
    // Case 6
    string = @"卸载应用";
    output = [WCStringTool unicodePointStringWithString:string];
    XCTAssertEqualObjects(output, @"\\U00005378\\U00008F7D\\U00005E94\\U00007528");
    NSLog(@"\U00005378\U00008F7D\U00005E94\U00007528");
}

#pragma mark > String Measuration (e.g. length, number of substring, range, ...)

- (void)test_rangesOfSubstringWithString_substring {
    NSString *string =
    @"• 此操作仅限更换手机号，不影响当前账号内容\n"
    @"• 您将使用新的手机号登录当前账号\n"
    @"• 司机联系您时，将拨打您的新手机号\n"
    @"• 司机联系您时，将拨打您的新手机号\n"
    @"• 一个月只允许更换一次手机号";
    
    NSArray *ranges = [WCStringTool rangesOfSubstringWithString:string substring:@"•"];
    
    XCTAssertTrue(ranges.count == 5);
    for (NSUInteger i = 0; i < ranges.count; i++) {
        NSValue *value = (NSValue *)ranges[i];
        NSRange range = [value rangeValue];
        
        NSLog(@"%@", NSStringFromRange(range));
    }
    
    XCTAssertTrue([WCStringTool rangesOfSubstringWithString:string substring:@"\n"].count == 4);
    XCTAssertTrue([WCStringTool rangesOfSubstringWithString:string substring:@"司机"].count == 2);
    XCTAssertTrue([WCStringTool rangesOfSubstringWithString:string substring:@"null"].count == 0);
}

- (void)test_lengthWithString_treatChineseCharacterAsTwoCharacters {
    NSString *str = @"Hi，中国";
    NSLog(@"len1: %lu", (unsigned long)[WCStringTool lengthWithString:str treatChineseCharacterAsTwoCharacters:NO]);
    NSLog(@"len2: %lu", (unsigned long)[WCStringTool lengthWithString:str treatChineseCharacterAsTwoCharacters:YES]);
}

- (void)test_lengthByVisualizationWithString {
    NSString *string;
    NSInteger output;
    
    // Case 1
    string = @"";
    output = [WCStringTool lengthByVisualizationWithString:string];
    XCTAssertTrue(output == 1);
    
    // Case 2
    string = @"中文";
    output = [WCStringTool lengthByVisualizationWithString:string];
    XCTAssertTrue(output == 2);
    
    // Case 3
    string = @"🇨🇳";
    output = [WCStringTool lengthByVisualizationWithString:string];
    XCTAssertTrue(output == 1);
    
    // Case 4
    string = @"🌎";
    output = [WCStringTool lengthByVisualizationWithString:string];
    XCTAssertTrue(output == 1);
    
    // Case 5
    string = @"haha😁";
    output = [WCStringTool lengthByVisualizationWithString:string];
    XCTAssertTrue(output == 5);
}

- (void)test_occurrenceOfSubstringInString_substring {
    NSString *string;
    NSString *substring;
    NSInteger output;
    
    // Case 1
    string = @"%@:%@";
    substring = @"%@";
    output = [WCStringTool occurrenceOfSubstringInString:string substring:@"%@"];
    XCTAssertTrue(output == 2);
    
    // Case 2
    string = @"%@%@";
    substring = @"%@";
    output = [WCStringTool occurrenceOfSubstringInString:string substring:@"%@"];
    XCTAssertTrue(output == 2);
    
    // Case 3
    string = @"%@";
    substring = @"%@";
    output = [WCStringTool occurrenceOfSubstringInString:string substring:@"%@"];
    XCTAssertTrue(output == 1);
}

#pragma mark > String Lowercase/Uppercase

- (void)test_lowercaseStringWithString_range {
    NSString *string;
    NSString *output;
    
    // Case 1
    string = @"Module";
    output = [WCStringTool lowercaseStringWithString:string range:NSMakeRange(0, 1)];
    XCTAssertEqualObjects(output, @"module");
    
    // Case 2
    string = @"MODULE";
    output = [WCStringTool lowercaseStringWithString:string range:NSMakeRange(0, 2)];
    XCTAssertEqualObjects(output, @"moDULE");
    
    // Case 3
    string = @"MODULE";
    output = [WCStringTool lowercaseStringWithString:string range:NSMakeRange(2, 2)];
    XCTAssertEqualObjects(output, @"MOduLE");
    
    // Case 4
    string = @"MODULE";
    output = [WCStringTool lowercaseStringWithString:string range:NSMakeRange(1, NSUIntegerMax)];
    XCTAssertEqualObjects(output, @"Module");
}

- (void)test_uppercaseStringWithString_range {
    NSString *string;
    NSString *output;
    
    // Case 1
    string = @"module";
    output = [WCStringTool uppercaseStringWithString:string range:NSMakeRange(0, 1)];
    XCTAssertEqualObjects(output, @"Module");
    
    // Case 2
    string = @"module";
    output = [WCStringTool uppercaseStringWithString:string range:NSMakeRange(0, 2)];
    XCTAssertEqualObjects(output, @"MOdule");
    
    // Case 3
    string = @"module";
    output = [WCStringTool uppercaseStringWithString:string range:NSMakeRange(2, 2)];
    XCTAssertEqualObjects(output, @"moDUle");
    
    // Case 3
    string = @"module";
    output = [WCStringTool uppercaseStringWithString:string range:NSMakeRange(1, NSUIntegerMax)];
    XCTAssertEqualObjects(output, @"mODULE");
}

#pragma mark > String Char

- (void)test_stringCharWithString_atIndex {
    NSString *string;
    NSString *output;
    
    // Case 1
    string = @"中国🇨🇳美国🇺🇸文字";
    output = [WCStringTool stringCharWithString:string atIndex:0];
    XCTAssertEqualObjects(output, @"中");
    
    output = [WCStringTool stringCharWithString:string atIndex:1];
    XCTAssertEqualObjects(output, @"国");
    
    output = [WCStringTool stringCharWithString:string atIndex:2];
    XCTAssertEqualObjects(output, @"🇨🇳");
    
    output = [WCStringTool stringCharWithString:string atIndex:3];
    XCTAssertEqualObjects(output, @"美");
    
    output = [WCStringTool stringCharWithString:string atIndex:5];
    XCTAssertEqualObjects(output, @"🇺🇸");
}

- (void)test_isLetterWithString_atIndex {
    NSString *string;
    BOOL output;
    
    // Case 1
    string = @"中国C🇨🇳c012";
    output = [WCStringTool isLetterWithString:string atIndex:0];
    XCTAssertFalse(output);
    
    output = [WCStringTool isLetterWithString:string atIndex:1];
    XCTAssertFalse(output);
    
    output = [WCStringTool isLetterWithString:string atIndex:2];
    XCTAssertTrue(output);
    
    output = [WCStringTool isLetterWithString:string atIndex:3];
    XCTAssertFalse(output);
    
    output = [WCStringTool isLetterWithString:string atIndex:4];
    XCTAssertTrue(output);
}

- (void)test_isUpperCaseLetterWithString_atIndex {
    NSString *string;
    BOOL output;
    
    // Case 1
    string = @"中国C🇨🇳c012";
    output = [WCStringTool isUpperCaseLetterWithString:string atIndex:0];
    XCTAssertFalse(output);
    
    output = [WCStringTool isUpperCaseLetterWithString:string atIndex:1];
    XCTAssertFalse(output);
    
    output = [WCStringTool isUpperCaseLetterWithString:string atIndex:2];
    XCTAssertTrue(output);
    
    output = [WCStringTool isUpperCaseLetterWithString:string atIndex:3];
    XCTAssertFalse(output);
    
    output = [WCStringTool isUpperCaseLetterWithString:string atIndex:4];
    XCTAssertFalse(output);
}

- (void)test_isLowerCaseLetterWithString_atIndex {
    NSString *string;
    BOOL output;
    
    // Case 1
    string = @"中国C🇨🇳c012";
    output = [WCStringTool isLowerCaseLetterWithString:string atIndex:0];
    XCTAssertFalse(output);
    
    output = [WCStringTool isLowerCaseLetterWithString:string atIndex:1];
    XCTAssertFalse(output);
    
    output = [WCStringTool isLowerCaseLetterWithString:string atIndex:2];
    XCTAssertFalse(output);
    
    output = [WCStringTool isLowerCaseLetterWithString:string atIndex:3];
    XCTAssertFalse(output);
    
    output = [WCStringTool isLowerCaseLetterWithString:string atIndex:4];
    XCTAssertTrue(output);
}

#pragma mark - Handle String As HTML

- (void)test_stripTagsWithHTMLString {
    NSString *htmlString;
    htmlString = @"<html>This is a html <font style=\"blah\">string</font>.</html>";
    NSLog(@"%@", [WCStringTool stripTagsWithHTMLString:htmlString]);
}

#pragma mark - Handle String As Path

- (void)test_pathWithPathString_relativeToPath {
    XCTAssertEqualObjects([WCStringTool pathWithPathString:@"/a" relativeToPath:@"/"], @"a", @"should equal");
    XCTAssertEqualObjects([WCStringTool pathWithPathString:@"a/b" relativeToPath:@"a"], @"b", @"");
    XCTAssertEqualObjects([WCStringTool pathWithPathString:@"a/b/c" relativeToPath:@"a"], @"b/c", @"");
    XCTAssertEqualObjects([WCStringTool pathWithPathString:@"a/b/c" relativeToPath:@"a/b"], @"c", @"");
    XCTAssertEqualObjects([WCStringTool pathWithPathString:@"a/b/c" relativeToPath:@"a/d"], @"../b/c", @"");
    XCTAssertEqualObjects([WCStringTool pathWithPathString:@"a/b/c" relativeToPath:@"a/d/e"], @"../../b/c", @"");
    XCTAssertEqualObjects([WCStringTool pathWithPathString:@"/a/b/c" relativeToPath:@"/d/e/f"], @"../../../a/b/c", @"");
}

- (void)test_binaryStringFromInt64 {
    int64_t intValue = 16;
    NSLog(@"%lld = %@", intValue, [WCStringTool binaryStringFromInt64:intValue]);
    
    intValue = -1;
    NSLog(@"%lld = %@", intValue, [WCStringTool binaryStringFromInt64:intValue]);
    
    intValue = 2147483647;
    NSLog(@"%lld = %@", intValue, [WCStringTool binaryStringFromInt64:intValue]);
    
    intValue = -2147483648;
    NSLog(@"%lld = %@", intValue, [WCStringTool binaryStringFromInt64:intValue]);
    
    NSLog(@"%d = %@", INT32_MAX, [WCStringTool binaryStringFromInt64:INT32_MAX]);
    NSLog(@"%d = %@", INT32_MIN, [WCStringTool binaryStringFromInt64:INT32_MIN]);
    
    intValue = 9223372036854775807LL;
    NSLog(@"%lld = %@", intValue, [WCStringTool binaryStringFromInt64:intValue]);
    
    intValue = (-INT64_MAX-1);
    NSLog(@"%lld = %@", intValue, [WCStringTool binaryStringFromInt64:intValue]);
    
    NSLog(@"%lld = %@", INT64_MAX, [WCStringTool binaryStringFromInt64:INT64_MAX]);
    NSLog(@"%lld = %@", INT64_MIN, [WCStringTool binaryStringFromInt64:INT64_MIN]);
}

- (void)test_binaryStringFromInt32 {
    int intValue = 16;
    NSLog(@"%d = %@", intValue, [WCStringTool binaryStringFromInt32:intValue]);
    
    intValue = -1;
    NSLog(@"%d = %@", intValue, [WCStringTool binaryStringFromInt32:intValue]);
    
    intValue = 2147483647;
    NSLog(@"%d = %@", intValue, [WCStringTool binaryStringFromInt32:intValue]);
    
    intValue = -2147483648;
    NSLog(@"%d = %@", intValue, [WCStringTool binaryStringFromInt32:intValue]);
    
    NSLog(@"%d = %@", INT32_MAX, [WCStringTool binaryStringFromInt32:INT32_MAX]);
    NSLog(@"%d = %@", INT32_MIN, [WCStringTool binaryStringFromInt32:INT32_MIN]);
}

- (void)test_binaryStringFromInt16 {
    int intValue = 16;
    NSLog(@"%d = %@", intValue, [WCStringTool binaryStringFromInt16:intValue]);
    
    intValue = -1;
    NSLog(@"%d = %@", intValue, [WCStringTool binaryStringFromInt16:intValue]);
    
    intValue = 32767;
    NSLog(@"%d = %@", intValue, [WCStringTool binaryStringFromInt16:intValue]);
    
    intValue = -32768;
    NSLog(@"%d = %@", intValue, [WCStringTool binaryStringFromInt16:intValue]);
    
    NSLog(@"%d = %@", INT16_MAX, [WCStringTool binaryStringFromInt16:INT16_MAX]);
    NSLog(@"%d = %@", INT16_MIN, [WCStringTool binaryStringFromInt16:INT16_MIN]);
}

- (void)test_binaryStringFromInt8 {
    short shortValue = 16;
    NSLog(@"%d = %@", shortValue, [WCStringTool binaryStringFromInt8:shortValue]);
    
    shortValue = -1;
    NSLog(@"%d = %@", shortValue, [WCStringTool binaryStringFromInt8:shortValue]);
    
    shortValue = 127;
    NSLog(@"%d = %@", shortValue, [WCStringTool binaryStringFromInt8:shortValue]);
    
    shortValue = -128;
    NSLog(@"%d = %@", shortValue, [WCStringTool binaryStringFromInt8:shortValue]);
    
    NSLog(@"%d = %@", INT8_MAX, [WCStringTool binaryStringFromInt8:INT8_MAX]);
    NSLog(@"%d = %@", INT8_MIN, [WCStringTool binaryStringFromInt8:INT8_MIN]);
}

#pragma mark - Handle String As Number

- (void)test_removeTrailZerosWithNumberString {
    NSString *string;
    NSString *output;
    
    // Case 1
    string = @"1000";
    output = [WCStringTool removeTrailZerosWithNumberString:string];
    XCTAssertEqualObjects(output, @"1000");
    
    // Case 2
    string = @"10.000";
    output = [WCStringTool removeTrailZerosWithNumberString:string];
    XCTAssertEqualObjects(output, @"10");

    // Case 3
    string = @"10.0100";
    output = [WCStringTool removeTrailZerosWithNumberString:string];
    XCTAssertEqualObjects(output, @"10.01");

    // Case 3
    string = @"10.1234";
    output = [WCStringTool removeTrailZerosWithNumberString:string];
    XCTAssertEqualObjects(output, @"10.1234");
}

#pragma mark - Cryption

#pragma mark > MD5

- (void)test_MD5WithString {
    XCTAssertTrue([WCStringTool MD5WithString:@"abc"].length == 32);
    XCTAssertNil([WCStringTool MD5WithString:@""]);
    NSString *nilString = nil;
    XCTAssertNil([WCStringTool MD5WithString:nilString]);
    NSLog(@"%@", [WCStringTool MD5WithString:@"abc"]);
}

#pragma mark > Base64 Encode/Decode

- (void)test_base64EncodedStringWithString {
    NSString *encodedString;
    NSString *plainString;
    
    // Case 1
    encodedString = [WCStringTool base64EncodedStringWithString:@"恭喜发财，大吉大利！"];
    XCTAssertEqualObjects(encodedString, @"5oGt5Zac5Y+R6LSi77yM5aSn5ZCJ5aSn5Yip77yB");
    
    // Case 2
    encodedString = [WCStringTool base64EncodedStringWithString:@"Hello, world!"];
    XCTAssertEqualObjects(encodedString, @"SGVsbG8sIHdvcmxkIQ==");
    
    // Case 3
    plainString = STR_OF_JSON(
                              Mean, median, and mode are different measures of center in a numerical data set. They each try to summarize a dataset with a single number to represent a "typical" data point from the dataset.
                              Mean: The "average" number; found by adding all data points and dividing by the number of data points.
                              Example: The mean of 444, 111, and 777 is (4+1+7)/3 = 12/3 = 4(4+1+7)/3=12/3=4left parenthesis, 4, plus, 1, plus, 7, right parenthesis, slash, 3, equals, 12, slash, 3, equals, 4.
                              Median: The middle number; found by ordering all data points and picking out the one in the middle (or if there are two middle numbers, taking the mean of those two numbers).
                              Example: The median of 444, 111, and 777 is 444 because when the numbers are put in order (1(1left parenthesis, 1, 444, 7)7)7, right parenthesis, the number 444 is in the middle.
    );
    encodedString = [WCStringTool base64EncodedStringWithString:plainString];
    XCTAssertEqualObjects(encodedString, @"TWVhbiwgbWVkaWFuLCBhbmQgbW9kZSBhcmUgZGlmZmVyZW50IG1lYXN1cmVzIG9mIGNlbnRlciBpbiBhIG51bWVyaWNhbCBkYXRhIHNldC4gVGhleSBlYWNoIHRyeSB0byBzdW1tYXJpemUgYSBkYXRhc2V0IHdpdGggYSBzaW5nbGUgbnVtYmVyIHRvIHJlcHJlc2VudCBhICJ0eXBpY2FsIiBkYXRhIHBvaW50IGZyb20gdGhlIGRhdGFzZXQuIE1lYW46IFRoZSAiYXZlcmFnZSIgbnVtYmVyOyBmb3VuZCBieSBhZGRpbmcgYWxsIGRhdGEgcG9pbnRzIGFuZCBkaXZpZGluZyBieSB0aGUgbnVtYmVyIG9mIGRhdGEgcG9pbnRzLiBFeGFtcGxlOiBUaGUgbWVhbiBvZiA0NDQsIDExMSwgYW5kIDc3NyBpcyAoNCsxKzcpLzMgPSAxMi8zID0gNCg0KzErNykvMz0xMi8zPTRsZWZ0IHBhcmVudGhlc2lzLCA0LCBwbHVzLCAxLCBwbHVzLCA3LCByaWdodCBwYXJlbnRoZXNpcywgc2xhc2gsIDMsIGVxdWFscywgMTIsIHNsYXNoLCAzLCBlcXVhbHMsIDQuIE1lZGlhbjogVGhlIG1pZGRsZSBudW1iZXI7IGZvdW5kIGJ5IG9yZGVyaW5nIGFsbCBkYXRhIHBvaW50cyBhbmQgcGlja2luZyBvdXQgdGhlIG9uZSBpbiB0aGUgbWlkZGxlIChvciBpZiB0aGVyZSBhcmUgdHdvIG1pZGRsZSBudW1iZXJzLCB0YWtpbmcgdGhlIG1lYW4gb2YgdGhvc2UgdHdvIG51bWJlcnMpLiBFeGFtcGxlOiBUaGUgbWVkaWFuIG9mIDQ0NCwgMTExLCBhbmQgNzc3IGlzIDQ0NCBiZWNhdXNlIHdoZW4gdGhlIG51bWJlcnMgYXJlIHB1dCBpbiBvcmRlciAoMSgxbGVmdCBwYXJlbnRoZXNpcywgMSwgNDQ0LCA3KTcpNywgcmlnaHQgcGFyZW50aGVzaXMsIHRoZSBudW1iZXIgNDQ0IGlzIGluIHRoZSBtaWRkbGUu");
}

- (void)test_base64EncodedStringWithString_options {
    NSString *encodedString;
    NSString *decodedString;
    NSString *plainString;
    
    // Case 1
    encodedString = [WCStringTool base64EncodedStringWithString:@"恭喜发财，大吉大利！" options:NSDataBase64Encoding64CharacterLineLength];
    XCTAssertEqualObjects(encodedString, @"5oGt5Zac5Y+R6LSi77yM5aSn5ZCJ5aSn5Yip77yB");
    
    // Case 2
    encodedString = [WCStringTool base64EncodedStringWithString:@"Hello, world!" options:NSDataBase64Encoding64CharacterLineLength];
    XCTAssertEqualObjects(encodedString, @"SGVsbG8sIHdvcmxkIQ==");
    
    // Case 3
    plainString = STR_OF_JSON(
                              Mean, median, and mode are different measures of center in a numerical data set. They each try to summarize a dataset with a single number to represent a "typical" data point from the dataset.
                              Mean: The "average" number; found by adding all data points and dividing by the number of data points.
                              Example: The mean of 444, 111, and 777 is (4+1+7)/3 = 12/3 = 4(4+1+7)/3=12/3=4left parenthesis, 4, plus, 1, plus, 7, right parenthesis, slash, 3, equals, 12, slash, 3, equals, 4.
                              Median: The middle number; found by ordering all data points and picking out the one in the middle (or if there are two middle numbers, taking the mean of those two numbers).
                              Example: The median of 444, 111, and 777 is 444 because when the numbers are put in order (1(1left parenthesis, 1, 444, 7)7)7, right parenthesis, the number 444 is in the middle.
                              );
    encodedString = [WCStringTool base64EncodedStringWithString:plainString options:NSDataBase64Encoding64CharacterLineLength];
    
    decodedString = STR_OF_JSON(
                                TWVhbiwgbWVkaWFuLCBhbmQgbW9kZSBhcmUgZGlmZmVyZW50IG1lYXN1cmVzIG9m
                                IGNlbnRlciBpbiBhIG51bWVyaWNhbCBkYXRhIHNldC4gVGhleSBlYWNoIHRyeSB0
                                byBzdW1tYXJpemUgYSBkYXRhc2V0IHdpdGggYSBzaW5nbGUgbnVtYmVyIHRvIHJl
                                cHJlc2VudCBhICJ0eXBpY2FsIiBkYXRhIHBvaW50IGZyb20gdGhlIGRhdGFzZXQu
                                IE1lYW46IFRoZSAiYXZlcmFnZSIgbnVtYmVyOyBmb3VuZCBieSBhZGRpbmcgYWxs
                                IGRhdGEgcG9pbnRzIGFuZCBkaXZpZGluZyBieSB0aGUgbnVtYmVyIG9mIGRhdGEg
                                cG9pbnRzLiBFeGFtcGxlOiBUaGUgbWVhbiBvZiA0NDQsIDExMSwgYW5kIDc3NyBp
                                cyAoNCsxKzcpLzMgPSAxMi8zID0gNCg0KzErNykvMz0xMi8zPTRsZWZ0IHBhcmVu
                                dGhlc2lzLCA0LCBwbHVzLCAxLCBwbHVzLCA3LCByaWdodCBwYXJlbnRoZXNpcywg
                                c2xhc2gsIDMsIGVxdWFscywgMTIsIHNsYXNoLCAzLCBlcXVhbHMsIDQuIE1lZGlh
                                bjogVGhlIG1pZGRsZSBudW1iZXI7IGZvdW5kIGJ5IG9yZGVyaW5nIGFsbCBkYXRh
                                IHBvaW50cyBhbmQgcGlja2luZyBvdXQgdGhlIG9uZSBpbiB0aGUgbWlkZGxlIChv
                                ciBpZiB0aGVyZSBhcmUgdHdvIG1pZGRsZSBudW1iZXJzLCB0YWtpbmcgdGhlIG1l
                                YW4gb2YgdGhvc2UgdHdvIG51bWJlcnMpLiBFeGFtcGxlOiBUaGUgbWVkaWFuIG9m
                                IDQ0NCwgMTExLCBhbmQgNzc3IGlzIDQ0NCBiZWNhdXNlIHdoZW4gdGhlIG51bWJl
                                cnMgYXJlIHB1dCBpbiBvcmRlciAoMSgxbGVmdCBwYXJlbnRoZXNpcywgMSwgNDQ0
                                LCA3KTcpNywgcmlnaHQgcGFyZW50aGVzaXMsIHRoZSBudW1iZXIgNDQ0IGlzIGlu
                                IHRoZSBtaWRkbGUu
                                );
    decodedString = [[decodedString componentsSeparatedByString:@" "] componentsJoinedByString:@"\r\n"];
    XCTAssertEqualObjects(encodedString, decodedString);
    
    // Case 4
    plainString = STR_OF_JSON(
                              Mean, median, and mode are different measures of center in a numerical data set. They each try to summarize a dataset with a single number to represent a "typical" data point from the dataset.
                              Mean: The "average" number; found by adding all data points and dividing by the number of data points.
                              Example: The mean of 444, 111, and 777 is (4+1+7)/3 = 12/3 = 4(4+1+7)/3=12/3=4left parenthesis, 4, plus, 1, plus, 7, right parenthesis, slash, 3, equals, 12, slash, 3, equals, 4.
                              Median: The middle number; found by ordering all data points and picking out the one in the middle (or if there are two middle numbers, taking the mean of those two numbers).
                              Example: The median of 444, 111, and 777 is 444 because when the numbers are put in order (1(1left parenthesis, 1, 444, 7)7)7, right parenthesis, the number 444 is in the middle.
                              );
    encodedString = [WCStringTool base64EncodedStringWithString:plainString options:NSDataBase64Encoding76CharacterLineLength | NSDataBase64EncodingEndLineWithLineFeed];
    
    decodedString = STR_OF_JSON(
                                TWVhbiwgbWVkaWFuLCBhbmQgbW9kZSBhcmUgZGlmZmVyZW50IG1lYXN1cmVzIG9mIGNlbnRlciBp
                                biBhIG51bWVyaWNhbCBkYXRhIHNldC4gVGhleSBlYWNoIHRyeSB0byBzdW1tYXJpemUgYSBkYXRh
                                c2V0IHdpdGggYSBzaW5nbGUgbnVtYmVyIHRvIHJlcHJlc2VudCBhICJ0eXBpY2FsIiBkYXRhIHBv
                                aW50IGZyb20gdGhlIGRhdGFzZXQuIE1lYW46IFRoZSAiYXZlcmFnZSIgbnVtYmVyOyBmb3VuZCBi
                                eSBhZGRpbmcgYWxsIGRhdGEgcG9pbnRzIGFuZCBkaXZpZGluZyBieSB0aGUgbnVtYmVyIG9mIGRh
                                dGEgcG9pbnRzLiBFeGFtcGxlOiBUaGUgbWVhbiBvZiA0NDQsIDExMSwgYW5kIDc3NyBpcyAoNCsx
                                KzcpLzMgPSAxMi8zID0gNCg0KzErNykvMz0xMi8zPTRsZWZ0IHBhcmVudGhlc2lzLCA0LCBwbHVz
                                LCAxLCBwbHVzLCA3LCByaWdodCBwYXJlbnRoZXNpcywgc2xhc2gsIDMsIGVxdWFscywgMTIsIHNs
                                YXNoLCAzLCBlcXVhbHMsIDQuIE1lZGlhbjogVGhlIG1pZGRsZSBudW1iZXI7IGZvdW5kIGJ5IG9y
                                ZGVyaW5nIGFsbCBkYXRhIHBvaW50cyBhbmQgcGlja2luZyBvdXQgdGhlIG9uZSBpbiB0aGUgbWlk
                                ZGxlIChvciBpZiB0aGVyZSBhcmUgdHdvIG1pZGRsZSBudW1iZXJzLCB0YWtpbmcgdGhlIG1lYW4g
                                b2YgdGhvc2UgdHdvIG51bWJlcnMpLiBFeGFtcGxlOiBUaGUgbWVkaWFuIG9mIDQ0NCwgMTExLCBh
                                bmQgNzc3IGlzIDQ0NCBiZWNhdXNlIHdoZW4gdGhlIG51bWJlcnMgYXJlIHB1dCBpbiBvcmRlciAo
                                MSgxbGVmdCBwYXJlbnRoZXNpcywgMSwgNDQ0LCA3KTcpNywgcmlnaHQgcGFyZW50aGVzaXMsIHRo
                                ZSBudW1iZXIgNDQ0IGlzIGluIHRoZSBtaWRkbGUu
                                );
    decodedString = [[decodedString componentsSeparatedByString:@" "] componentsJoinedByString:@"\n"];
    XCTAssertEqualObjects(encodedString, decodedString);
    
    // Case 5
    plainString = STR_OF_JSON(
                              Mean, median, and mode are different measures of center in a numerical data set. They each try to summarize a dataset with a single number to represent a "typical" data point from the dataset.
                              Mean: The "average" number; found by adding all data points and dividing by the number of data points.
                              Example: The mean of 444, 111, and 777 is (4+1+7)/3 = 12/3 = 4(4+1+7)/3=12/3=4left parenthesis, 4, plus, 1, plus, 7, right parenthesis, slash, 3, equals, 12, slash, 3, equals, 4.
                              Median: The middle number; found by ordering all data points and picking out the one in the middle (or if there are two middle numbers, taking the mean of those two numbers).
                              Example: The median of 444, 111, and 777 is 444 because when the numbers are put in order (1(1left parenthesis, 1, 444, 7)7)7, right parenthesis, the number 444 is in the middle.
                              );
    encodedString = [WCStringTool base64EncodedStringWithString:plainString options:NSDataBase64Encoding76CharacterLineLength | NSDataBase64EncodingEndLineWithCarriageReturn];
    
    decodedString = STR_OF_JSON(
                                TWVhbiwgbWVkaWFuLCBhbmQgbW9kZSBhcmUgZGlmZmVyZW50IG1lYXN1cmVzIG9mIGNlbnRlciBp
                                biBhIG51bWVyaWNhbCBkYXRhIHNldC4gVGhleSBlYWNoIHRyeSB0byBzdW1tYXJpemUgYSBkYXRh
                                c2V0IHdpdGggYSBzaW5nbGUgbnVtYmVyIHRvIHJlcHJlc2VudCBhICJ0eXBpY2FsIiBkYXRhIHBv
                                aW50IGZyb20gdGhlIGRhdGFzZXQuIE1lYW46IFRoZSAiYXZlcmFnZSIgbnVtYmVyOyBmb3VuZCBi
                                eSBhZGRpbmcgYWxsIGRhdGEgcG9pbnRzIGFuZCBkaXZpZGluZyBieSB0aGUgbnVtYmVyIG9mIGRh
                                dGEgcG9pbnRzLiBFeGFtcGxlOiBUaGUgbWVhbiBvZiA0NDQsIDExMSwgYW5kIDc3NyBpcyAoNCsx
                                KzcpLzMgPSAxMi8zID0gNCg0KzErNykvMz0xMi8zPTRsZWZ0IHBhcmVudGhlc2lzLCA0LCBwbHVz
                                LCAxLCBwbHVzLCA3LCByaWdodCBwYXJlbnRoZXNpcywgc2xhc2gsIDMsIGVxdWFscywgMTIsIHNs
                                YXNoLCAzLCBlcXVhbHMsIDQuIE1lZGlhbjogVGhlIG1pZGRsZSBudW1iZXI7IGZvdW5kIGJ5IG9y
                                ZGVyaW5nIGFsbCBkYXRhIHBvaW50cyBhbmQgcGlja2luZyBvdXQgdGhlIG9uZSBpbiB0aGUgbWlk
                                ZGxlIChvciBpZiB0aGVyZSBhcmUgdHdvIG1pZGRsZSBudW1iZXJzLCB0YWtpbmcgdGhlIG1lYW4g
                                b2YgdGhvc2UgdHdvIG51bWJlcnMpLiBFeGFtcGxlOiBUaGUgbWVkaWFuIG9mIDQ0NCwgMTExLCBh
                                bmQgNzc3IGlzIDQ0NCBiZWNhdXNlIHdoZW4gdGhlIG51bWJlcnMgYXJlIHB1dCBpbiBvcmRlciAo
                                MSgxbGVmdCBwYXJlbnRoZXNpcywgMSwgNDQ0LCA3KTcpNywgcmlnaHQgcGFyZW50aGVzaXMsIHRo
                                ZSBudW1iZXIgNDQ0IGlzIGluIHRoZSBtaWRkbGUu
                                );
    decodedString = [[decodedString componentsSeparatedByString:@" "] componentsJoinedByString:@"\r"];
    XCTAssertEqualObjects(encodedString, decodedString);
}

- (void)test_base64DecodedStringWithString {
    NSString *encodedString;
    NSString *decodedString;
    NSString *plainString;
    
    // Case 1
    plainString = @"恭喜发财，大吉大利！";
    encodedString = [WCStringTool base64EncodedStringWithString:plainString];
    decodedString = [WCStringTool base64DecodedStringWithString:encodedString];
    XCTAssertEqualObjects(decodedString, plainString);
    
    // Case 2
    plainString = @"Hello, world!";
    encodedString = [WCStringTool base64EncodedStringWithString:plainString];
    decodedString = [WCStringTool base64DecodedStringWithString:encodedString];
    XCTAssertEqualObjects(decodedString, plainString);
    
    // Case 3
    plainString = STR_OF_JSON(
                              Mean, median, and mode are different measures of center in a numerical data set. They each try to summarize a dataset with a single number to represent a "typical" data point from the dataset.
                              Mean: The "average" number; found by adding all data points and dividing by the number of data points.
                              Example: The mean of 444, 111, and 777 is (4+1+7)/3 = 12/3 = 4(4+1+7)/3=12/3=4left parenthesis, 4, plus, 1, plus, 7, right parenthesis, slash, 3, equals, 12, slash, 3, equals, 4.
                              Median: The middle number; found by ordering all data points and picking out the one in the middle (or if there are two middle numbers, taking the mean of those two numbers).
                              Example: The median of 444, 111, and 777 is 444 because when the numbers are put in order (1(1left parenthesis, 1, 444, 7)7)7, right parenthesis, the number 444 is in the middle.
                              );
    encodedString = [WCStringTool base64EncodedStringWithString:plainString];
    decodedString = [WCStringTool base64DecodedStringWithString:encodedString];
    XCTAssertEqualObjects(decodedString, plainString);
    
    // Case 4
    plainString = STR_OF_JSON(
                              Mean, median, and mode are different measures of center in a numerical data set. They each try to summarize a dataset with a single number to represent a "typical" data point from the dataset.
                              Mean: The "average" number; found by adding all data points and dividing by the number of data points.
                              Example: The mean of 444, 111, and 777 is (4+1+7)/3 = 12/3 = 4(4+1+7)/3=12/3=4left parenthesis, 4, plus, 1, plus, 7, right parenthesis, slash, 3, equals, 12, slash, 3, equals, 4.
                              Median: The middle number; found by ordering all data points and picking out the one in the middle (or if there are two middle numbers, taking the mean of those two numbers).
                              Example: The median of 444, 111, and 777 is 444 because when the numbers are put in order (1(1left parenthesis, 1, 444, 7)7)7, right parenthesis, the number 444 is in the middle.
                              );
    encodedString = [WCStringTool base64EncodedStringWithString:plainString options:NSDataBase64Encoding64CharacterLineLength];
    decodedString = [WCStringTool base64DecodedStringWithString:encodedString];
    XCTAssertEqualObjects(decodedString, plainString);
}

#pragma mark - Others

- (void)test1 {
#define NSPREDICATE(expression)    ([NSPredicate predicateWithFormat:@"SELF MATCHES %@", expression])
    
    NSString *str = @"\u00b7";
    NSLog(@"%@", str);
    NSLog(@"%@", @"·");
    NSLog(@"%@", @"·");
    
    NSString *text = @"你好·哈好·你好";//·你好
    if ([NSPREDICATE(@"^[\u4e00-\u9fa5]{2,5}(?:\u00b7[\u4e00-\u9fa5]{2,5})*$") evaluateWithObject:text]) {
        NSLog(@"pass");
    }
}

- (NSArray<NSString *> *)_parseEventsArrayFromEvent:(NSString *)aEvent {
    NSArray *events = nil;
    
    if ([aEvent rangeOfString:@"{"].location != NSNotFound || [aEvent rangeOfString:@"["].location != NSNotFound) {
        NSData *jsonData = [aEvent dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObject = nil;
        @try {
            jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
        } @catch (NSException *exception) {
            jsonObject = nil;
        }
        
        if ([jsonObject isKindOfClass:[NSArray class]]) {
            events = jsonObject;
        } else if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            events = jsonObject[@"action"];
            if (![events isKindOfClass:[NSArray class]]) { events = nil; }
        }
    } else if (aEvent != nil) {
        events = @[aEvent];
    }
    
    return events;
}

- (void)test_unescapedString {
    NSString *event = @"wangx://recommendItems/show?data={\"api\":\"mtop.cb.menu.event\",\"needSession\":true,\"needencode\":true,\"params\":{\"handlerBonding\":{\"handlerContent\":{\"sellerId\":2257290474,\"instanceId\":8020,\"activityTag\":0,\"rettype\":\"tao\"}, \"handlerKey\":\"cbinteraction-itemRecommend\"}}}";
    
    event = @"wangx://recommendItems/show?data=%7B%22api%22%3A%22mtop.cb.menu.event%22%2C%22needSession%22%3Atrue%2C%22needencode%22%3Atrue%2C%22params%22%3A%7B%22handlerBonding%22%3A%7B%22handlerContent%22%3A%7B%22sellerId%22%3A2257290474%2C%22instanceId%22%3A8020%2C%22activityTag%22%3A0%2C%22rettype%22%3A%22tao%22%7D%2C%20%22handlerKey%22%3A%22cbinteraction-itemRecommend%22%7D%7D%7D";
    event = @"wangx://p2sconversation/package?toId=cntaobaoww店铺测试账号003&serviceType=cloud_auto_reply&bizType=3&cardCode=cb_shop_recommend&title=猜你喜欢&fromId=cntaobaowc测试账号1000&intent=doNormalCardAction&bot_action=CbSmartMenuAction";
    
    BOOL success = [self _parseEventsArrayFromEvent:event];
    NSLog(@"%@", success ? @"YES" : @"NO");
}

- (void)test_ulrstring {
//    NSString *s1 = @"g\u2006h";
//    NSData *data = [s1 dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *s3 = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
//
//    NSLog(@"%@", [s1 urlEncodedString]);
//    NSLog(@"%@", [s1 urlEncodedStringWithEncoding:NSUnicodeStringEncoding]);
//
//    NSString *s2 = @"g h";
//    NSLog(@"%@", [s2 urlEncodedString]);
//    NSLog(@"%@", [s2 urlEncodedStringWithEncoding:NSUTF8StringEncoding]);
    
    
//    NSString *unicodedString = @"😃";
//    NSData *unicodedStringData = [unicodedString dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *emojiStringValue = [[NSString alloc] initWithData:unicodedStringData encoding:NSNonLossyASCIIStringEncoding];
    
    NSString *s1 = @"g\u2006h";
    NSString *s4 = @"g h";
    NSLog(@"%@", [s1 dataUsingEncoding:NSUTF8StringEncoding]);
    NSLog(@"%@", [s4 dataUsingEncoding:NSUTF8StringEncoding]);
    
    NSLog(@"%@", s1);
    NSLog(@"%@", s4);
    
    const char *cString = s1.UTF8String;
    NSData *data = [NSData dataWithBytes:cString length:strlen(cString)];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"string: %@", [string dataUsingEncoding:NSASCIIStringEncoding]);
    NSLog(@"%@", [WCStringTool URLEscapedStringWithString:string]);
    
    NSString *space1 = @"\u2006";
    NSString *space2 = @" ";
//    space2 = @"\u0041";
    
    space1 = [space1 stringByReplacingOccurrencesOfString:@"\u2006" withString:@" "];
    
    if ([space1 isEqualToString:space2]) {
        NSLog(@"equal");
    }
    else {
        NSLog(@"not equal");
    }
    
    NSString *str = @"\u5404\u500b\u90fd";
    NSLog(@"%@", str);
}

- (void)test_mutableString {
    NSMutableString *string;
    
    // Case 1
    string = [@"0123456789" mutableCopy];
    
    
}

- (void)test_iterate_characters {
    // Case 1: @see https://gist.github.com/kharmabum/9455944
    
    NSString *s = @"The weather on \U0001F30D is \U0001F31E today.";
    // The weather on 🌍 is 🌞 today.
    NSRange fullRange = NSMakeRange(0, [s length]);
    [s enumerateSubstringsInRange:fullRange
                          options:NSStringEnumerationByComposedCharacterSequences
                       usingBlock:^(NSString *substring, NSRange substringRange,
                                    NSRange enclosingRange, BOOL *stop) {
        NSLog(@"%@ %@", substring, NSStringFromRange(substringRange));
    }];
}
                  
- (NSCharacterSet *)URLAllowedCharacterSet {
    static NSMutableCharacterSet *set;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        set = [NSMutableCharacterSet new];
        [set formUnionWithCharacterSet:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        [set formUnionWithCharacterSet:[NSCharacterSet URLHostAllowedCharacterSet]];
        [set formUnionWithCharacterSet:[NSCharacterSet URLPasswordAllowedCharacterSet]];
        [set formUnionWithCharacterSet:[NSCharacterSet URLPathAllowedCharacterSet]];
        [set formUnionWithCharacterSet:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [set formUnionWithCharacterSet:[NSCharacterSet URLUserAllowedCharacterSet]];
        [set formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"%"]];
    });
    return set;
}

@end








