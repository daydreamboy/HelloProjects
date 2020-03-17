//
//  Test.m
//  Test
//
//  Created by wesley_chen on 11/02/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCJSONTool.h"
#import "WCJSONTool_Testing.h"
#import "Human.h"
#import "HumanModel.h"

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

- (void)test_JSONStringWithKVCObject_printOptions_keyTreeDescription {
    id KVCObject;
    id keyTreeDescription;
    NSString *output;
        
    // Case 1
    KVCObject = [HumanModel createHuman];
    keyTreeDescription = STR_OF_JSON(
    {
       "leftHand": {
         "thumb": {"name":{}},
         "indexFinger": {"name":{}},
         "middleFinger": {"name":{}},
         "ringFinger": {"name":{}},
         "pinky": {"name":{}}
       }
    }
    );
    output = [WCJSONTool JSONStringWithKVCObject:KVCObject printOptions:NSJSONWritingPrettyPrinted keyTreeDescription:keyTreeDescription];
    NSLog(@"%@", output);
    
    // Case 2
    KVCObject = [HumanModel createHuman];
    keyTreeDescription = STR_OF_JSON(
    {
        "leftHand": {
            "thumb": {"name":{}},
            "indexFinger": {"name":{}},
            "middleFinger": {"name":{}},
            "ringFinger": {"name":{}},
            "pinky": {"name":{}}
        },
        "rightHand": {
            "thumb": {"name":{}},
            "indexFinger": {"name":{}},
            "middleFinger": {"name":{}},
            "ringFinger": {"name":{}},
            "pinky": {"name":{}}
        }
    }
    );
    output = [WCJSONTool JSONStringWithKVCObject:KVCObject printOptions:NSJSONWritingPrettyPrinted keyTreeDescription:keyTreeDescription];
    NSLog(@"%@", output);
    
    // Case 3
    KVCObject = [HumanModel createHuman];
    keyTreeDescription = STR_OF_JSON(
    {
        "map": {},
    }
    );
    output = [WCJSONTool JSONStringWithKVCObject:KVCObject printOptions:NSJSONWritingPrettyPrinted keyTreeDescription:keyTreeDescription];
    NSLog(@"%@", output);
    
    // Case 4
    KVCObject = [HumanModel createHuman];
    keyTreeDescription = STR_OF_JSON(
    {
        "mapHands": {
            "leftHand": {
                "thumb": {"name":{}},
                "indexFinger": {"name":{}},
                "middleFinger": {"name":{}},
                "ringFinger": {"name":{}},
                "pinky": {"name":{}}
            },
            "rightHand": {
                "thumb": {"name":{}},
                "indexFinger": {"name":{}},
                "middleFinger": {"name":{}},
                "ringFinger": {"name":{}},
                "pinky": {"name":{}}
            }
        },
    }
    );
    output = [WCJSONTool JSONStringWithKVCObject:KVCObject printOptions:NSJSONWritingPrettyPrinted keyTreeDescription:keyTreeDescription];
    NSLog(@"%@", output);
    
    // Case 5
    Human *human = [Human new];
    Hand *leftHand = [[Hand alloc] initWithName:@"left"];
    leftHand.fingers = @[
        [[Finger alloc] initWithName:@"1" index:0],
        [[Finger alloc] initWithName:@"2" index:1],
        [[Finger alloc] initWithName:@"3" index:2],
        [[Finger alloc] initWithName:@"4" index:3],
        [[Finger alloc] initWithName:@"5" index:4],
    ];

    Hand *rightHand = [[Hand alloc] initWithName:@"right"];
    rightHand.fingers = @[
        [[Finger alloc] initWithName:@"1" index:0],
        [[Finger alloc] initWithName:@"2" index:1],
        [[Finger alloc] initWithName:@"3" index:2],
        [[Finger alloc] initWithName:@"4" index:3],
        [[Finger alloc] initWithName:@"5" index:4],
    ];

    human.hands = @[ leftHand, rightHand ];
    
    KVCObject = human;
    keyTreeDescription = STR_OF_JSON(
    {
        "hands": [
            {
              "name": {},
              "fingers": [
                {
                  "name": {},
                  "index": {}
                }
              ]
            }
        ]
    }
    );
    output = [WCJSONTool JSONStringWithKVCObject:KVCObject printOptions:NSJSONWritingPrettyPrinted keyTreeDescription:keyTreeDescription];
    NSLog(@"%@", output);
}

#pragma mark > Safe JSON Object

- (void)test_safeJSONObjectWithObject {
    
}

#pragma mark - String to Object

#pragma mark > to NSDictionary/NSArray

- (void)test_JSONArrayWithString {
   NSString *string =  @"['wangx://p2sconversation/package?serviceType=cloud_auto_reply&bizType=3&bot_action=AddressSelectorAction&fromId=cntaobao朗风买家测试账号1&toId=cntaobaoqn店铺测试账号001:lf01&bizOrderId=551106310014950798&uuid=551106310014950798&mainAccountId=2256639331&deliverAddressId=9875797532&originalAddressId=9875797532&triggerType=automatic&api=mtop.taobao.dgw.richtext.click&need_encode=true&need_session=true','wangx://menu/dismiss?menuname=MenuNameForShowType&container=dialog&conversationId=cntaobaoqn店铺测试账号001:lf01&strategy=transient']";
    
    id object = [WCJSONTool JSONObjectWithString:string options:kNilOptions objectClass:nil];
    NSString *JSONString = [WCJSONTool JSONStringWithObject:object printOptions:NSJSONWritingSortedKeys | NSJSONWritingPrettyPrinted];
    printf("%s\n", [JSONString UTF8String]);
}

