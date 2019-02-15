//
//  Tests_Block.m
//  Tests
//
//  Created by wesley_chen on 2019/2/15.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_Block : XCTestCase

@end

@implementation Tests_Block

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_block_return_type_optional {
    // Note: sample code from https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Blocks/Articles/bxDeclaringCreating.html
    float (^oneFrom)(float);
    
    // Note: OK, only one return statement
    oneFrom = ^(float aFloat) {
        float result = aFloat - 1.0;
        return result;
    };
    
    XCTAssertTrue(oneFrom(3.14) == 2.14f);
    
    // Note: OK, specify return type is best
    oneFrom = ^float(float aFloat) {
        float result = aFloat - 1.0;
        return result;
    };
    
    XCTAssertTrue(oneFrom(3.14) == 2.14f);
    
    // Compiler Error: can't deduce the return type
    /*
    oneFrom = ^(float aFloat) {
        float result = aFloat - 1.0;
        if (aFloat > 3) {
            return aFloat - 3.0; // Note: this is double
        }
        return result;
    };
     */
    
    oneFrom = ^float(float aFloat) {
        float result = aFloat - 1.0;
        if (aFloat > 3) {
            return aFloat - 3.0; // Note: this is double
        }
        return result;
    };

    XCTAssertFalse(oneFrom(3.14) == 0.14f);
}

- (void)test_block_as_parameter {
    [self completion:^BOOL(id JSONObject, NSError *error) {
        return YES;
    }];
}

- (void)completion:(BOOL (^)(id JSONObject, NSError *error))completion {
    if (completion) {
        completion(@{}, nil);
    }
}

@end
