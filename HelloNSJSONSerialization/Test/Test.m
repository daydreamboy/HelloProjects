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
@property (nonatomic, strong) id JSONObject1;
@property (nonatomic, strong) id JSONObject2;
@end

@implementation Test

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
    
    NSString *path;
    
    path = [[NSBundle bundleForClass:[self class]] pathForResource:@"data1" ofType:@"json"];
    self.JSONObject1 = [WCJSONTool JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableContainers objectClass:nil];
    XCTAssertNotNil(self.JSONObject1);
    
    path = [[NSBundle bundleForClass:[self class]] pathForResource:@"data2" ofType:@"json"];
    self.JSONObject2 = [WCJSONTool JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableContainers objectClass:nil];
    XCTAssertNotNil(self.JSONObject2);
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

#pragma mark > Safe JSON Object

- (void)test_safeJSONObjectWithObject {
    
}

#pragma mark - String to Object

#pragma mark > to NSDictionary/NSArray

- (void)test_JSONArrayWithString {
    
}

- (void)test_JSONDictWithString {
    
}

#pragma mark > to NSMutableDictionary/NSMutableArray

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

- (void)test_JSONMutableArrayWithString {
    
}

#pragma mark > to id

- (void)test_JSONObjectWithString_options_objectClass {
    
}

#pragma mark - Data to Object

#pragma mark > to NSDictionary/NSArray

- (void)test_JSONDictWithData {
    
}

- (void)test_JSONArrayWithData {
    
}

#pragma mark > to NSMutableDictionary/NSMutableArray

- (void)test_JSONMutableDictWithData {
    
}

- (void)test_JSONMutableArrayWithData {
    
}

#pragma mark > to id

- (void)test_JSONObjectWithData_options_objectClass {
    id value;
    NSData *data;
    
    // Case 1
    data = [STR_OF_JSON({ "key": "value" }) dataUsingEncoding:NSUTF8StringEncoding];
    value = [WCJSONTool JSONObjectWithData:data options:NSJSONReadingMutableLeaves objectClass:[@[] class]];
    XCTAssertNil(value);
    
    // Case 2
    data = [STR_OF_JSON({ "key": "value" }) dataUsingEncoding:NSUTF8StringEncoding];
    value = [WCJSONTool JSONObjectWithData:data options:NSJSONReadingMutableLeaves objectClass:[NSArray class]];
    XCTAssertNil(value);
    
    // Case 3
    data = [STR_OF_JSON({ "key": "value" }) dataUsingEncoding:NSUTF8StringEncoding];
    value = [WCJSONTool JSONObjectWithData:data options:NSJSONReadingMutableLeaves objectClass:[NSMutableDictionary class]];
    XCTAssertNil(value);
    
    // Case 4
    data = [STR_OF_JSON({ "key": "value" }) dataUsingEncoding:NSUTF8StringEncoding];
    value = [WCJSONTool JSONObjectWithData:data options:NSJSONReadingMutableLeaves objectClass:[NSDictionary class]];
    XCTAssertNotNil(value);
    XCTAssertTrue([value isKindOfClass:[NSDictionary class]]);
    
    // Case 5
    data = [STR_OF_JSON({ "key": "value" }) dataUsingEncoding:NSUTF8StringEncoding];
    value = [WCJSONTool JSONObjectWithData:data options:NSJSONReadingMutableContainers objectClass:[NSMutableDictionary class]];
    XCTAssertNotNil(value);
    XCTAssertTrue([value isKindOfClass:[NSMutableDictionary class]]);
    
    // Case 6
    data = [STR_OF_JSON({ "key": "value" }) dataUsingEncoding:NSUTF8StringEncoding];
    value = [WCJSONTool JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves objectClass:nil];
    XCTAssertNotNil(value);
    XCTAssertTrue([value isKindOfClass:[NSMutableDictionary class]]);
    
    // Case 7
    data = [STR_OF_JSON([ "1", "2" ]) dataUsingEncoding:NSUTF8StringEncoding];
    value = [WCJSONTool JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves objectClass:nil];
    XCTAssertNotNil(value);
    XCTAssertTrue([value isKindOfClass:[NSMutableArray class]]);
}

