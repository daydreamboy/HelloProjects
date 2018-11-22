//
//  Test_NSExpression.m
//  Tests
//
//  Created by wesley_chen on 2018/11/22.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSNumber+CustomFunction.h"

@interface Test_NSExpression : XCTestCase

@end

@implementation Test_NSExpression

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_expressionForFunction_arguments {
    NSArray *arguments;
    
    // Case 1
    arguments = @[[NSExpression expressionForConstantValue:@(4)]];
    XCTAssertThrows([NSExpression expressionForFunction:@"factorial" arguments:arguments]);
}

@end