- (void)test_JSONDictWithString {
    NSString *JSONEscapedString = @"{\"activityId\":\"205051655378\",\"cardHeight\":420,\"cardType\":\"chatstyle\",\"cover\":\"https://img.alicdn.com/imgextra/i2/1119561178/O1CN011KZZ0uodgn62Tut_!!1119561178.jpg\",\"endDate\":1534262400000,\"id\":205048298697,\"status\":0,\"targetType\":\"detail\",\"targetUrl\":\"https://market.m.taobao.com/apps/market/collectactivity/index.html?nodeId=205051655378&wx_navbar_transparent=true&wh_weex=true\",\"title\":\"你约会，森马买单\",\"type\":7,\"typeName\":\"征集\"}";
    id object = [WCJSONTool JSONObjectWithString:JSONEscapedString options:kNilOptions objectClass:nil];
    NSString *JSONString = [WCJSONTool JSONStringWithObject:object printOptions:NSJSONWritingSortedKeys | NSJSONWritingPrettyPrinted];
    printf("%s\n", [JSONString UTF8String]);
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
    dictM = (NSMutableDictionary *)[WCJSONTool JSONDictWithString:jsonString allowMutable:YES];
    XCTAssertTrue([dictM isKindOfClass:[NSMutableDictionary class]]);
    NSLog(@"mutuable dictionary: %@", dictM);
    
    
    // Case 2
    jsonString = STR_OF_JSON(
                             {"api":"mtop.taobao.amp2.im.msgAction","v":"1.0","needecode":true,"needsession":true,"params":{"sessionViewId":"0_U_1956212549#3_2554606548#3_1_1956212549#3","msgCode":"0_U_2554606548_1956212549_1539096778077_185571796986","map":{"op":"like"}}}
                             );
    
    dictM = (NSMutableDictionary *)[WCJSONTool JSONDictWithString:jsonString allowMutable:YES];
    XCTAssertTrue([dictM isKindOfClass:[NSMutableDictionary class]]);
    NSLog(@"mutuable dictionary: %@", dictM);
}

- (void)test_JSONMutableArrayWithString {
    
}

#pragma mark > to id

- (void)test_JSONObjectWithString_options_objectClass {
    NSString *JSONString;
    id object;
    id expected;
    
    // Case 1
    JSONString = @"{\"delivery\":{\"from\":\"浙江嘉兴\",\"to\":\"浙江杭州\",\"areaId\":\"330100\",\"extras\":{},\"overseaContraBandFlag\":\"false\",\"addressWeexUrl\":\"https:\/\/market.m.taobao.com\/apps\/market\/detailrax\/address-picker.html?spm=a2116h.app.0.0.16d957e9nDYOzv&wh_weex=true\"}}";
    object = [WCJSONTool JSONObjectWithString:JSONString options:NSJSONReadingAllowFragments objectClass:nil];
    XCTAssertTrue([object isKindOfClass:[NSDictionary class]]);
    NSLog(@"%@", object);
    
    // Case 2
    JSONString = @"\"all\"";
    
    object = [WCJSONTool JSONObjectWithString:JSONString options:NSJSONReadingAllowFragments objectClass:nil];
    XCTAssertTrue([object isKindOfClass:[NSString class]]);
    NSLog(@"%@", object);
    
    // Case 3
    JSONString = @"{\"delivery\":{},\"trade\":{\"buyEnable\":true,\"cartEnable\":true},\"feature\":{},\"price\":{\"price\":{\"priceText\":\"0.01\"}},\"skuCore\":{\"sku2info\":{\"0\":{\"price\":{\"priceMoney\":1,\"priceText\":\"0.01\",\"priceTitle\":\"价格\"},\"quantity\":100}},\"skuItem\":{\"hideQuantity\":true}}}";
    object = [WCJSONTool JSONObjectWithString:JSONString options:NSJSONReadingAllowFragments objectClass:nil];
    XCTAssertTrue([object isKindOfClass:[NSDictionary class]]);
    NSLog(@"%@", object);
    
    // Case 4：\n
    JSONString = @"{\"wxIdentity\":\"chatting-tmall\",\"wxOpt\":\"{\\\"height\\\":\\\"240\\\"}\",\"wxData\":\"{\\\"img\\\":\\\"http://gw.alicdn.com/mt/TB1PEudXR1D3KVjSZFyXXbuFpXa-100-100.png\\\",\\\"themeColor\\\":\\\"#999999\\\",\\\"srcIcon\\\":\\\"https://gw.alicdn.com/tfs/TB15UZ2jnZmx1VjSZFGXXax2XXa-26-26.png\\\",\\\"interact\\\":\\\"\\\",\\\"source\\\":\\\"淘宝人生\\\",\\\"title\\\":\\\"送给你一张心愿卡\\\",\\\"wxDisplayType\\\":\\\"淘宝人生\\\",\\\"url\\\":\\\"https://market.m.taobao.com/app/wireless-platform/c6_seclife/index.html?disableNav=YES&from=msgcard\\\",\\\"desc\\\":\\\"帮你实现你的心愿，快来领取这份礼物吧\n        \\\",\\\"wxDisplayName\\\":\\\"快来开启属于你的淘宝人生\\\"}\",\"wxTplUrl\":\"http://market.m.taobao.com/app/tb-chatting/feed-cards/tmall_card?wh_ttid=native\",\"wxDisplayType\":\"淘宝人生\",\"wxDisplayName\":\"您有一条淘宝人生信息\"}";
    
    object = [WCJSONTool JSONObjectWithString:JSONString options:NSJSONReadingAllowFragments objectClass:nil];
    XCTAssertTrue([object isKindOfClass:[NSDictionary class]]);
    NSLog(@"%@", object);
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
    NSDictionary *dict = [WCJSONTool JSONDictWithString:JSONString allowMutable:NO];
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
    id object = [WCJSONTool stringOfJSONObject:self.JSONObject1 usingKeyPath:@""];
    
    XCTAssertEqualObjects(object, self.JSONObject1);
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
    
    // Case 1: root is map
    JSONString = STR_OF_JSON(
        {
            "true-key": true,
            "false-key": false
        }
    );
    JSONObject = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    value = [WCJSONTool valueOfJSONObject:JSONObject usingKeyPath:@"true-key" objectClass:nil];
    XCTAssertEqualObjects(value, @(1));
    value = [WCJSONTool valueOfJSONObject:JSONObject usingKeyPath:@"[true-key]" objectClass:nil];
    XCTAssertEqualObjects(value, @(1));
    
    // Case 2: root is list
    JSONString = STR_OF_JSON(
        [
            123,
            456
        ]
    );
    JSONObject = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    value = [WCJSONTool valueOfJSONObject:JSONObject usingKeyPath:@"[1]" objectClass:nil];
    XCTAssertEqualObjects(value, @(456));
    value = [WCJSONTool valueOfJSONObject:JSONObject usingKeyPath:@"1" objectClass:nil];
    XCTAssertEqualObjects(value, @(456));
    
    
    // Case 3
    JSONString = STR_OF_JSON(
        {
            "a": {
                "b": "B",
                "1": "C"
            }
        }
    );
    JSONObject = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    value = [WCJSONTool valueOfJSONObject:JSONObject usingKeyPath:@"a.b" objectClass:nil];
    XCTAssertEqualObjects(value, @"B");
    value = [WCJSONTool valueOfJSONObject:JSONObject usingKeyPath:@"a[b]" objectClass:nil];
    XCTAssertEqualObjects(value, @"B");
    value = [WCJSONTool valueOfJSONObject:JSONObject usingKeyPath:@"a[1]" objectClass:nil];
    XCTAssertEqualObjects(value, @"C");
    value = [WCJSONTool valueOfJSONObject:JSONObject usingKeyPath:@"a.1" objectClass:nil];
    XCTAssertEqualObjects(value, @"C");
    
    // Case 4
    JSONString = STR_OF_JSON(
        {
            "a": [
                "B"
            ]
        }
    );
    JSONObject = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    value = [WCJSONTool valueOfJSONObject:JSONObject usingKeyPath:@"a[0]" objectClass:nil];
    XCTAssertEqualObjects(value, @"B");
    
    value = [WCJSONTool valueOfJSONObject:JSONObject usingKeyPath:@"a.0" objectClass:nil];
    XCTAssertEqualObjects(value, @"B");
    
    // Case 5
    JSONString = STR_OF_JSON(
        [
         {
            "a": [
                "B"
            ]
         }
        ]
    );
    JSONObject = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    value = [WCJSONTool valueOfJSONObject:JSONObject usingKeyPath:@"[0].a[0]" objectClass:nil];
    XCTAssertEqualObjects(value, @"B");
    value = [WCJSONTool valueOfJSONObject:JSONObject usingKeyPath:@"0.a.0" objectClass:nil];
    XCTAssertEqualObjects(value, @"B");
    
    value = [WCJSONTool valueOfJSONObject:@[@(123), @(456)] usingKeyPath:@"[2]" objectClass:nil];
    XCTAssertNil(value);
    
    // Case
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wnonnull"
    XCTAssertNil([WCJSONTool valueOfJSONObject:nil usingKeyPath:@"[1]" objectClass:nil]);
#pragma GCC diagnostic pop
    
    // Case
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wnonnull"
    XCTAssertNil([WCJSONTool valueOfJSONObject:nil usingKeyPath:@"" objectClass:nil]);
#pragma GCC diagnostic pop
    
    // Case: invalidJSONObject
    JSONObject = @{ @(123): @"we" };
    XCTAssertNil([WCJSONTool valueOfJSONObject:JSONObject usingKeyPath:@"123" objectClass:nil]);
}

