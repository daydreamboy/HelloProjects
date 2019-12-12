//
//  Tests_Primitive.m
//  Tests
//
//  Created by wesley_chen on 2019/12/11.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PrimitivePropertyObject.h"

@interface Tests_Primitive : XCTestCase

@end

@implementation Tests_Primitive

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

// @see https://stackoverflow.com/a/18036038
- (void)test_KVC_primitive {
    PrimitivePropertyObject *object;
    
    int integerNumber = 5;
    CGSize size = CGSizeMake(100, 100);
    
    // Case 1
    object = [PrimitivePropertyObject new];
    [object setValue:[NSNumber numberWithInt:integerNumber] forKey:@"integerNumber"];
    XCTAssertTrue(object.integerNumber == integerNumber);
    
    // Case 2
    object = [PrimitivePropertyObject new];
    [object setValue:[NSValue valueWithCGSize:size] forKey:@"size"];
    
    XCTAssertTrue(CGSizeEqualToSize(object.size, size));
}

@end
