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

- (void)test_keyValuePairsWithUrlString {
    NSString *string;
    NSDictionary *dict;
    
    string = @"wangx://ut/card?page=Page_Message&event=2101&arg1=&arg2=&arg3=&flags=k1,k2,k3&cardtype=1001";
    dict = [WCStringTool keyValuePairsWithUrlString:string];
    NSLog(@"%@", dict);
    
    string = @"page=Page_Message&event=2101&arg1=&arg2=&arg3=&flags=k1,k2,k3&cardtype=1001";
    dict = [WCStringTool keyValuePairsWithUrlString:string];
    XCTAssertTrue(dict.count == 0);
    
    string = @"wangwang://hongbao/query?hongbaoId=13314001535794922&hongbaoType=0&sender=cntaobaoqn店铺测试账号001:晨凉&note=恭喜发财，大吉大利！&hongbaoSubType=0";
    dict = [WCStringTool keyValuePairsWithUrlString:string];
    NSLog(@"%@", dict);
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
#pragma mark - Handle String As Url

- (void)test_valueWithUrlString_forKey {
    NSString *url;
    NSString *value;
    
    // case 1
    url = @"http://m.cp.360.cn/news/mobile/150410515.html?act=1&reffer=ios&titleRight=share&empty=";
    
    NSLog(@"titleRight=%@", [WCStringTool valueWithUrlString:url forKey:@"titleRight"]);
    NSLog(@"act=%@", [WCStringTool valueWithUrlString:url forKey:@"act"]);
    NSLog(@"reffer=%@", [WCStringTool valueWithUrlString:url forKey:@"reffer"]);
    NSLog(@"empty=%@", [WCStringTool valueWithUrlString:url forKey:@"empty"]);
    
    // case 2
    url = @"wangxs://multiaction/and?multi=%5B%22wangx%3A%2F%2Fh5%2Fopen%3Furl%3Dhttp%253a%252f%252fwww.taobao.com%22%2C%22wangx%3A%2F%2Fmenu%2Fdismiss%3Fmenuname%3DMenuNameForShowType%26container%3DpopBubble%26strategy%3Dtransient%26bubbleBizType%3Dtest%26conversationId%3Dcnhhupanww%E5%BA%97%E9%93%BA%E6%B5%8B%E8%AF%95%E8%B4%A6%E5%8F%B7003%22%5D";
    
//    NSLog(@"multi=%@", [WCStringTool valueWithUrlString:url forKey:@"multi"]);
//    NSLog(@"multi (decoded)=%@", [WCStringTool URLUnescapedStringWithString:[WCStringTool valueWithUrlString:url forKey:@"multi"]]);
//    NSLog(@"multi (decoded as array)=%@", [[WCStringTool URLUnescapedStringWithString:[[WCStringTool valueWithUrlString:url forKey:@"multi"]] jsonArray]);
//    NSArray *arr = [[[WCStringTool valueWithUrlString:url forKey:@"multi"] urlDecodedString] jsonArray];
//    NSLog(@"%@", arr);
    
    // case 3
    url = @"https://qngateway.taobao.com/gw/wwjs/multi.resource.emoticon.query?id=144";
    value = [WCStringTool valueWithUrlString:url forKey:@"id"];
    XCTAssertEqualObjects(value, @"144");
    
    // case 4
    url = @"http://interface.im.taobao.com/mobileimweb/fileupload/downloadPriFile.do?type=0&fileId=8f3371144e1317eabc789ea175644e57.jpg&suffix=jpg&width=750&height=555&mediaSize=516784&fromId=cntaobaowc%E6%B5%8B%E8%AF%95%E8%B4%A6%E5%8F%B71000&thumb_width=80&thumb_height=80";
    value = [WCStringTool valueWithUrlString:url forKey:@"width"];
    XCTAssertEqualObjects(value, @"750");
}

- (void)test_valueWithUrlString_forKey_usingConnector_usingSeparator {
    NSString *str = @"Mon:Monday#Tue:Tuesday#Wed:Wednesday#Thurs:Thursday#Fri:Friday#Sat:Saturday#Sun:Sunday";
    
    NSLog(@"Mon=%@", [WCStringTool valueWithUrlString:str forKey:@"Mon" usingConnector:@":" usingSeparator:@"#"]);
    NSLog(@"today=%@", [WCStringTool valueWithUrlString:str forKey:@"today" usingConnector:@":" usingSeparator:@"#"]);
    
    NSString *cookie = @"Q=u%3D360H1491330706%26n%3D%26le%3DoT10MKA0ZvH0ZUSkYzAioD%3D%3D%26m%3D%26qid%3D1491330706%26im%3D1_t00df551a583a87f4e9%26src%3Dmpc_caipiao_os_100000%26t%3D1; T=s%3D70657b22272b33d114f2b6a6d8efcf5c%26t%3D1433590027%26lm%3D%26lf%3D1%26sk%3Db5dcb4c7fa89fe4215b2fea0d7d98d31%26mt%3D1433590027%26rc%3D%26v%3D2.0%26a%3D1";
    NSLog(@"Q=%@", [WCStringTool valueWithUrlString:cookie forKey:@"Q" usingConnector:@"=" usingSeparator:@";"]);
    NSLog(@"T=%@", [WCStringTool valueWithUrlString:cookie forKey:@"T" usingConnector:@"=" usingSeparator:@";"]);
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
    // Test unescape characters [].
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@"["], @"[");
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@"]"], @"]");
    XCTAssertEqualObjects([WCStringTool URLEscapedStringWithString:@"."], @".");
    
    // Test escape characters :/?&=;+!@#$()',*
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
    string = @"2014-11-07 18:36:04";
    
    XCTAssertEqualObjects(@"11-07", [WCStringTool substringWithString:string atLocation:5 length:5]);
    XCTAssertEqualObjects(@"18:36:04", [WCStringTool substringWithString:string atLocation:11 length:NSUIntegerMax]);
    XCTAssertEqualObjects(@"4", [WCStringTool substringWithString:string atLocation:string.length - 1 length:1]);
    XCTAssertEqualObjects(@"4", [WCStringTool substringWithString:string atLocation:string.length - 1 length:4]);
    XCTAssertEqualObjects(@"", [WCStringTool substringWithString:@"abc" atLocation:0 length:0]);
    XCTAssertEqualObjects(@"a", [WCStringTool substringWithString:@"abc" atLocation:0 length:1]);
    
    XCTAssertNil([WCStringTool substringWithString:string atLocation:string.length length:1]);
    XCTAssertNil([WCStringTool substringWithString:@"" atLocation:0 length:1]);
    XCTAssertNil([WCStringTool substringWithString:@"" atLocation:0 length:0]);
    NSString *nilString = nil;
    XCTAssertNil([WCStringTool substringWithString:nilString atLocation:0 length:1]);
    
    // Case 2
    string = @"123";
    XCTAssertEqualObjects(@"123", [WCStringTool substringWithString:string atLocation:0 length:3]);
    XCTAssertEqualObjects(@"23", [WCStringTool substringWithString:string atLocation:1 length:2]);
}