#pragma mark - JSON Escaped String

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

#pragma mark - Assistant Methods

#pragma mark > Key Path Query

- (void)test_arrayOfJSONObject_usingKeyPath {
    NSArray *arr = [WCJSONTool arrayOfJSONObject:self.JSONObject1 usingKeyPath:@"xValue.msglist"];
    
    XCTAssertTrue([arr isKindOfClass:[NSArray class]]);
}

- (void)test_dictionaryOfJSONObject_usingKeyPath {
    NSDictionary *dict = [WCJSONTool dictionaryOfJSONObject:self.JSONObject1 usingKeyPath:@"xValue.msglist.[0]"];
    
    XCTAssertTrue([dict isKindOfClass:[NSDictionary class]]);
}

- (void)test_stringOfJSONObject_usingKeyPath {
    NSString *str = [WCJSONTool stringOfJSONObject:self.JSONObject1 usingKeyPath:@""];
    
    XCTAssertNil(str);
}

- (void)test_integerOfJSONObject_usingKeyPath {
    NSInteger n;
    
    // Case
    n = [WCJSONTool integerOfJSONObject:self.JSONObject1 usingKeyPath:@"xValue.page"];
    XCTAssertTrue(n == 1);
    
    // Case
    n = [WCJSONTool integerOfJSONObject:self.JSONObject1 usingKeyPath:@"xValue.pageSize"];
    XCTAssertTrue(n == 20);
}

- (void)test_numberOfJSONObject_usingKeyPath {
    XCTAssertEqualObjects(@(88), [WCJSONTool numberOfJSONObject:self.JSONObject1 usingKeyPath:@"xValue.msgreplyList.2471.number-key"]);
}

- (void)test_boolOfJSONObject_usingKeyPath {
    NSString *JSONString;
    NSObject *JSONObject;
    
    // Case
    XCTAssertTrue([WCJSONTool boolOfJSONObject:self.JSONObject1 usingKeyPath:@"xValue.msgreplyList.2471.true-key"]);
    // Case
    XCTAssertFalse([WCJSONTool boolOfJSONObject:self.JSONObject1 usingKeyPath:@"xValue.msgreplyList.2471.false-key"]);
    // Case
    XCTAssertFalse([WCJSONTool boolOfJSONObject:self.JSONObject1 usingKeyPath:@"xValue.msgreplyList.2471.none-exist-key"]);
    
    // Case
    JSONString = @"{\"true-key\": true, \"false-key\": false}";
    JSONObject = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    XCTAssertTrue([WCJSONTool boolOfJSONObject:JSONObject usingKeyPath:@"true-key"]);
    XCTAssertFalse([WCJSONTool boolOfJSONObject:JSONObject usingKeyPath:@"false-key"]);
    XCTAssertFalse([WCJSONTool boolOfJSONObject:JSONObject usingKeyPath:@"none-exist-key"]);
}

- (void)test_nullOfJSONObject_usingKeyPath {
    XCTAssertEqualObjects([NSNull null], [WCJSONTool nullOfJSONObject:self.JSONObject1 usingKeyPath:@"xValue.msgreplyList.2471.null-key"]);
}

