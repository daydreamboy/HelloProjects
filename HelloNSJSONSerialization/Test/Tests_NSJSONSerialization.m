//
//  Tests_NSJSONSerialization.m
//  Test
//
//  Created by wesley_chen on 2018/9/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

// >= `11.0`
#ifndef IOS11_OR_LATER
#define IOS11_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@interface Tests_NSJSONSerialization : XCTestCase

@end

@implementation Tests_NSJSONSerialization

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_NSJSONSerialization_issue_on_iOS11 {
    id rootObject;
    
    // Case 1
    rootObject = @{@"num": @3.14 };
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:rootObject options:kNilOptions error:&error];
    
    // BUG: https://openradar.appspot.com/34032848 (iOS 11+)
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
    if (IOS11_OR_LATER) {
        XCTAssertEqualObjects(jsonString, @"{\"num\":3.1400000000000001}");
    }
    else {
        XCTAssertEqualObjects(jsonString, @"{\"num\":3.14}");
    }
}

- (void)test_NSJSONSerialization_issue_on_control_characters {
    NSString *JSONString;
    id JSONObject;
    NSError *error = nil;
    
    // Abnormal Case：\n
    JSONString = @"{\"wxIdentity\":\"chatting-tmall\",\"wxOpt\":\"{\\\"height\\\":\\\"240\\\"}\",\"wxData\":\"{\\\"img\\\":\\\"http://gw.alicdn.com/mt/TB1PEudXR1D3KVjSZFyXXbuFpXa-100-100.png\\\",\\\"themeColor\\\":\\\"#999999\\\",\\\"srcIcon\\\":\\\"https://gw.alicdn.com/tfs/TB15UZ2jnZmx1VjSZFGXXax2XXa-26-26.png\\\",\\\"interact\\\":\\\"\\\",\\\"source\\\":\\\"淘宝人生\\\",\\\"title\\\":\\\"送给你一张心愿卡\\\",\\\"wxDisplayType\\\":\\\"淘宝人生\\\",\\\"url\\\":\\\"https://market.m.taobao.com/app/wireless-platform/c6_seclife/index.html?disableNav=YES&from=msgcard\\\",\\\"desc\\\":\\\"帮你实现你的心愿，快来领取这份礼物吧\n        \\\",\\\"wxDisplayName\\\":\\\"快来开启属于你的淘宝人生\\\"}\",\"wxTplUrl\":\"http://market.m.taobao.com/app/tb-chatting/feed-cards/tmall_card?wh_ttid=native\",\"wxDisplayType\":\"淘宝人生\",\"wxDisplayName\":\"您有一条淘宝人生信息\"}";
    
    JSONObject = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    XCTAssertNil(JSONObject);
    NSLog(@"%@", error);
}

- (void)test_NSJSONSerialization_issue {
    NSString *JSONString;
    id JSONObject;
    NSError *error = nil;
    
    // Abnormal Case：empty string
    JSONString = @"";
    
    JSONObject = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    XCTAssertNil(JSONObject);
    NSLog(@"%@", error);
}

