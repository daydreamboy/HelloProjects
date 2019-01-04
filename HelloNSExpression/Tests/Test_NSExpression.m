//
//  Test_NSExpression.m
//  Tests
//
//  Created by wesley_chen on 2018/11/22.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSNumber+CustomFunction.h"
#import "NSArray+CustomFunction.h"
#import "Person.h"

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

- (void)test_expressionWithFormat {
    NSString *formatString;
    NSExpression *mathExpression;
    id value;
    
    // Case 1
    formatString = @"1 + 1";
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:nil context:nil];
    XCTAssertEqualObjects(value, @2);
    
    // Case 2
    formatString = @"%@ + %@";
    mathExpression = [NSExpression expressionWithFormat:formatString, @1, @1];
    value = [mathExpression expressionValueWithObject:nil context:nil];
    XCTAssertEqualObjects(value, @2);
    XCTAssertEqualObjects(mathExpression.description, @"1 + 1");
    
    // Case 3
    formatString = @"%@ + %@";
    mathExpression = [NSExpression expressionWithFormat:formatString, @"1", @"1"];
    @try {
        value = [mathExpression expressionValueWithObject:nil context:nil];
    }
    @catch (NSException *e) {
        XCTAssertTrue(YES);
    }
    XCTAssertEqualObjects(mathExpression.description, @"\"1\" + \"1\"");
    
    @try {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:formatString, @"1", @"1"];
        XCTAssertEqualObjects(predicate.predicateFormat, @"\"1\" + \"1\"");
    }
    @catch (NSException *e) {
        XCTAssertTrue(YES);
    }
}

- (void)test_expressionWithFormat_2 {
    NSString *formatString;
    NSDictionary *variables;
    NSExpression *mathExpression;
    id value;
    
    // Case 1
    formatString = @"x.@count";//@"x[SIZE]";
    mathExpression = [NSExpression expressionWithFormat:formatString];
    variables = @{
                  @"x": @[
                          @"1",
                          @2
                          ],
                  };
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @2);
}

- (void)test_expressionWithFormat_exception {
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

- (void)test_expressionValueWithObject {
    NSString *formatString;
    NSExpression *mathExpression;
    id value;
    id binding;
    
    // Case 1
    formatString = @"'A'";
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:nil context:nil];
    XCTAssertEqualObjects(value, @"A");
    
    // Case 2
    formatString = @"A";
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:nil context:nil];
    XCTAssertNil(value);
    
    // Case 3
    formatString = @"1";
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:nil context:nil];
    XCTAssertEqualObjects(value, @1);
    
    // Case 4
    formatString = @"-1";
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:nil context:nil];
    XCTAssertEqualObjects(value, @(-1));
}

- (void)test_formatString_function_for_number_object_1 {
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
}

- (void)test_formatString_function_for_string_object_1 {
    NSString *formatString;
    NSDictionary *variables;
    NSExpression *mathExpression;
    id value;
    
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
}

- (void)test_formatString_function_for_array_object_1 {
    NSString *formatString;
    NSDictionary *variables;
    NSExpression *mathExpression;
    id value;
    
    // Case 1
    formatString = @"FUNCTION(a, 'elementAtIndex:', 0)";
    variables = @{
                  @"a": @[ @1, @2 ]
                  };
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @1);
}

- (void)test_formatString_function_for_dictionary_object_1 {
    NSString *formatString;
    NSDictionary *variables;
    NSExpression *mathExpression;
    id value;
    
    // Case 1
    formatString = @"FUNCTION(a, 'elementForKey:', b)";
    variables = @{
                  @"a": @{
                          @"key": @"value"
                          },
                  @"b": @"key"
                  };
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @"value");
}

