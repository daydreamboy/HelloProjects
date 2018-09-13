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

@end








