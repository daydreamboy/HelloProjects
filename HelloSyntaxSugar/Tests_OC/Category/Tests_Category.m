//
//  Tests_Category.m
//  Tests_OC
//
//  Created by wesley_chen on 2019/6/29.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BaseClassA1.h"
#import "BaseClassA1+Category.h"

@interface Tests_Category : XCTestCase

@end

@implementation Tests_Category

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_category_primary_class_both_same_method {
    NSString *output;
    
    BaseClassA1 *A1 = [BaseClassA1 new];
    
    // Case 1
    output = [A1 thisMethodOverrideByCategory];
    XCTAssertEqualObjects(output, @"BaseClassA1 (Category)->thisMethodOverrideByCategory");
    
    // Case 2
    output = [A1 internallyCallThisMethodOverrideByCategory];
    XCTAssertEqualObjects(output, @"BaseClassA1 (Category)->thisMethodOverrideByCategory");
}

@end
