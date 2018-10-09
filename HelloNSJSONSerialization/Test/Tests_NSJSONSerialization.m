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

@end
