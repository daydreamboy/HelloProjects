//
//  Tests_NSObject.m
//  Tests
//
//  Created by wesley_chen on 2019/5/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KeyedSubscriptingObject.h"
#import "IndexedSubscriptingObject.h"

@interface Tests_NSObject : XCTestCase

@end

@implementation Tests_NSObject

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_keyedSubscript {
    id output;
    KeyedSubscriptingObject<NSString *, NSString *> *map = [KeyedSubscriptingObject new];
    
    // Case 1
    map[@"key"] = @"value";
    output = map[@"key"];
    XCTAssertEqualObjects(output, @"value");
    
    // Case 2
    map[@"key"] = nil;
    output = map[@"key"];
    XCTAssertNil(output);
}

- (void)test_indexedSubscript {
    id output;
    IndexedSubscriptingObject<NSString *> *list = [IndexedSubscriptingObject new];
    
    // Case 1
    list[1] = @"value";
    output = list[1];
    XCTAssertEqualObjects(output, @"value");
    output = list[0];
    XCTAssertNil(output);
    
    // Case 2
    list[1] = nil;
    output = list[1];
    XCTAssertNil(output);
    output = list[0];
    XCTAssertNil(output);
}

@end