- (void)test_replaceValueOfKVCObject_usingKeyPath_value {
    NSString *JSONString;
    NSObject *JSONObject;
    id output;
    NSString *expectedJSONString;
    NSError *error;
    
    // Case 1 root is map
    JSONString = STR_OF_JSON(
        {
            "true-key": true,
            "false-key": false
        }
    );
    JSONObject = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    output = [WCJSONTool replaceValueOfKVCObject:JSONObject usingKeyPath:@"true-key" value:@"true"];
    expectedJSONString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:output options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(expectedJSONString, @"{\"true-key\":\"true\",\"false-key\":false}");
    
    // Case 2: root is list
    JSONString = STR_OF_JSON(
        [
            123,
            456
        ]
    );
    JSONObject = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    output = [WCJSONTool replaceValueOfKVCObject:JSONObject usingKeyPath:@"[1]" value:@"456"];
    expectedJSONString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:output options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(expectedJSONString, @"[123,\"456\"]");
    
    
    // Case 3: map -> map
    JSONString = STR_OF_JSON(
        {
            "a": {
                "b": "B",
                "1": "C"
            }
        }
    );
    JSONObject = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    // leaf to replace
    output = [WCJSONTool replaceValueOfKVCObject:JSONObject usingKeyPath:@"a.b" value:@(2)];
    expectedJSONString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:output options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(expectedJSONString, @"{\"a\":{\"b\":2,\"1\":\"C\"}}");
    
    // two leaves to replace by order
    output = [WCJSONTool replaceValueOfKVCObject:JSONObject usingKeyPath:@"a.b" value:@(2)];
    output = [WCJSONTool replaceValueOfKVCObject:output usingKeyPath:@"a.1" value:@(3)];
    expectedJSONString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:output options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(expectedJSONString, @"{\"a\":{\"b\":2,\"1\":3}}");
    
    // leaf to replace by a container
    output = [WCJSONTool replaceValueOfKVCObject:JSONObject usingKeyPath:@"a.b" value:@[@4,@5,@6]];
    expectedJSONString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:output options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(expectedJSONString, @"{\"a\":{\"b\":[4,5,6],\"1\":\"C\"}}");
    
    // Case 3: Three levels
    // map -> map -> list: a.c.[1]
    // map -> map -> map: a.b.c
    // map -> list -> map: c.[0].a
    // map -> list -> list: b.[2].[1]
    JSONString = STR_OF_JSON(
        {
            "a": {
                "b": {"c":3},
                "c": [ 1, 2 ]
            },
            "b": [
                1,
                2,
                [3, 4]
            ],
            "c": [{"a": "b"}]
        }
    );
    JSONObject = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
  
    output = [WCJSONTool replaceValueOfKVCObject:JSONObject usingKeyPath:@"a.c.[1]" value:@"2"];
    expectedJSONString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:output options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(expectedJSONString, @"{\"a\":{\"b\":{\"c\":3},\"c\":[1,\"2\"]},\"b\":[1,2,[3,4]],\"c\":[{\"a\":\"b\"}]}");
    
    output = [WCJSONTool replaceValueOfKVCObject:JSONObject usingKeyPath:@"a.b.c" value:@"3"];
    expectedJSONString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:output options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(expectedJSONString, @"{\"a\":{\"b\":{\"c\":\"3\"},\"c\":[1,2]},\"b\":[1,2,[3,4]],\"c\":[{\"a\":\"b\"}]}");
    
    output = [WCJSONTool replaceValueOfKVCObject:JSONObject usingKeyPath:@"c.[0].a" value:@"0"];
    expectedJSONString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:output options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(expectedJSONString, @"{\"a\":{\"b\":{\"c\":3},\"c\":[1,2]},\"b\":[1,2,[3,4]],\"c\":[{\"a\":\"0\"}]}");
    
    output = [WCJSONTool replaceValueOfKVCObject:JSONObject usingKeyPath:@"b.[2].[1]" value:@"4"];
    expectedJSONString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:output options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(expectedJSONString, @"{\"a\":{\"b\":{\"c\":3},\"c\":[1,2]},\"b\":[1,2,[3,\"4\"]],\"c\":[{\"a\":\"b\"}]}");
    
    // Case 4: Three levels
    // list -> map -> list: [0].a.2
    // list -> map -> map: [0].b.c
    // list -> list -> map: [1].[0].a
    // list -> list -> list: [1].[1].[1]
    JSONString = STR_OF_JSON(
        [
         {
            "a": [ 1, 2, 3],
            "b": {"c": "3"}
         },
         [
            {
                "a": 1
            },
            [1, 2, 3]
         ]
        ]
    );
    JSONObject = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    output = [WCJSONTool replaceValueOfKVCObject:JSONObject usingKeyPath:@"[0].a.2" value:@"3"];
    expectedJSONString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:output options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(expectedJSONString, @"[{\"a\":[1,2,\"3\"],\"b\":{\"c\":\"3\"}},[{\"a\":1},[1,2,3]]]");
    
    output = [WCJSONTool replaceValueOfKVCObject:JSONObject usingKeyPath:@"[0].b.c" value:@3];
    expectedJSONString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:output options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(expectedJSONString, @"[{\"a\":[1,2,3],\"b\":{\"c\":3}},[{\"a\":1},[1,2,3]]]");
    
    output = [WCJSONTool replaceValueOfKVCObject:JSONObject usingKeyPath:@"[1].[0].a" value:@3];
    expectedJSONString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:output options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(expectedJSONString, @"[{\"a\":[1,2,3],\"b\":{\"c\":\"3\"}},[{\"a\":3},[1,2,3]]]");
    
    output = [WCJSONTool replaceValueOfKVCObject:JSONObject usingKeyPath:@"[1].[1].[1]" value:@3];
    expectedJSONString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:output options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(expectedJSONString, @"[{\"a\":[1,2,3],\"b\":{\"c\":\"3\"}},[{\"a\":1},[1,3,3]]]");
    
    // Case 5: KVC object
    Human *human = [Human new];
    Hand *leftHand = [[Hand alloc] initWithName:@"left"];
    leftHand.fingers = @[
        [[Finger alloc] initWithName:@"1" index:0],
        [[Finger alloc] initWithName:@"2" index:1],
        [[Finger alloc] initWithName:@"3" index:2],
        [[Finger alloc] initWithName:@"4" index:3],
        [[Finger alloc] initWithName:@"5" index:4],
    ];
    
    Hand *rightHand = [[Hand alloc] initWithName:@"right"];
    rightHand.fingers = @[
        [[Finger alloc] initWithName:@"1" index:0],
        [[Finger alloc] initWithName:@"2" index:1],
        [[Finger alloc] initWithName:@"3" index:2],
        [[Finger alloc] initWithName:@"4" index:3],
        [[Finger alloc] initWithName:@"5" index:4],
    ];
    
    human.hands = @[ leftHand, rightHand ];
    
    JSONObject = @{
        @"human": human,
        @"array": @[
                human
            ]
    };
    output = [WCJSONTool replaceValueOfKVCObject:JSONObject usingKeyPath:@"human.hands[0].fingers[0].name" value:@"left finger 1"];
    XCTAssertEqualObjects(((Human *)output[@"human"]).hands[0].fingers[0].name, @"left finger 1");

    output = [WCJSONTool replaceValueOfKVCObject:JSONObject usingKeyPath:@"array[0].hands[0].fingers[0].name" value:@"left finger 1"];
    XCTAssertEqualObjects(((Human *)output[@"array"][0]).hands[0].fingers[0].name, @"left finger 1");
}

