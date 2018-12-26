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

- (void)test_formatString_function {
    NSString *formatString;
    NSDictionary *variables;
    NSExpression *mathExpression;
    id value;
    
    // Case 1
    formatString = @"FUNCTION(3, 'factorial')";
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:nil context:nil];
    XCTAssertEqualObjects(value, @6);
    
    // Case 2
    formatString = @"FUNCTION(a, 'factorial')";
    variables = @{
                  @"a": @3
                  };
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @6);

    // Case 2
    formatString = @"1 + FUNCTION(a, 'factorial')";
    variables = @{
                  @"a": @3
                  };
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @7);
    
    // Case 2
    formatString = @"FUNCTION(FUNCTION(3, 'factorial'), 'factorial')";
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @720);
    
    // Case 2
    formatString = @"FUNCTION(2, 'pow:', FUNCTION(3, 'factorial'))";
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @64);
    
    // Case 2
    formatString = @"FUNCTION(2, 'pow:', FUNCTION(FUNCTION(2, 'factorial'), 'factorial'))";
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @4);
    
    // Case 3
    formatString = @"FUNCTION(a, 'uppercase')";
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:nil context:nil];
    XCTAssertNil(value);
    
    // Case 4
    formatString = @"FUNCTION(a, 'uppercase')";
    variables = @{
                  @"a": @"a"
                  };
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @"A");
    
    // Case 5
    formatString = @"FUNCTION('a', 'uppercase')";
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:nil context:nil];
    XCTAssertEqualObjects(value, @"A");
    
    // Case 5
    formatString = @"'FUNCTION('a', 'uppercase')'";
    XCTAssertThrows([NSExpression expressionWithFormat:formatString]);
    
    // Case 5
    formatString = @"1 + FUNCTION('a', 'uppercase')";
    mathExpression = [NSExpression expressionWithFormat:formatString];
    XCTAssertThrows([mathExpression expressionValueWithObject:nil context:nil]);
    
    // Case 6
    formatString = @"FUNCTION('a', 'uppercaseString')";
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:nil context:nil];
    XCTAssertEqualObjects(value, @"A");
    
    // Case 7
    formatString = @"FUNCTION('abc', 'characterStringAtIndex:', a)";
    variables = @{
                  @"a": @1
                  };
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @"b");
    
    // Case 8
    formatString = @"FUNCTION('abc', func, a)";
    variables = @{
                  @"a": @1,
                  @"func": @"characterStringAtIndex:"
                  };
    XCTAssertThrows([NSExpression expressionWithFormat:formatString]);
}

- (void)test_expressionValueWithObject {
    NSString *formatString;
    NSDictionary *variables;
    NSExpression *mathExpression;
    NSNumber *number;
    
    // Case 1
    formatString = @"12.845 * x + (y)";
    mathExpression = [NSExpression expressionWithFormat:formatString];
    XCTAssertThrows([mathExpression expressionValueWithObject:variables context:nil]);
    
    // Case 2
    formatString = @"12.845 * x + (y)";
    mathExpression = [NSExpression expressionWithFormat:formatString];
    variables = @{
                  @"x": @1,
                  };
    XCTAssertThrows([mathExpression expressionValueWithObject:variables context:nil]);
    
    // Case 3
    formatString = @"12.845 * x + (y)";
    mathExpression = [NSExpression expressionWithFormat:formatString];
    variables = @{
                  @"x": @1,
                  @"y": @2,
                  };
    number = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(number, @14.845);
    
    // Case 4
    formatString = @"12.845 * x.a + (y.b)";
    mathExpression = [NSExpression expressionWithFormat:formatString];
    variables = @{
                  @"x": @{
                          @"a": @1
                          },
                  @"y": @{
                          @"b": @2
                          },
                  };
    number = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(number, @14.845);
    
    // Case 5
    formatString = @"12.845 * x[a] + (y.b)";
    mathExpression = [NSExpression expressionWithFormat:formatString];
    variables = @{
                  @"x": @{
                          @"a": @1
                          },
                  @"y": @{
                          @"b": @2
                          },
                  };
    XCTAssertThrows([mathExpression expressionValueWithObject:variables context:nil]);
    
    // Case 6
    formatString = @"12.845 * x[0] + x[1]";
    mathExpression = [NSExpression expressionWithFormat:formatString];
    variables = @{
                  @"x": @[
                          @1,
                          @2
                          ],
                  };
    number = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(number, @14.845);
    
    // Case 7
    formatString = @"12.845 * x.0 + x.1";
    XCTAssertThrows([NSExpression expressionWithFormat:formatString]);
    
    // Case 8
    formatString = @"a12.845 * x[0] + x[1]";
    XCTAssertThrows([NSExpression expressionWithFormat:formatString]);
    
    // Case 9
    formatString = @"12.845 == 12.845";
    XCTAssertThrows([NSExpression expressionWithFormat:formatString]);
    
    // Case 10
    formatString = @"TRUEPREDICATE";
    XCTAssertThrows([NSExpression expressionWithFormat:formatString]);
    
    // Case 11
    formatString = @"12.845 * x[0] + x[1]";
    mathExpression = [NSExpression expressionWithFormat:formatString];
    variables = @{
                  @"x": @[
                          @"1",
                          @2
                          ],
                  };
    XCTAssertThrows([mathExpression expressionValueWithObject:variables context:nil]);
}

@end