- (void)test_valueOfJSONObject_usingKeyPath {
    NSString *JSONString;
    NSObject *JSONObject;
    id value;
    
    // Case
    JSONString = @"{\"true-key\": true, \"false-key\": false}";
    JSONObject = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    value = [WCJSONTool valueOfJSONObject:JSONObject usingKeyPath:@"true-key"];
    XCTAssertEqualObjects(@(1), value);
    
    // Case
    JSONString = @"[123, 456]";
    JSONObject = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    value = [WCJSONTool valueOfJSONObject:JSONObject usingKeyPath:@"[1]"];
    XCTAssertEqualObjects(@(456), value);
    
    // Case
    value = [WCJSONTool valueOfJSONObject:@[@(123), @(456)] usingKeyPath:@"[2]"];
    XCTAssertNil(value);
    
    // Case
    XCTAssertNil([WCJSONTool valueOfJSONObject:nil usingKeyPath:@"[1]"]);
    
    // Case
    XCTAssertNil([WCJSONTool valueOfJSONObject:nil usingKeyPath:@""]);
    
    // Case: invalidJSONObject
    JSONObject = @{ @(123): @"we" };
    XCTAssertNil([WCJSONTool valueOfJSONObject:JSONObject usingKeyPath:@"123"]);
}

#pragma mark > Print JSON string

- (void)test_printJSONStringFromJSONObject {
    id JSONObject;
    
    // Case
    JSONObject = @{
        @"ret": @{
            @"code": @(101),
            @"msg": @"token error."
        },
        @"data": @"",
        @"cookies": @""
    };

    [WCJSONTool printJSONStringFromJSONObject:JSONObject];

    // Case
    JSONObject = @{
        @"ret": @{
            @"code": @(0),
            @"msg": @""
        },
        @"data": @"{\"driverTeachNote\":\"点击拨打电话按钮后，会有400专线联系您，请注意接听。\",\"orderOverCallLimitTimes\":\"3600\",\"waitCallBackNote2\":\"稍后请接听滴滴400来电与对方联系\",\"statusUrl\":\"http://10.10.35.9:8080/callback-mobile-protect/MobileProtect/Tencent/statusNotify.htm\",\"recordUrl\":\"http://10.10.35.9:8080/callback-mobile-protect/MobileProtect/Tencent/recordURLNotify.htm\",\"waitCallBackNote\":\"请准备接听•••\",\"waitCallBackNote3\":\"对方不会看到您的手机号\",\"isSupportMP\":1,\"mobileNameNote\":\"滴滴接驾专线\",\"cityId\":7,\"accessSign\":\"eJxFkFFPgzAQx78LrxrXQks7kz3gRnBmmhHATV*aSgvWKTDoOsH43WWMxXv8-e7yv7sfK15FN7yqlGBcM6cW1q0FrOsBy*9K1ZLxTMu6xzae2gBcpJF1o8rixAHE0HYA*JdKyEKrTJ3nKEQEA*ISCAhEY0uj8t49*sl8GS5WC-8uIEFEfcV3MX0OTdLG2Ue37*hcla9vW-c930xzaT94y9wzbVeGyfq4vzqKl-Q*KhA4pNkTNRNReRPyaYJmvSF6i5vZJUzs2HBkHwnRaVGEHXeUWn3JgWMHQLevkfM0LQ*FZrqt5PCV3z*m0lkx\",\"mpType\":\"258:2\",\"waitDriverNote2\":\"为保护您的手机号码不被泄漏，司机将通过400电话联系您，千万记得接听哦～\",\"waitDriverNote1\":\"请注意接听滴滴400电话\",\"checkStatuswaitTimes\":\"50\",\"driverZhiboZTeachNote\":\"直拨司机教育文案\",\"hangupUrl\":\"http://10.10.35.9:8080/callback-mobile-protect/MobileProtect/Tencent/callDetailNotify.htm\",\"mobileBillUrl\":\"\",\"callAuthNote2\":\"网络电话授权提醒文案\",\"tripNote\":\"为避免骚扰，行程结束后无法联系对方，如有特殊情况，请呼叫滴滴客服\",\"callAuthNote3\":\"滴滴想使用您的麦克风文案\",\"callAuthNote1\":\"网络电话授权提醒标题\"}",
        @"cookies": @""
    };

    [WCJSONTool printJSONStringFromJSONObject:JSONObject];
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
