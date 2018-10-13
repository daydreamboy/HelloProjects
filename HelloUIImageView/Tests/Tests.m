//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2018/10/12.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AVFoundation/AVFoundation.h>

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_AVMakeRectWithAspectRatioInsideRect {
    CGSize aspectRatio;
    CGRect boundingRect;
    CGRect outputRect;
    
    // Case 1
    aspectRatio = CGSizeMake(50, 100);
    boundingRect = CGRectMake(0, 0, 100, 100);
    outputRect = AVMakeRectWithAspectRatioInsideRect(aspectRatio, boundingRect);
    XCTAssertTrue(CGRectEqualToRect(outputRect, CGRectMake(10, 10, 100, 100)));
    
    // Case 2
    aspectRatio = CGSizeMake(70, 70);
    boundingRect = CGRectMake(0, 0, 100, 100);
    outputRect = AVMakeRectWithAspectRatioInsideRect(aspectRatio, boundingRect);
    XCTAssertTrue(CGRectEqualToRect(outputRect, CGRectMake(10, 10, 100, 100)));
}

@end
