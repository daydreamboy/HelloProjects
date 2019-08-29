//
//  Tests_WCOrderedDictionary.m
//  Tests
//
//  Created by wesley_chen on 2019/8/29.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCOrderedDictionary.h"

@interface Tests_WCOrderedDictionary : XCTestCase

@end

@implementation Tests_WCOrderedDictionary

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_fast_enumeration {
    WCOrderedDictionary *dict = [WCOrderedDictionary dictionary];
    for (NSInteger i = 0; i < 100; i++) {
        dict[[NSString stringWithFormat:@"%d", (int)i]] = @(i);
    }
    
    XCTAssertTrue(dict.count == 100);
    
    NSUInteger count = 0;
    for (NSString *key in dict) {
        id value = dict[key];
        XCTAssertEqualObjects(value, @(count));
        count++;
    }
}

- (void)test_description {
    WCOrderedDictionary *dict = [WCOrderedDictionary dictionary];
    for (NSInteger i = 0; i < 100; i++) {
        dict[[NSString stringWithFormat:@"%d", (int)i]] = @(i);
    }
    
    NSLog(@"%@", dict);
}

- (void)test_orderedDictionaryFromDictionary {
    WCOrderedDictionary *orderedDict;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < 100; i++) {
        dict[@(i)] = [NSString stringWithFormat:@"%d", (int)i];
    }
    
    orderedDict = [WCOrderedDictionary orderedDictionaryFromDictionary:dict];
    
    NSUInteger count = 0;
    for (NSNumber *key in orderedDict) {
        id value = orderedDict[key];
        id expectedValue = [NSString stringWithFormat:@"%d", (int)count];
        XCTAssertEqualObjects(value, expectedValue);
        count++;
    }
}

@end
