//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2018/11/5.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

#define kImageMsgPreviewMinShowWidth                (120.f * [UIScreen mainScreen].bounds.size.width / 750.f)
#define kImageMsgPreviewMinShowHeight               (120.f * [UIScreen mainScreen].bounds.size.height / 750.f)

@interface Tests : XCTestCase

@end

@implementation Tests

// @see https://twistedape.me.uk/2016/02/02/comparing-floating-point-numbers/
bool compareNearlyEqual (float a, float b) {
    float epsilon;
    /* May as well do the easy check first. */
    if (a == b)
        return true;
    
    if (a > b) {
        epsilon = a * FLT_EPSILON;
    } else {
        epsilon = b * FLT_EPSILON;
    }
    
    return fabs (a - b) < epsilon;
}

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

#define FLOAT_COMPARE_EQUAL(f1, f2) (fabs((float)(f1) - (float)(f2)) < FLT_EPSILON)

- (void)test_compare_double_and_float {
    CGSize size = CGSizeZero;
    
    float width = kImageMsgPreviewMinShowWidth;
    float height = kImageMsgPreviewMinShowHeight;
    
    // Case 1
    size = CGSizeMake(width, height);
    XCTAssertFalse(size.width == kImageMsgPreviewMinShowWidth);
    XCTAssertFalse(size.height == kImageMsgPreviewMinShowHeight);
    
    NSLog(@"%f", size.width);
    NSLog(@"%f", kImageMsgPreviewMinShowWidth);
    
    // Case 2: double promotion not works here
    size = CGSizeMake((double)width, (double)height);
    XCTAssertFalse(size.width == kImageMsgPreviewMinShowWidth);
    XCTAssertFalse(size.height == kImageMsgPreviewMinShowHeight);
    
    NSLog(@"%f", size.width);
    NSLog(@"%f", kImageMsgPreviewMinShowWidth);
    
    // Case 3
    XCTAssertFalse(fabs((double)width - (double)kImageMsgPreviewMinShowWidth) < DBL_EPSILON);
    NSLog(@"%lf", fabs((double)width - (double)kImageMsgPreviewMinShowWidth));
    NSLog(@"%lf", DBL_EPSILON);
    
    // Solution
    XCTAssertTrue(fabs((float)width - (float)kImageMsgPreviewMinShowWidth) < FLT_EPSILON);
    XCTAssertTrue(FLOAT_COMPARE_EQUAL(width, kImageMsgPreviewMinShowWidth));
    NSLog(@"%lf", fabs((float)width - (float)kImageMsgPreviewMinShowWidth));
    NSLog(@"%lf", FLT_EPSILON);
    
    XCTAssertTrue(compareNearlyEqual(width, kImageMsgPreviewMinShowWidth));
    
    // Case  4: https://stackoverflow.com/a/5025021
    float f = 4.2;  // f is exactly 4.19999980926513671875
    double d = 4.2; // d is exactly 4.20000000000000017763568394002504646778106689453125
    
    XCTAssertFalse(f >= 4.2);
    XCTAssertFalse(f >= d);
    
    XCTAssertFalse(f == 4.2);
    XCTAssertFalse(f == d);
    
    // Solution
    XCTAssertTrue(FLOAT_COMPARE_EQUAL(f, 4.2));
    XCTAssertTrue(FLOAT_COMPARE_EQUAL(f, d));
}

@end
