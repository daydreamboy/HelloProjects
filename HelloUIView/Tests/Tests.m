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

#pragma mark - Assistant Methods

#pragma mark > CGRect

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

- (void)test_centeredRectInRectWithSize_inRect {
    CGSize centeredRectSize;
    CGRect superRect;
    CGRect centeredRect;
    
    // Case 1
    centeredRectSize = CGSizeMake(120, 150);
    superRect = CGRectMake(0, 0, 120, 1200);
    centeredRect = [WCViewTool centeredRectInRectWithSize:centeredRectSize inRect:superRect];
    XCTAssertTrue(CGRectEqualToRect(centeredRect, CGRectMake(0, (superRect.size.height - centeredRectSize.height) / 2.0, centeredRectSize.width, centeredRectSize.height)));
    
    // Case 2
    centeredRectSize = CGSizeMake(120, 150);
    superRect = CGRectMake(10, 0, 900, 1200);
    centeredRect = [WCViewTool centeredRectInRectWithSize:centeredRectSize inRect:superRect];
    XCTAssertTrue(CGRectEqualToRect(centeredRect, CGRectMake(superRect.origin.x + (superRect.size.width - centeredRectSize.width) / 2.0, superRect.origin.y + (superRect.size.height - centeredRectSize.height) / 2.0, centeredRectSize.width, centeredRectSize.height)));
    
    // Case 3
    centeredRectSize = CGSizeMake(300, 750);
    superRect = CGRectMake(10, 20, 100, 200);
    centeredRect = [WCViewTool centeredRectInRectWithSize:centeredRectSize inRect:superRect];
    XCTAssertTrue(CGRectEqualToRect(centeredRect, CGRectMake(superRect.origin.x + (superRect.size.width - centeredRectSize.width) / 2.0, superRect.origin.y + (superRect.size.height - centeredRectSize.height) / 2.0, centeredRectSize.width, centeredRectSize.height)));
}

- (void)test_FrameSet {
    CGSize size;
    CGRect frame;
    CGRect output;
    
    // Case 1
    size = CGSizeMake(200, 200);
    frame = CGRectMake(10, 10, 100, 100);
    output = FrameSet(frame, NAN, NAN, size.width, size.height);
    XCTAssertTrue(output.size.width == 200 && output.size.height == 200);
    
    // Case 2
    size = CGSizeMake(200, 200);
    frame = CGRectMake(10, 10, 100, 100);
    output = FrameSet(frame, NAN, NAN, size.width, NAN);
    XCTAssertTrue(output.size.width == 200 && output.size.height == 100);
    
    // Case 3
    size = CGSizeMake(200, 200);
    frame = CGRectMake(10, 10, 100, 100);
    output = FrameSet(frame, 20, 30, NAN, NAN);
    XCTAssertTrue(output.origin.x == 20 && output.origin.y == 30 && output.size.width == 100 && output.size.height == 100);
}

- (void)test_CGSize {
    CGSize size1 = CGSizeFromString(@"{227, 55.333333333333336}");
    CGSize size2 = CGSizeMake(227, 166 / 3.0);
    
    if (CGSizeEqualToSize(size1, size2)) {
        NSLog(@"equal");
    }
    else {
        NSLog(@"not equal");
    }
    
    NSLog(@"%@", NSStringFromCGSize(size1));
    NSLog(@"%@", NSStringFromCGSize(size2));
}

@end
