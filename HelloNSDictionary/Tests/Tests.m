//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2018/8/31.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCDictionaryTool.h"

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

- (void)test_objectWithDictionary_forKey_objectClass {
    NSDictionary *dict;
    NSString *key;
    Class class;
    id value;
    
    // Case 1
    dict = @{};
    value = [WCDictionaryTool objectWithDictionary:dict forKey:@"b.a.b" objectClass:[NSString class]];
    XCTAssertNil(value);
}

@end
