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

- (void)test_RGBHexStringFromUIColor {
    NSString *hexString;
    hexString = [WCColorTool RGBHexStringFromUIColor:[UIColor colorWithRed:0.188235 green:0.411765 blue:0.7171647 alpha:1]];
    NSLog(@"%@", hexString);
    XCTAssertEqualObjects(hexString, @"#3069B7");
}

#pragma mark - Color Conversion

#pragma mark > NSString to UIColor

- (void)test_colorWithHexString_prefix {
    NSString *hexString;
    UIColor *output;
    
    // Case 1
    hexString = @"#FF0000";
    output = [WCColorTool colorWithHexString:hexString prefix:@"#"];
    XCTAssertEqualObjects(output, [UIColor redColor]);
    
    // Case 2
    hexString = @"#FF0000";
    output = [WCColorTool colorWithHexString:hexString prefix:@"#"];
    XCTAssertNotEqualObjects(output, [UIColor greenColor]);
    
    // Case 3
    hexString = @"#FF0000FF";
    output = [WCColorTool colorWithHexString:hexString prefix:@"#"];
    XCTAssertNotEqualObjects(output, [UIColor greenColor]);
    
    // Case 4
    hexString = @"##FF0000";
    output = [WCColorTool colorWithHexString:hexString prefix:@"##"];
    XCTAssertEqualObjects(output, [UIColor redColor]);
    
    // Case 5
    hexString = @"FF0000";
    output = [WCColorTool colorWithHexString:hexString prefix:nil];
    XCTAssertEqualObjects(output, [UIColor redColor]);
    
    // Case 6
    hexString = @"FF0000FF";
    output = [WCColorTool colorWithHexString:hexString prefix:nil];
    XCTAssertEqualObjects(output, [UIColor redColor]);
    
    // Case 7
    hexString = @"FF0000";
    output = [WCColorTool colorWithHexString:hexString prefix:@""];
    XCTAssertEqualObjects(output, [UIColor redColor]);
}

@end
