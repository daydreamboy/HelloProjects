//
//  Tests_CGGeometry.m
//  Tests
//
//  Created by wesley_chen on 2019/4/23.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreGraphics/CoreGraphics.h>

@interface Tests_CGGeometry : XCTestCase

@end

@implementation Tests_CGGeometry

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_CGRectStandardize {
    CGRect rect;
    CGRect output;
    
    // Case 1
    rect = CGRectMake(1, 2, -4, -3);
    output = CGRectStandardize(rect);
    XCTAssertTrue(CGRectEqualToRect(output, CGRectFromString(@"{{-3, -1}, {4, 3}}")));
}

- (void)test_CGRectIntegral {
    CGRect rect;
    CGRect output;
    
    // Case 1
    rect = CGRectMake(0.1, 0.5, 3.3, 2.7);
    output = CGRectIntegral(rect);
    XCTAssertTrue(CGRectEqualToRect(output, CGRectFromString(@"{{0, 0}, {4, 4}}")));
}

- (void)test_CGRectOffset {
    CGRect rect;
    CGRect output;
    
    // Case 1
    rect = CGRectMake(1, 2, 4, 3);
    output = CGRectOffset(rect, 2.0, 2.0);
    XCTAssertTrue(CGRectEqualToRect(output, CGRectFromString(@"{{3, 4}, {4, 3}}")));
}

- (void)test_CGRectInset {
    CGRect rect;
    CGRect output;
    
    // Case 1
    rect = CGRectMake(1, 2, 4, 3);
    output = CGRectInset(rect, 1.0, 0.0);
    XCTAssertTrue(CGRectEqualToRect(output, CGRectFromString(@"{{2, 2}, {2, 3}}")));
    
    // Case 2
    rect = CGRectMake(1, 2, 4, 3);
    output = CGRectInset(rect, -1.0, 0.0);
    XCTAssertTrue(CGRectEqualToRect(output, CGRectFromString(@"{{0, 2}, {6, 3}}")));
    
    // Case 3
    rect = CGRectMake(1, 2, 4, 3);
    output = CGRectInset(rect, 0.5, 0.0);
    XCTAssertTrue(CGRectEqualToRect(output, CGRectFromString(@"{{1.5, 2}, {3, 3}}")));
}

@end