- (void)test_NSJSONSerialization_NSJSONReadingAllowFragments {
    NSString *JSONString;
    NSData *data;
    id JSONObject;
    
    // Case 1
    JSONString = @"\"{\\\"key\\\":\\\"value\\\"}\"";
    data = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    
    JSONObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    XCTAssertNil(JSONObject);
    
    // Note: using NSJSONReadingAllowFragments allows fragments such as string, number, booleans
    JSONObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    XCTAssertNotNil(JSONObject);
    XCTAssertTrue([JSONObject isKindOfClass:[NSString class]]);
    XCTAssertTrue([JSONObject length] > 0);
    
    // Case 2
    JSONString = @"\"123\"";
    data = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    
    JSONObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    XCTAssertNil(JSONObject);
    
    // Note: using NSJSONReadingAllowFragments allows fragments such as string, number, booleans
    JSONObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    XCTAssertNotNil(JSONObject);
    XCTAssertTrue([JSONObject isKindOfClass:[NSString class]]);
    XCTAssertTrue([JSONObject isEqualToString:@"123"]);
    
    // Case 3
    JSONString = @"null";
    data = [JSONString dataUsingEncoding:NSUTF8StringEncoding];

    JSONObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    XCTAssertNil(JSONObject);

    // Note: using NSJSONReadingAllowFragments allows fragments such as string, number, booleans
    JSONObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    XCTAssertNotNil(JSONObject);
    XCTAssertTrue([JSONObject isKindOfClass:[NSNull class]]);
    XCTAssertTrue(JSONObject == [NSNull null]);

    // Case 4
    JSONString = @"true";
    data = [JSONString dataUsingEncoding:NSUTF8StringEncoding];

    JSONObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    XCTAssertNil(JSONObject);

    // Note: using NSJSONReadingAllowFragments allows fragments such as string, number, booleans
    JSONObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    XCTAssertNotNil(JSONObject);
    XCTAssertTrue([JSONObject isKindOfClass:[NSNumber class]]);
    XCTAssertTrue([@YES isEqualToNumber:JSONObject]);
    
    // Case 5
    JSONString = @"false";
    data = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    
    JSONObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    XCTAssertNil(JSONObject);
    
    // Note: using NSJSONReadingAllowFragments allows fragments such as string, number, booleans
    JSONObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    XCTAssertNotNil(JSONObject);
    XCTAssertTrue([JSONObject isKindOfClass:[NSNumber class]]);
    XCTAssertTrue([@NO isEqualToNumber:JSONObject]);
    
    // Case 6
    JSONString = @"1";
    data = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    
    JSONObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    XCTAssertNil(JSONObject);
    
    // Note: using NSJSONReadingAllowFragments allows fragments such as string, number, booleans
    JSONObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    XCTAssertNotNil(JSONObject);
    XCTAssertTrue([JSONObject isKindOfClass:[NSNumber class]]);
    XCTAssertTrue([@1 isEqualToNumber:JSONObject]);
    
    // Case 7
    JSONString = @"0";
    data = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    
    JSONObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    XCTAssertNil(JSONObject);
    
    // Note: using NSJSONReadingAllowFragments allows fragments such as string, number, booleans
    JSONObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    XCTAssertNotNil(JSONObject);
    XCTAssertTrue([JSONObject isKindOfClass:[NSNumber class]]);
    XCTAssertTrue([@0 isEqualToNumber:JSONObject]);
    
    // Case 8
    JSONString = @"{\"key\":\"value\"}";
    data = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    
    JSONObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    XCTAssertNotNil(JSONObject);
    XCTAssertTrue([JSONObject isKindOfClass:[NSDictionary class]]);
    XCTAssertTrue([[JSONObject objectForKey:@"key"] isEqualToString:@"value"]);
    
    // Note: using NSJSONReadingAllowFragments allows fragments such as string, number, booleans
    JSONObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    XCTAssertNotNil(JSONObject);
    XCTAssertTrue([JSONObject isKindOfClass:[NSDictionary class]]);
    XCTAssertTrue([[JSONObject objectForKey:@"key"] isEqualToString:@"value"]);
    
    // Case 9
    JSONString = @"[\"1\"]";
    data = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    
    JSONObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    XCTAssertNotNil(JSONObject);
    XCTAssertTrue([JSONObject isKindOfClass:[NSArray class]]);
    XCTAssertTrue([[JSONObject objectAtIndex:0] isEqualToString:@"1"]);
    
    // Note: using NSJSONReadingAllowFragments allows fragments such as string, number, booleans
    JSONObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    XCTAssertNotNil(JSONObject);
    XCTAssertTrue([JSONObject isKindOfClass:[NSArray class]]);
    XCTAssertTrue([[JSONObject objectAtIndex:0] isEqualToString:@"1"]);
}

- (void)test_NSJSONSerialization_dataWithJSONObject_options_error {
    NSData *jsonData = nil;
    NSError *error = nil;
    id JSONObject;
    NSString *jsonString;
    
    // Case 1
    JSONObject = @{@"num": @1};
    jsonData = [NSJSONSerialization dataWithJSONObject:JSONObject options:kNilOptions error:&error];
    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

- (void)test_NSJSONSerialization_escaped_JSONString {
    NSData *jsonData = nil;
    NSError *error = nil;
    id JSONObject;
    NSString *jsonString;
    
    // Case 1
    JSONObject = @{@"num": @1};
    jsonData = [NSJSONSerialization dataWithJSONObject:JSONObject options:kNilOptions error:&error];
    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *container = @{@"key": jsonString};
    
    NSData *JSONData2 = [NSJSONSerialization dataWithJSONObject:container options:kNilOptions error:&error];
    NSMutableString *JSONString2 = [[[NSString alloc] initWithData:JSONData2 encoding:NSUTF8StringEncoding] mutableCopy];
    [JSONString2 deleteCharactersInRange:NSMakeRange(JSONString2.length - 1, @"}".length)];
    [JSONString2 deleteCharactersInRange:NSMakeRange(0, @"{\"key\":".length)];
    
    NSLog(@"%@", JSONString2);
    XCTAssertEqualObjects(JSONString2, @"\"{\\\"num\\\":1}\"");
}

@end