- (void)test_valueOfKVCObject_usingKeyPath {
    NSObject *object;
    id value;
    
    // Example 1
    // Case 1
    object = [Human new];
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"hands" objectClass:nil];
    XCTAssertTrue([(NSObject *)value isKindOfClass:[NSArray class]]);
    XCTAssertTrue([(NSArray *)value count] == 2);
    
    // Case 2
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"hands[0]" objectClass:nil];
    XCTAssertTrue([value isKindOfClass:[Hand class]]);
    
    // Case 3
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"hands[0].name" objectClass:nil];
    XCTAssertEqualObjects(value, @"Left Hand");
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"hands[1][name]" objectClass:nil];
    XCTAssertEqualObjects(value, @"Right Hand");
    
    // Case 4
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"hands[0].fingers" objectClass:nil];
    XCTAssertTrue([value count] == 5);
    
    // Case 5
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"hands[0].fingers[0]" objectClass:nil];
    XCTAssertTrue([(NSObject *)value isKindOfClass:[Finger class]]);
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"hands[0].fingers[0].name" objectClass:nil];
    XCTAssertEqualObjects(value, @"Thumb");
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"hands[0].fingers[0].index" objectClass:nil];
    XCTAssertEqualObjects(value, @(1));
    
    // Example 2
    object = @{
               @"human": [Human new],
               @"array": @[
                       [Human new]
                   ]
               };
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"[human].hands" objectClass:nil];
    XCTAssertTrue([(NSObject *)value isKindOfClass:[NSArray class]]);
    XCTAssertTrue([(NSArray *)value count] == 2);
    
    // Case 2
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"[human].hands[0]" objectClass:nil];
    XCTAssertTrue([value isKindOfClass:[Hand class]]);
    
    // Case 3
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"human.hands[0].name" objectClass:nil];
    XCTAssertEqualObjects(value, @"Left Hand");
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"human.hands[1][name]" objectClass:nil];
    XCTAssertEqualObjects(value, @"Right Hand");
    
    // Case 4
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"array.0.hands[0].fingers" objectClass:nil];
    XCTAssertTrue([value count] == 5);
    
    // Case 5
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"array[0].hands[0].fingers[0]" objectClass:nil];
    XCTAssertTrue([(NSObject *)value isKindOfClass:[Finger class]]);
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"array[0].hands[0].fingers[0].name" objectClass:nil];
    XCTAssertEqualObjects(value, @"Thumb");
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"array[0].hands[0].fingers[0].index" objectClass:nil];
    XCTAssertEqualObjects(value, @(1));
    
    // Abnormal Case
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"Hand" objectClass:nil];
    XCTAssertNil(value);
}

