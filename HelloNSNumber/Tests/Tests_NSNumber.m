//
//  Tests_NSNumber.m
//  Tests
//
//  Created by wesley_chen on 2019/1/11.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_NSNumber : XCTestCase

@end

@implementation Tests_NSNumber

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_objCType {
    NSNumber *number;
    NSString *type;
    
    // Case 1
    number = @1;
    type = [NSString stringWithUTF8String:[number objCType]];
    XCTAssertEqualObjects(type, @"i");
    
    // Case 1
    number = @YES;
    type = [NSString stringWithUTF8String:[number objCType]];
    XCTAssertEqualObjects(type, @"c");
    
    // Case 1
    number = @3.14;
    type = [NSString stringWithUTF8String:[number objCType]];
    XCTAssertEqualObjects(type, @"d");
    
    // Case 1
    number = @('a');
    type = [NSString stringWithUTF8String:[number objCType]];
    XCTAssertEqualObjects(type, @"c");
    
    number = [NSNumber numberWithChar:'b'];
    type = [NSString stringWithUTF8String:[number objCType]];
    XCTAssertEqualObjects(type, @"c");

}

@end
