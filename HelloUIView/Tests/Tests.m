//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2018/10/15.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCViewTool.h"
#import <AVFoundation/AVFoundation.h>

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

- (void)test_safeAVMakeAspectRatioRectWithContentSize_insideBoundingRect {
    CGRect scaledRect1;
    CGRect scaledRect2;
    
    // Case 1
    scaledRect1 = AVMakeRectWithAspectRatioInsideRect(CGSizeMake(100, 200), CGRectMake(0, 0, 50, 70));
    scaledRect2 = [WCViewTool safeAVMakeAspectRatioRectWithContentSize:CGSizeMake(100, 200) insideBoundingRect:CGRectMake(0, 0, 50, 70)];
    XCTAssertTrue(CGRectEqualToRect(scaledRect1, scaledRect2));
    
    // Case 2
    scaledRect1 = AVMakeRectWithAspectRatioInsideRect(CGSizeMake(100, 200), CGRectMake(10, 20, 50, 70));
    scaledRect2 = [WCViewTool safeAVMakeAspectRatioRectWithContentSize:CGSizeMake(100, 200) insideBoundingRect:CGRectMake(10, 20, 50, 70)];
    XCTAssertTrue(CGRectEqualToRect(scaledRect1, scaledRect2));
}

- (void)test_makeAspectRatioRectWithContentSize_insideBoundingRect {
    CGRect scaledRect1;
    CGRect scaledRect2;
    
    // Case 1
    scaledRect1 = AVMakeRectWithAspectRatioInsideRect(CGSizeMake(100, 200), CGRectMake(0, 0, 50, 70));
    scaledRect2 = [WCViewTool makeAspectRatioRectWithContentSize:CGSizeMake(100, 200) insideBoundingRect:CGRectMake(0, 0, 50, 70)];
    XCTAssertTrue(CGRectEqualToRect(scaledRect1, scaledRect2));

    // Case 2
    scaledRect1 = AVMakeRectWithAspectRatioInsideRect(CGSizeMake(100, 200), CGRectMake(10, 20, 50, 70));
    scaledRect2 = [WCViewTool makeAspectRatioRectWithContentSize:CGSizeMake(100, 200) insideBoundingRect:CGRectMake(10, 20, 50, 70)];
    XCTAssertTrue(CGRectEqualToRect(scaledRect1, scaledRect2));

    // Case 3
    scaledRect1 = AVMakeRectWithAspectRatioInsideRect(CGSizeMake(200, 100), CGRectMake(10, 20, 50, 70));
    scaledRect2 = [WCViewTool makeAspectRatioRectWithContentSize:CGSizeMake(200, 100) insideBoundingRect:CGRectMake(10, 20, 50, 70)];
    XCTAssertTrue(CGRectEqualToRect(scaledRect1, scaledRect2));

    // Case 4
    scaledRect1 = AVMakeRectWithAspectRatioInsideRect(CGSizeMake(10, 20), CGRectMake(10, 20, 50, 70));
    scaledRect2 = [WCViewTool makeAspectRatioRectWithContentSize:CGSizeMake(10, 20) insideBoundingRect:CGRectMake(10, 20, 50, 70)];
    XCTAssertTrue(CGRectEqualToRect(scaledRect1, scaledRect2));

    // Case 5
    scaledRect1 = AVMakeRectWithAspectRatioInsideRect(CGSizeMake(20, 10), CGRectMake(10, 20, 50, 70));
    scaledRect2 = [WCViewTool makeAspectRatioRectWithContentSize:CGSizeMake(20, 10) insideBoundingRect:CGRectMake(10, 20, 50, 70)];
    XCTAssertTrue(CGRectEqualToRect(scaledRect1, scaledRect2));

    // Case 6
    scaledRect1 = AVMakeRectWithAspectRatioInsideRect(CGSizeMake(100, 140), CGRectMake(10, 20, 50, 70));
    scaledRect2 = [WCViewTool makeAspectRatioRectWithContentSize:CGSizeMake(100, 140) insideBoundingRect:CGRectMake(10, 20, 50, 70)];
    XCTAssertTrue(CGRectEqualToRect(scaledRect1, scaledRect2));

    // Case 7
    scaledRect1 = AVMakeRectWithAspectRatioInsideRect(CGSizeMake(25, 35), CGRectMake(10, 20, 50, 70));
    scaledRect2 = [WCViewTool makeAspectRatioRectWithContentSize:CGSizeMake(25, 35) insideBoundingRect:CGRectMake(10, 20, 50, 70)];
    XCTAssertTrue(CGRectEqualToRect(scaledRect1, scaledRect2));
    
    // Case 8
    scaledRect1 = AVMakeRectWithAspectRatioInsideRect(CGSizeMake(672, 500), CGRectMake(0, 0, 300, 200));
    scaledRect2 = [WCViewTool makeAspectRatioRectWithContentSize:CGSizeMake(672, 500) insideBoundingRect:CGRectMake(0, 0, 300, 200)];
    XCTAssertTrue(CGRectEqualToRect(scaledRect1, scaledRect2));
}

@end
