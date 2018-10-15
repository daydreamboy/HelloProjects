//
//  Tests_AVMakeRectWithAspectRatioInsideRect.m
//  Tests
//
//  Created by wesley_chen on 2018/10/15.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AVFoundation/AVFoundation.h>

@interface Tests_AVMakeRectWithAspectRatioInsideRect : XCTestCase

@end

@implementation Tests_AVMakeRectWithAspectRatioInsideRect

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_AVMakeRectWithAspectRatioInsideRect {
    CGRect scaledRect;
    
    // Case 1
    scaledRect = AVMakeRectWithAspectRatioInsideRect(CGSizeZero, CGRectMake(10, 10, 300, 200));
    XCTAssertTrue(isnan(scaledRect.origin.x));
    XCTAssertTrue(isnan(scaledRect.origin.y));
    XCTAssertTrue(isnan(scaledRect.size.width));
    XCTAssertTrue(isnan(scaledRect.size.height));
}

@end