- (void)test_substringWithString_range {
    NSString *string;
    NSString *substring;
    
    // Case 1
    string = @"2014-11-07 18:36:04";
    XCTAssertEqualObjects(@"11-07", [WCStringTool substringWithString:string range:NSMakeRange(5, 5)]);
    XCTAssertEqualObjects(@"4", [WCStringTool substringWithString:string range:NSMakeRange(string.length - 1, 1)]);
    
    // Case 2
    XCTAssertEqualObjects(@"a", [WCStringTool substringWithString:@"abc" range:NSMakeRange(0, 1)]);
    XCTAssertNil([WCStringTool substringWithString:string range:NSMakeRange(string.length - 1, 4)]);
    XCTAssertNil([WCStringTool substringWithString:string range:NSMakeRange(string.length, 1)]);
    XCTAssertNil([WCStringTool substringWithString:@"" range:NSMakeRange(0, 1)]);
    
    // Case 3
    string = @"";
    substring = [string substringWithRange:NSMakeRange(0, 0)];
    XCTAssertEqualObjects(substring, @"");
    
    // Case 4
    string = @"abc";
    substring = [string substringWithRange:NSMakeRange(0, 0)];
    XCTAssertEqualObjects(substring, @"");
    
    XCTAssertEqualObjects([WCStringTool substringWithString:@"abc" range:NSMakeRange(0, 0)], @"");
    XCTAssertNil([WCStringTool substringWithString:@"" range:NSMakeRange(0, 0)]);
    XCTAssertNil([WCStringTool substringWithString:@"" range:NSMakeRange(1, 0)]);
    
    string = nil;
    XCTAssertNil([WCStringTool substringWithString:string range:NSMakeRange(0, 1)]);
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

#pragma mark - Handle String As Plain

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
    
    // case 1
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
    
    // case 2
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
    
    
    // case 3
    args = @[
             @"a",
             @"b",
             @"c"
             ];
    string = [WCStringTool stringWithFormat:@"%@%@" arguments:args];
    NSLog(@"%@", string);
    XCTAssertEqualObjects(string, @"ab");
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
    NSString *outputString;
    
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

#pragma mark > String Conversion

#pragma mark >> String to CGRect/UIEdgeInsets/UIColor

- (void)test_unescapedUnicodeStringWithString {
    // Case 1: Need to unescape
    XCTAssertEqualObjects([WCStringTool unescapedUnicodeStringWithString:@"\\u5404\\u500b\\u90fd"], @"各個都");
    XCTAssertEqualObjects([WCStringTool unescapedUnicodeStringWithString:@"\\U5378\\U8f7d\\U5e94\\U7528"], @"卸载应用");
    
    XCTAssertEqualObjects([WCStringTool unescapedUnicodeStringWithString:@"\u03C0"], @"π");
    // Note: Xcode not allow c string to use "\U03C0", must be "\u03C0", so use ESCAPE_UNICODE_CSTR macro to escape it
    XCTAssertEqualObjects([WCStringTool unescapedUnicodeStringWithString:ESCAPE_UNICODE_CSTR("\U03C0")], @"π");
    
    XCTAssertEqualObjects([WCStringTool unescapedUnicodeStringWithString:ESCAPE_UNICODE_CSTR("\U5e97\U94fa\U6d4b\U8bd5\U8d26\U53f7")], @"店铺测试账号");
    
    // Case 2: No need to unescape
    XCTAssertEqualObjects([WCStringTool unescapedUnicodeStringWithString:@""], @"");
    XCTAssertEqualObjects([WCStringTool unescapedUnicodeStringWithString:@"a normal string"], @"a normal string");
    NSString *nilString;
    XCTAssertNil([WCStringTool unescapedUnicodeStringWithString:nilString]);
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

- (void)test_occurrenceOfSubstringInString_substring {
    NSString *formatString = @"%@:%@";
    NSLog(@"occurence of %%@ is %ld", [WCStringTool occurrenceOfSubstringInString:formatString substring:@"%@"]);
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

#pragma mark - Cryption

#pragma mark > MD5

- (void)test_MD5WithString {
    XCTAssertTrue([WCStringTool MD5WithString:@"abc"].length == 32);
    XCTAssertNil([WCStringTool MD5WithString:@""]);
    NSString *nilString = nil;
    XCTAssertNil([WCStringTool MD5WithString:nilString]);
    NSLog(@"%@", [WCStringTool MD5WithString:@"abc"]);
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

@end