- (void)test_valueOfKVCObject_usingKeyPath_bindings {
    NSObject *object;
    NSDictionary *bindings;
    id value;
    
    // Example 1
    // Case 1
    object = [Human new];
    bindings = @{
                 @"a": @"hands"
                 };
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"$a" bindings:bindings objectClass:nil];
    XCTAssertTrue([(NSObject *)value isKindOfClass:[NSArray class]]);
    XCTAssertTrue([(NSArray *)value count] == 2);
    
    // Case 2
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"$a[0]" bindings:bindings objectClass:nil];
    XCTAssertTrue([value isKindOfClass:[Hand class]]);
    
    // Case 3
    bindings = @{
                 @"a": @"hands",
                 @"c": @"name"
                 };
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"$a[0].$c" bindings:bindings objectClass:nil];
    XCTAssertEqualObjects(value, @"Left Hand");
    bindings = @{
                 @"a": @"hands",
                 @"b": @"1",
                 @"c": @"name"
                  };
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"$a[$b][$c]" bindings:bindings objectClass:nil];
    XCTAssertEqualObjects(value, @"Right Hand");
    
    // Case 4
    bindings = @{
                 @"a": @"hands",
                 @"b": @"0",
                 @"c": @"fingers"
                  };
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"$a[$b].$c" bindings:bindings objectClass:nil];
    XCTAssertTrue([value count] == 5);
    
    // Case 5
    bindings = @{
                 @"a": @"hands",
                 @"b": @"0",
                 @"c": @"fingers"
                  };
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"$a[0].$c[0]" bindings:bindings objectClass:nil];
    XCTAssertTrue([(NSObject *)value isKindOfClass:[Finger class]]);
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"$a[0].$c[$b].name" bindings:bindings objectClass:nil];
    XCTAssertEqualObjects(value, @"Thumb");
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"$a[0].$c[0].index" bindings:bindings objectClass:nil];
    XCTAssertEqualObjects(value, @(1));
    
    // Example 2
    object = @{
               @"human": [Human new],
               @"array": @[
                       [Human new]
                       ]
               };
    bindings = @{
                 @"a": @"hands",
                 @"b": @"0",
                 @"c": @"human"
                  };
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"[$c].$a" bindings:bindings objectClass:nil];
    XCTAssertTrue([(NSObject *)value isKindOfClass:[NSArray class]]);
    XCTAssertTrue([(NSArray *)value count] == 2);
    
    // Case 2
    bindings = @{
                 @"a": @"hands",
                 @"b": @"0",
                 @"c": @"human"
                  };
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"[$c].$a[0]" bindings:bindings objectClass:nil];
    XCTAssertTrue([value isKindOfClass:[Hand class]]);
    
    // Case 3
    bindings = @{
                 @"a": @"hands",
                 @"b": @"name",
                 @"c": @"human"
                  };
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"$c.$a[0].$b" bindings:bindings objectClass:nil];
    XCTAssertEqualObjects(value, @"Left Hand");
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"$c.$a[1].$b" bindings:bindings objectClass:nil];
    XCTAssertEqualObjects(value, @"Right Hand");
    
    // Case 4
    bindings = @{
                 @"a": @"hands",
                 @"b": @"0",
                 @"c": @"name"
                  };
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"array.$b.$a[$b].fingers" bindings:bindings objectClass:nil];
    XCTAssertTrue([value count] == 5);
    
    // Case 5
    bindings = @{
                 @"a": @"hands",
                 @"b": @"0",
                 @"c": @"name"
                  };
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"array[0].$a[0].fingers[0]" bindings:bindings objectClass:nil];
    XCTAssertTrue([(NSObject *)value isKindOfClass:[Finger class]]);
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"array[0].$a[0].fingers[0].$c" bindings:bindings objectClass:nil];
    XCTAssertEqualObjects(value, @"Thumb");
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"array[0].$a[0].fingers[0].index" bindings:bindings objectClass:nil];
    XCTAssertEqualObjects(value, @(1));
    
    // Case 6
    object = @{
               @"human": [Human new],
               @"array": @[
                       [Human new]
                       ]
               };
    bindings = @{
                 @"a": @"hu",
                 @"b": @"man",
                 @"c": @"name"
                 };
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"$a$b.hands[0].fingers[0].name" bindings:bindings objectClass:nil];
    XCTAssertEqualObjects(value, @"Thumb");
    
    // Case 7
    object = @{
               @"human": [Human new],
               @"array": @[
                       [Human new]
                       ]
               };
    bindings = @{
                 @"a": @"hu"
                 };
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"${a}man.hands[0].fingers[0].name" bindings:bindings objectClass:nil];
    XCTAssertEqualObjects(value, @"Thumb");
    
    // Case 8
    object = @{
               @"human": [Human new],
               @"array": @[
                       [Human new]
                       ]
               };
    bindings = @{
                 @"b": @"man"
                 };
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"hu$b.hands[0].fingers[0].name" bindings:bindings objectClass:nil];
    XCTAssertEqualObjects(value, @"Thumb");
    
    
    // Case 9
    bindings = @{
                 @"!bar": @{
                         @"foo": @"a"
                         }
                 };
    value = [WCJSONTool valueOfKVCObject:bindings usingKeyPath:@"!bar.foo" bindings:bindings objectClass:nil];
    XCTAssertEqualObjects(value, @"a");
    
    // Abnormal Case 1
    value = [WCJSONTool valueOfKVCObject:object usingKeyPath:@"Hand" bindings:bindings objectClass:nil];
    XCTAssertNil(value);
}