- (void)test_formatString_function_for_key_path_1 {
    NSString *formatString;
    NSDictionary *variables;
    NSExpression *mathExpression;
    id value;
    
    // Case 1
    formatString = @"FUNCTION(a.b.c, 'characterStringAtIndex:', b[0][0])";
    variables = @{
                  @"a": @{
                          @"b": @{
                                  @"c": @"value"
                                  }
                          },
                  @"b": @[
                          @[ @0 ]
                          ]
                  };
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @"v");
    
    // Case 2
    formatString = @"FUNCTION(a.b.c, 'characterStringAtIndex:', b[c][0])";
    variables = @{
                  @"a": @{
                          @"b": @{
                                  @"c": @"value"
                                  }
                          },
                  @"b": @[
                          @[ @0 ]
                          ],
                  @"c": @0
                  };
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @"v");
    
    // Case 3
    formatString = @"FUNCTION(a.b, 'pow:', 2) + a.c + (a.d)[0] + 1";
    variables = @{
                  @"a": @{
                          @"b": @2,
                          @"c": @3,
                          @"d": @[
                                  @1
                                  ]
                          }
                  };
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @9);
    
    // Case 4
    formatString = @"FUNCTION(a.b, 'pow:', 2) + a.c + a.d[0] + 1";
    variables = @{
                  @"a": @{
                          @"b": @2,
                          @"c": @3,
                          @"d": @[
                                  @1
                                  ]
                          }
                  };
    mathExpression = [NSExpression expressionWithFormat:formatString];
    XCTAssertThrows([mathExpression expressionValueWithObject:variables context:nil]);
    
    // Case 5
    formatString = @"FUNCTION(a.b, 'pow:', 2) + a.c + a.d.0 + 1";
    variables = @{
                  @"a": @{
                          @"b": @2,
                          @"c": @3,
                          @"d": @[
                                  @1
                                  ]
                          }
                  };
    XCTAssertThrows([NSExpression expressionWithFormat:formatString]);
}

- (void)test_formatString_function_for_customized_object_1 {
    NSString *formatString;
    NSDictionary *variables;
    NSExpression *mathExpression;
    id value;
    
    Person *person = [[Person alloc] initWithName:@"Lily"];
    
    // Case 1
    formatString = @"FUNCTION(a, 'name')";
    variables = @{
                  @"a": person
                  };
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @"Lily");
    
    // Case 2
    formatString = @"FUNCTION(a, 'setName:', 'Lucy')";
    variables = @{
                  @"a": person
                  };
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @"Lucy");
    XCTAssertEqualObjects(person.name, @"Lucy");
    
    formatString = @"FUNCTION(a, 'name')";
    variables = @{
                  @"a": person
                  };
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @"Lucy");
}

- (void)test_formatString_function_for_customized_object_2 {
    NSString *formatString;
    NSDictionary *variables;
    NSExpression *mathExpression;
    id value;
    
    Person *person = [[Person alloc] initWithName:@"Lily"];
    Job *job = [[Job alloc] initWithName:@"Teacher"];
    
    // Case 1
    formatString = @"FUNCTION(a, 'setJob:', b)";
    variables = @{
                  @"a": person,
                  @"b": job
                  };
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects([(Job *)value name], @"Teacher");
}

- (void)test_formatString_function_exception_1 {
    NSString *formatString;
    NSDictionary *variables;
    NSExpression *mathExpression;
    id binding;
    id value;
    
    // Case 1
    formatString = @"'FUNCTION('a', 'uppercase')'";
    XCTAssertThrows([NSExpression expressionWithFormat:formatString]);
    
    // Case 2
    formatString = @"1 + FUNCTION('a', 'uppercase')";
    mathExpression = [NSExpression expressionWithFormat:formatString];
    XCTAssertThrows([mathExpression expressionValueWithObject:nil context:nil]);
    
    // Case 3
    formatString = @"FUNCTION('abc', func, a)";
    variables = @{
                  @"a": @1,
                  @"func": @"characterStringAtIndex:"
                  };
    XCTAssertThrows([NSExpression expressionWithFormat:formatString]);
    
    // Case 4: Crash
    /*
    binding = @{
                @"a": @"abcd"
                };
    formatString = @"FUNCTION(a, 'length')";
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:binding context:nil];
     */
}

- (void)test_formatString_function_nested_1 {
    NSString *formatString;
    NSDictionary *variables;
    NSExpression *mathExpression;
    id value;
    
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
    
    // Case 3
    formatString = @"FUNCTION(a, 'pow:', FUNCTION(b, 'factorial'))";
    variables = @{
                  @"a": @2,
                  @"b": @3
                  };
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @64);
    
    // Case 4
    formatString = @"FUNCTION(2, 'pow:', FUNCTION(FUNCTION(2, 'factorial'), 'factorial'))";
    mathExpression = [NSExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @4);
}


@end
