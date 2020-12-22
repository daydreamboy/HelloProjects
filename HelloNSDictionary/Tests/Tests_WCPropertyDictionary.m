//
//  Tests_WCPropertyDictionary.m
//  Tests
//
//  Created by wesley_chen on 2020/12/22.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ModelWithProperties.h"

@interface Tests_WCPropertyDictionary : XCTestCase

@end

@implementation Tests_WCPropertyDictionary

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_ModelWithProperties {
    NSDictionary *dict;
    
    // Case 1
    ModelWithProperties *model = [ModelWithProperties new];
    model.string = @"abc";
    model.number = @(1);
    model.integerValue = 2;
    model.object = [NSObject new];
    
    dict = [model toDictionary];
    NSLog(@"%@", dict);
    XCTAssertEqualObjects(dict[@"string"], @"abc");
    XCTAssertEqualObjects(dict[@"number"], @(1));
    XCTAssertEqualObjects(dict[@"integerValue"], @(2));
    
    XCTAssertEqual(dict[@"object"], model.object);
    XCTAssertEqual(dict[@"string"], model.string);
}


@end