#pragma mark >> For NSArray/NSDictionary

- (void)test_valueOfCollectionObject_usingBracketsPath {
    id object;
    id value;
    NSString *path;
    
    // Case 1
    object = @[
               @{
                   @"title": @"A"
                   }
               ];
    path = @"[0]['title']";
    value = [WCJSONTool valueOfCollectionObject:object usingBracketsPath:path objectClass:nil];
    XCTAssertEqualObjects(value, @"A");
    
    value = [WCJSONTool valueOfCollectionObject:object usingBracketsPath:path objectClass:[NSString class]];
    XCTAssertEqualObjects(value, @"A");
    
    value = [WCJSONTool valueOfCollectionObject:object usingBracketsPath:path objectClass:[NSNumber class]];
    XCTAssertNil(value);
    
    // Case 2
    object = @{
               @"title": @[
                       @"A"
                       ]
               };
    path = @"['title'][0]";
    value = [WCJSONTool valueOfCollectionObject:object usingBracketsPath:path objectClass:nil];
    XCTAssertEqualObjects(value, @"A");
    
    path = @"['title']";
    value = [WCJSONTool valueOfCollectionObject:object usingBracketsPath:path objectClass:[NSArray class]];
    XCTAssertEqualObjects(value, @[ @"A" ]);
    
    // Abnormal Case 1
    object = @{
               @"title": @[
                       @"A"
                       ]
               };
    path = @"['title'}[0]";
    value = [WCJSONTool valueOfCollectionObject:object usingBracketsPath:path objectClass:nil];
    XCTAssertNil(value);
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

#pragma mark > Print Objective-C literal string

- (void)test_literalStringWithJSONObject_startIndentLength_indentLength_ordered {
    id JSONObject;
    NSString *output;
    NSString *expected;
    
    // Case 1
    JSONObject = @{
                   @"str": @"a",
                   @"num": @3,
                   @"bool": @YES,
                   @"null": [NSNull null],
                   @"float": @3.14,
                   @"dict": @{
                     @"key": @"value",
                     @"another dict": @{
                             @"k": @{
                                     @"kk": @"vv"
                                     }
                     }
                   }
                 };
    output = [WCJSONTool literalStringWithJSONObject:JSONObject startIndentLength:0 indentLength:2 ordered:NO];
    printf("%s\n", [output UTF8String]);
    printf("----------------------------------\n");
    expected = @""
R"(@{
  @"bool" : @YES,
  @"num" : @(3),
  @"float" : @(3.14),
  @"dict" : @{
    @"key" : @"value",
    @"another dict" : @{
      @"k" : @{
        @"kk" : @"vv"
      }
    }
  },
  @"null" : [NSNull null],
  @"str" : @"a"
})";
    XCTAssertEqualObjects(output, expected);

    // Case 2
    JSONObject = @{
                   @"arr": @[
                     @"a",
                     @3,
                     @3.14,
                     [NSNull null],
                     @YES,
                     @[
                         @"b",
                         @4,
                     ],
                   ]
                 };
    output = [WCJSONTool literalStringWithJSONObject:JSONObject startIndentLength:2 indentLength:4 ordered:YES];
    printf("%s\n", [output UTF8String]);
    printf("----------------------------------\n");
    expected = @""
R"(  @{
      @"arr" : @[
          @"a",
          @(3),
          @(3.14),
          [NSNull null],
          @YES,
          @[
              @"b",
              @(4)
          ]
      ]
  })";
    XCTAssertEqualObjects(output, expected);

    // Case 3
    JSONObject = @[
                   @"a",
                   @3,
                   @3.14,
                   [NSNull null],
                   @YES,
                   @[
                       @"b",
                       @4,
                       ],
                   @{
                       @"dict": @{
                               @"key": @"value"
                               }
                       }
                   ];
    output = [WCJSONTool literalStringWithJSONObject:JSONObject startIndentLength:0 indentLength:4 ordered:YES];
    printf("%s\n", [output UTF8String]);
    printf("----------------------------------\n");
    expected = @""
