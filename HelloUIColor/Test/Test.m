//
//  Test.m
//  Test
//
//  Created by wesley_chen on 2018/7/30.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCColorTool.h"

@interface Test : XCTestCase

@end

@implementation Test

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_WCColorTool_RGBHexStringFromUIColor {
    NSString *hexString;
    hexString = [WCColorTool RGBHexStringFromUIColor:[UIColor colorWithRed:0.188235 green:0.411765 blue:0.7171647 alpha:1]];
    NSLog(@"%@", hexString);
    XCTAssertEqualObjects(hexString, @"#3069B7");
}

@end
