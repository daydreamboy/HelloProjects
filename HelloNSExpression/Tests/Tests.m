//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2018/11/22.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCExpression.h"
#import "WCExpression_Testing.h"
#import "Person.h"

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

- (void)test_expressionWithFormat {
    NSString *formatString;
    WCExpression *mathExpression;
    id expected;
    id value;
    
    // Case 1
    formatString = @"1 + 1";
    mathExpression = [WCExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:nil context:nil];
    XCTAssertEqualObjects(value, @2);
    
    // Case 2
    formatString = @"%@ + %@";
    mathExpression = [WCExpression expressionWithFormat:formatString, @1, @1];
    value = [mathExpression expressionValueWithObject:nil context:nil];
    XCTAssertEqualObjects(value, @2);
    XCTAssertEqualObjects(mathExpression.formatString, @"1 + 1");
    
    // Case 3
    formatString = @"%@ + %@";
    mathExpression = [WCExpression expressionWithFormat:formatString, @"1", @"1"];
    @try {
        value = [mathExpression expressionValueWithObject:nil context:nil];
    }
    @catch (NSException *e) {
        XCTAssertTrue(YES);
    }
    XCTAssertEqualObjects(mathExpression.formatString, @"\"1\" + \"1\"");
    
    @try {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:formatString, @"1", @"1"];
        XCTAssertEqualObjects(predicate.predicateFormat, @"\"1\" + \"1\"");
    }
    @catch (NSException *e) {
        XCTAssertTrue(YES);
    }
    
    // Case 4
    formatString = @"2 * (1 + 1)";
    mathExpression = [WCExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:nil context:nil];
    XCTAssertEqualObjects(value, @4);
}

- (void)test_formatString_function_for_number_object_1 {
    NSString *formatString;
    NSDictionary *variables;
    WCExpression *mathExpression;
    id value;
    
    // Case 1
    formatString = @"FUNCTION(3, 'factorial')";
    mathExpression = [WCExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:nil context:nil];
    XCTAssertEqualObjects(value, @6);
    
    // Case 2
    formatString = @"FUNCTION(a, 'factorial')";
    variables = @{
                  @"a": @3
                  };
    mathExpression = [WCExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @6);

    // Case 2
    formatString = @"1 + FUNCTION(a, 'factorial')";
    variables = @{
                  @"a": @3
                  };
    mathExpression = [WCExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @7);
}

- (void)test_formatString_function_for_number_object_2 {
    NSString *formatString;
    NSDictionary *variables;
    WCExpression *mathExpression;
    id value;
    
    // Test for categoryMethodPrefixTable
    // Case 1
    formatString = @"FUNCTION(3, 'factorial')";
    mathExpression = [WCExpression expressionWithFormat:formatString];
    [mathExpression.categoryMethodPrefixTable setObject:@"exp_" forKey:NSStringFromClass([NSNumber class])];
    value = [mathExpression expressionValueWithObject:nil context:nil];
    XCTAssertEqualObjects(value, @6);
    
    // Case 2
    formatString = @"FUNCTION(a, 'factorial')";
    variables = @{
                  @"a": @3
                  };
    mathExpression = [WCExpression expressionWithFormat:formatString];
    [mathExpression.categoryMethodPrefixTable setObject:@"exp_" forKey:NSStringFromClass([NSNumber class])];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @6);
    
    // Case 3
    formatString = @"1 + FUNCTION(a, 'factorial')";
    variables = @{
                  @"a": @3
                  };
    mathExpression = [WCExpression expressionWithFormat:formatString];
    [mathExpression.categoryMethodPrefixTable setObject:@"exp_" forKey:NSStringFromClass([NSNumber class])];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @7);
}

- (void)test_formatString_function_for_number_object_3 {
    NSString *formatString;
    NSDictionary *variables;
    WCExpression *mathExpression;
    id value;
    
    // Test for categoryMethodPrefixTable
    // Case 1
    formatString = @"FUNCTION(3, 'my_factorial')";
    mathExpression = [WCExpression expressionWithFormat:formatString];
    [mathExpression.categoryMethodPrefixTable setObject:@"exp_" forKey:NSStringFromClass([NSNumber class])];
    [mathExpression.functionNameMapping setObject:@"factorial" forKey:@"my_factorial"];
    value = [mathExpression expressionValueWithObject:nil context:nil];
    XCTAssertEqualObjects(value, @6);

    // Case 2
    formatString = @"FUNCTION(a, 'factorial')";
    variables = @{
                  @"a": @3
                  };
    mathExpression = [WCExpression expressionWithFormat:formatString];
    [mathExpression.categoryMethodPrefixTable setObject:@"exp_" forKey:NSStringFromClass([NSNumber class])];
    [mathExpression.functionNameMapping setObject:@"factorial" forKey:@"my_factorial"];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @6);

    // Case 3
    formatString = @"1 + FUNCTION(a, 'my_pow:', 2)";
    variables = @{
                  @"a": @3
                  };
    mathExpression = [WCExpression expressionWithFormat:formatString];
    [mathExpression.categoryMethodPrefixTable setObject:@"exp_" forKey:NSStringFromClass([NSNumber class])];
    [mathExpression.functionNameMapping setObject:@"pow:" forKey:@"my_pow:"];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @10);
    
    // Case 4: function missing arguments
    formatString = @"1 + FUNCTION(a, 'my_pow:')";
    variables = @{
                  @"a": @3
                  };
    mathExpression = [WCExpression expressionWithFormat:formatString];
    [mathExpression.categoryMethodPrefixTable setObject:@"exp_" forKey:NSStringFromClass([NSNumber class])];
    [mathExpression.functionNameMapping setObject:@"pow:" forKey:@"my_pow:"];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertNil(value);
}