R"(@[
    @"a",
    @(3),
    @(3.14),
    [NSNull null],
    @YES,
    @[
        @"b",
        @(4)
    ],
    @{
        @"dict" : @{
            @"key" : @"value"
        }
    }
])";
    XCTAssertEqualObjects(output, expected);

    // Case 4
    JSONObject = @[
                   @"a",
                   @3,
                   @3.14,
                   [NSNull null],
                   @YES,
                   @[
                       @"b",
                       @4,
                       @[
                           @"c",
                           @[
                               @"d"
                               ]
                           ],
                       ],
                   ];
    output = [WCJSONTool literalStringWithJSONObject:JSONObject startIndentLength:0 indentLength:4 ordered:YES];
    printf("%s\n", [output UTF8String]);
    printf("----------------------------------\n");
    expected = @""
R"(@[
    @"a",
    @(3),
    @(3.14),
    [NSNull null],
    @YES,
    @[
        @"b",
        @(4),
        @[
            @"c",
            @[
                @"d"
            ]
        ]
    ]
])";

    // Case 5
    JSONObject = @3.14;
    output = [WCJSONTool literalStringWithJSONObject:JSONObject startIndentLength:0 indentLength:4 ordered:YES];
    printf("%s\n", [output UTF8String]);
    printf("----------------------------------\n");
    expected = @R"(@(3.14))";
    XCTAssertEqualObjects(output, expected);
    
    // Case 6
    JSONObject = @"string";
    output = [WCJSONTool literalStringWithJSONObject:JSONObject startIndentLength:0 indentLength:4 ordered:YES];
    printf("%s\n", [output UTF8String]);
    printf("----------------------------------\n");
    expected = @R"(@"string")";
    XCTAssertEqualObjects(output, expected);
    
    // Case 7
    JSONObject = @YES;
    output = [WCJSONTool literalStringWithJSONObject:JSONObject startIndentLength:0 indentLength:4 ordered:YES];
    printf("%s\n", [output UTF8String]);
    printf("----------------------------------\n");
    expected = @R"(@YES)";
    XCTAssertEqualObjects(output, expected);
    
    // Case 8
    JSONObject = [NSNull null];
    output = [WCJSONTool literalStringWithJSONObject:JSONObject startIndentLength:0 indentLength:4 ordered:YES];
    printf("%s\n", [output UTF8String]);
    printf("----------------------------------\n");
    expected = @R"([NSNull null])";
    XCTAssertEqualObjects(output, expected);
    
    // Abnormal Case 1
    JSONObject = @[
                   @"a",
                   [NSDate date],
                   ];
    output = [WCJSONTool literalStringWithJSONObject:JSONObject startIndentLength:0 indentLength:2 ordered:YES];
    printf("%s\n", [output UTF8String]);
    printf("----------------------------------\n");
    expected = @""
R"(@[
  @"a"
])";
    XCTAssertEqualObjects(output, expected);
    
    // Abnormal Case 2
    JSONObject = @[
                   [NSDate date],
                   [NSData data],
                   ];
    output = [WCJSONTool literalStringWithJSONObject:JSONObject startIndentLength:0 indentLength:2 ordered:YES];
    printf("%s\n", [output UTF8String]);
    printf("----------------------------------\n");
    expected = @""
R"(@[

])";
    XCTAssertEqualObjects(output, expected);
    
    // Abnormal Case 3
    JSONObject = @{
                   @"key": @"value",
                   @"date": [NSDate date],
                   @3: @"number"
                   };
    output = [WCJSONTool literalStringWithJSONObject:JSONObject startIndentLength:0 indentLength:2 ordered:YES];
    printf("%s\n", [output UTF8String]);
    printf("----------------------------------\n");
    expected = @""
R"(@{
  @"key" : @"value"
})";
    XCTAssertEqualObjects(output, expected);
    
    // Abnormal Case 4
    JSONObject = [NSDate date];
    output = [WCJSONTool literalStringWithJSONObject:JSONObject startIndentLength:0 indentLength:2 ordered:YES];
    XCTAssertNil(output);
    printf("%s\n", [output UTF8String]);
    printf("----------------------------------\n");
    XCTAssertNil(output);
}

- (void)test_compareNumbersRoughlyWithJSONValue1_JSONValue2 {
    id value1;
    id value2;
    NSNumber *output;
    
    // Case 1
    value1 = @"1.0";
    value2 = @(1);
    output = [WCJSONTool compareNumbersRoughlyWithJSONValue1:value1 JSONValue2:value2];
    XCTAssertNotNil(output);
    XCTAssertTrue([output integerValue] == NSOrderedSame);
    
    // Case 2
    value1 = @"3";
    value2 = @(3);
    output = [WCJSONTool compareNumbersRoughlyWithJSONValue1:value1 JSONValue2:value2];
    XCTAssertNotNil(output);
    XCTAssertTrue([output integerValue] == NSOrderedSame);
    
    // Case 3
    value1 = @"3";
    value2 = @"3.0";
    output = [WCJSONTool compareNumbersRoughlyWithJSONValue1:value1 JSONValue2:value2];
    XCTAssertNotNil(output);
    XCTAssertTrue([output integerValue] == NSOrderedSame);
    
    // Case 4
    value1 = @(5);
    value2 = @(5);
    output = [WCJSONTool compareNumbersRoughlyWithJSONValue1:value1 JSONValue2:value2];
    XCTAssertNotNil(output);
    XCTAssertTrue([output integerValue] == NSOrderedSame);
    
    // Case 5
    value1 = @"3.14";
    value2 = @"3.14";
    output = [WCJSONTool compareNumbersRoughlyWithJSONValue1:value1 JSONValue2:value2];
    XCTAssertNotNil(output);
    XCTAssertTrue([output integerValue] == NSOrderedSame);
    
    // Case 6
    value1 = @"3.14";
    value2 = @"3";
    output = [WCJSONTool compareNumbersRoughlyWithJSONValue1:value1 JSONValue2:value2];
    XCTAssertNotNil(output);
    XCTAssertTrue([output integerValue] == NSOrderedDescending);
    
    // Case 7
    value1 = @"3";
    value2 = @(3.14);
    output = [WCJSONTool compareNumbersRoughlyWithJSONValue1:value1 JSONValue2:value2];
    XCTAssertNotNil(output);
    XCTAssertTrue([output integerValue] == NSOrderedAscending);
    
    // Abnormal Case 1
    value1 = @{@"k": @"v"};
    value2 = @(3.14);
    output = [WCJSONTool compareNumbersRoughlyWithJSONValue1:value1 JSONValue2:value2];
    XCTAssertNotNil(output);
    XCTAssertTrue([output integerValue] == NSNotFound);
    
    // Abnormal Case 2
    value1 = @"3.14";
    value2 = @[@"1"];
    output = [WCJSONTool compareNumbersRoughlyWithJSONValue1:value1 JSONValue2:value2];
    XCTAssertNotNil(output);
    XCTAssertTrue([output integerValue] == NSNotFound);
}