- (void)test_formatString_function_for_string_object_1 {
    NSString *formatString;
    NSDictionary *variables;
    WCExpression *mathExpression;
    id value;
    
    // Case 1
    formatString = @"FUNCTION(a, 'uppercase')";
    mathExpression = [WCExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:nil context:nil];
    XCTAssertNil(value);
    
    // Case 4
    formatString = @"FUNCTION(a, 'uppercase')";
    variables = @{
                  @"a": @"a"
                  };
    mathExpression = [WCExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @"A");
    
    // Case 5
    formatString = @"FUNCTION('a', 'uppercase')";
    mathExpression = [WCExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:nil context:nil];
    XCTAssertEqualObjects(value, @"A");
    
    // Case 6
    formatString = @"FUNCTION('a', 'uppercaseString')";
    mathExpression = [WCExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:nil context:nil];
    XCTAssertEqualObjects(value, @"A");
    
    // Case 7
    formatString = @"FUNCTION('abc', 'characterStringAtIndex:', a)";
    variables = @{
                  @"a": @1
                  };
    mathExpression = [WCExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @"b");
}


- (void)test_formatString_function_for_array_object_1 {
    NSString *formatString;
    NSDictionary *variables;
    WCExpression *mathExpression;
    id value;
    
    // Case 1
    formatString = @"FUNCTION(a, 'elementAtIndex:', 0)";
    variables = @{
                  @"a": @[ @1, @2 ]
                  };
    mathExpression = [WCExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @1);
}

- (void)test_formatString_function_for_dictionary_object_1 {
    NSString *formatString;
    NSDictionary *variables;
    WCExpression *mathExpression;
    id value;
    
    // Case 1
    formatString = @"FUNCTION(a, 'elementForKey:', b)";
    variables = @{
                  @"a": @{
                          @"key": @"value"
                          },
                  @"b": @"key"
                  };
    mathExpression = [WCExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @"value");
}

- (void)test_formatString_function_for_customized_object_1 {
    NSString *formatString;
    NSDictionary *variables;
    WCExpression *mathExpression;
    id value;
    
    Person *person = [[Person alloc] initWithName:@"Lily"];
    
    // Case 1
    formatString = @"FUNCTION(a, 'name')";
    variables = @{
                  @"a": person
                  };
    mathExpression = [WCExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @"Lily");
    
    // Case 2
    formatString = @"FUNCTION(a, 'setName:', 'Lucy')";
    variables = @{
                  @"a": person
                  };
    mathExpression = [WCExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @"Lucy");
    XCTAssertEqualObjects(person.name, @"Lucy");
    
    formatString = @"FUNCTION(a, 'name')";
    variables = @{
                  @"a": person
                  };
    mathExpression = [WCExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects(value, @"Lucy");
}

- (void)test_formatString_function_for_customized_object_2 {
    NSString *formatString;
    NSDictionary *variables;
    WCExpression *mathExpression;
    id value;
    
    Person *person = [[Person alloc] initWithName:@"Lily"];
    Job *job = [[Job alloc] initWithName:@"Teacher"];
    
    // Case 1
    formatString = @"FUNCTION(a, 'setJob:', b)";
    variables = @{
                  @"a": person,
                  @"b": job
                  };
    mathExpression = [WCExpression expressionWithFormat:formatString];
    value = [mathExpression expressionValueWithObject:variables context:nil];
    XCTAssertEqualObjects([(Job *)value name], @"Teacher");
}

#pragma mark - Internal Methods Testing

- (void)test_tokenizeWithFormatString {
    NSString *string;
    NSArray *output;
    NSArray *expected;
    WCExpression *expression;
    
    string = @"1 + FUNCTION(2, 'pow:', FUNCTION(FUNCTION(2, 'factorial'), 'factorial'))";
    expression = [WCExpression expressionWithFormat:string];
    output = [expression tokenizeWithFormatString:expression.formatString];
    expected = @[@1,
                 @"+",
                 @"FUNCTION",
                 @"(",
                 @2,
                 @",",
                 @"\"pow:\"",
                 @",",
                 @"FUNCTION",
                 @"(",
                 @"FUNCTION",
                 @"(",
                 @2,
                 @",",
                 @"\"factorial\"",
                 @")",
                 @",",
                 @"\"factorial\"",
                 @")",
                 @")"];
    XCTAssertEqualObjects(output, expected);
}


@end