#pragma mark - Internal Testing

- (void)test_literalStringWithJSONObject_indentLevel_startIndentLength_indentLength_ordered_isRootContainer {
    id JSONObject;
    NSString *output;
    
    // Case 1
    JSONObject = @{
                   @"str": @"a",
                   @"num": @3,
                   @"bool": @YES,
                   @"null": [NSNull null],
                   @"float": @3.14,
                   @"dict": @{
                     @"key": @"value",
                     @"jsonString": @"{\"url\":\"https://www.baidu.com/\"}",
                   }
                 };
    output = [WCJSONTool literalStringWithJSONObject:JSONObject indentLevel:0 startIndentLength:2 indentLength:2 ordered:YES isRootContainer:YES];
    printf("%s\n", [output UTF8String]);
    printf("----------------------------------\n");
    
    // Case 2
    JSONObject = @{
      @"bool" : @YES,
      @"dict" : @{
              @"jsonString" : @"{\"url\":\"https://www.baidu.com/\"}",
              @"key" : @"value"
              },
      @"float" : @(3.14),
      @"null" : [NSNull null],
      @"num" : @(3),
      @"str" : @"a"
      };
    
    output = [WCJSONTool literalStringWithJSONObject:JSONObject indentLevel:0 startIndentLength:2 indentLength:4 ordered:YES isRootContainer:YES];
    printf("%s\n", [output UTF8String]);
    printf("----------------------------------\n");
    
    // Case 3
    JSONObject = @{
                   @"arr": @[
                     @"a",
                     @3,
                     @3.14,
                     [NSNull null],
                     @YES,
                     @[
                         @"b",
                         @4,
                     ],
                   ]
                 };
    output = [WCJSONTool literalStringWithJSONObject:JSONObject indentLevel:0 startIndentLength:2 indentLength:4 ordered:YES isRootContainer:YES];
    printf("%s\n", [output UTF8String]);
    printf("----------------------------------\n");

    // Case 4
    JSONObject = @{
                   @"jsonString" : @"{\"jsonString\":\"{\\\"url\\\":\\\"https://www.baidu.com/\\\"}\"}"
                   };
    output = [WCJSONTool literalStringWithJSONObject:JSONObject indentLevel:0 startIndentLength:2 indentLength:4 ordered:YES isRootContainer:YES];
    printf("%s\n", [output UTF8String]);
    printf("----------------------------------\n");
}

#pragma mark -

- (void)test_ {
#define NSPREDICATE(expression)    ([NSPredicate predicateWithFormat:@"SELF MATCHES %@", expression])
    
    NSString *key;
    
    //
    key = @"0";
    XCTAssertTrue([NSPREDICATE(@"0|[1-9]\\d*") evaluateWithObject:key]);
    
    //
    key = @"100";
    XCTAssertTrue([NSPREDICATE(@"0|[1-9]\\d*") evaluateWithObject:key]);
    
    //
    key = @"001";
    XCTAssertFalse([NSPREDICATE(@"0|[1-9]\\d*") evaluateWithObject:key]);
    
    //
    key = @"00";
    XCTAssertFalse([NSPREDICATE(@"0|[1-9]\\d*") evaluateWithObject:key]);
    
    //
    key = @"100a";
    XCTAssertFalse([NSPREDICATE(@"0|[1-9]\\d*") evaluateWithObject:key]);
    
    //
    key = @"a";
    XCTAssertFalse([NSPREDICATE(@"0|[1-9]\\d*") evaluateWithObject:key]);
}

- (void)test_nil {
    @try {
        NSAssert(NO, @"test");
    }
    @catch (NSException *e) {
        NSLog(@"%@", e);
    }
}

- (void)test_222 {
    NSDictionary *dict1 = @{
                            @"name": @"tb_message_test_helloworld",
                            @"version": @"247991",
                            @"url": @"https://ossgw.alicdn.com/rapid-oss-bucket/publish/1551787247865/tb_message_test_helloworld.zip"
                            };
    
    NSDictionary *dict2 = @{
                            @"layoutJson": [WCJSONTool JSONStringWithObject:dict1 printOptions:kNilOptions],
                            @"height": @714
                            };
    
    NSDictionary *dict3 = @{
                            @"layoutData": [WCJSONTool JSONStringWithObject:dict2 printOptions:kNilOptions],
                            };
    
    NSString *JSONString = [WCJSONTool JSONStringWithObject:dict3 printOptions:kNilOptions];
    NSLog(@"%@", JSONString);
}

@end
