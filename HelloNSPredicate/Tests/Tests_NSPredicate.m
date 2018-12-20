//
//  Tests_NSPredicate.m
//  Tests_NSPredicate
//
//  Created by wesley_chen on 2018/12/4.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Person.h"

// BOOL to string
#define STR_OF_BOOL(yesOrNo)     ((yesOrNo) ? @"YES" : @"NO")

@interface Tests_NSPredicate : XCTestCase

@end

@implementation Tests_NSPredicate

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Format String Syntax

- (void)test_string_contants {
    NSArray<Person *> *people = [Person people];
    NSArray<Person *> *output;
    NSPredicate *predicate;
    
    // Case 1: single quotes
    predicate = [NSPredicate predicateWithFormat:@"lastName like 'Smith'"];
    output = [people filteredArrayUsingPredicate:predicate];
    for (Person *p in output) {
        XCTAssertTrue([p.lastName isEqualToString:@"Smith"]);
    }
    
    // Case 2: double quotes
    predicate = [NSPredicate predicateWithFormat:@"lastName LIKE \"Smith\""];
    output = [people filteredArrayUsingPredicate:predicate];
    for (Person *p in output) {
        XCTAssertTrue([p.lastName isEqualToString:@"Smith"]);
    }
    
    // Case 3: auto double quotes
    predicate = [NSPredicate predicateWithFormat:@"lastName LIKE %@", @"Smith"];
    output = [people filteredArrayUsingPredicate:predicate];
    for (Person *p in output) {
        XCTAssertTrue([p.lastName isEqualToString:@"Smith"]);
    }
    
    // Abnormal Case 1:
    predicate = [NSPredicate predicateWithFormat:@"lastName LIKE '%@'", @"Smith"];
    output = [people filteredArrayUsingPredicate:predicate];
    XCTAssertTrue(output.count == 0);
    
    // Abnormal Case 2:
    predicate = [NSPredicate predicateWithFormat:@"lastName LIKE \"%@\"", @"Smith"];
    output = [people filteredArrayUsingPredicate:predicate];
    XCTAssertTrue(output.count == 0);
}

- (void)test_substitution {
    NSArray<Person *> *people = [Person people];
    NSArray<Person *> *output;
    
    NSString *variable = @"age";
    
    // Note: @see http://nshipster.com/nspredicate/
    // %K is a substitution for a key path (like attribute name)
    // %@ is a substitution for a object value, e.g. NSString, NSNumber (like attribute value)
    // $VARIABLE_NAME is another substitution for predicateWithSubstitutionVariables: method
    
    // case 1: %K and %@
    NSPredicate *predicateAgeIs33 = [NSPredicate predicateWithFormat:@"%K == %@", variable, @33];
    output = [people filteredArrayUsingPredicate:predicateAgeIs33];
    for (Person *p in output) {
        XCTAssertTrue([p.age isEqualToNumber:@33]);
    }
    
    // case 2: %K and %@
    variable = @"lastName";
    NSPredicate *predicateLastNameIsSmith = [NSPredicate predicateWithFormat:@"%K == %@", variable, @"Smith"];
    output = [people filteredArrayUsingPredicate:predicateLastNameIsSmith];
    for (Person *p in output) {
        XCTAssertTrue([p.lastName isEqualToString:@"Smith"]);
    }
    
    NSPredicate *predicateLastNameIsSmith2 = [NSPredicate predicateWithFormat:@"%@ == %@", variable, @"Smith"];
    output = [people filteredArrayUsingPredicate:predicateLastNameIsSmith2];
    for (Person *p in output) {
        XCTAssertTrue([p.lastName isEqualToString:@"Smith"]);
    }
    
    // case 3: use literal attribute name instead of %K
    NSPredicate *predicateFirstNameIsSmith = [NSPredicate predicateWithFormat:@"firstName == %@", @"Smith"];
    output = [people filteredArrayUsingPredicate:predicateFirstNameIsSmith];
    for (Person *p in output) {
        XCTAssertTrue([p.firstName isEqualToString:@"Smith"]);
    }
    
    // case 4: use $VARIABLE_NAME
    // Note: BEGINSWITH is case and diacritic sensitive by default
    //       BEGINSWITH[cd] - c for case insensitive
    //       BEGINSWITH[cd] - d for diacritic insensitive
    NSString *format = @"(firstName BEGINSWITH[cd] $letter) OR (lastName BEGINSWITH[cd] $letter)";
    NSPredicate *predicateNamesBeginningWithLetter = [NSPredicate predicateWithFormat:format];
    // replace $letter with A
    NSPredicate *finalPredicate = [predicateNamesBeginningWithLetter predicateWithSubstitutionVariables:@{@"letter": @"A"}];
    output = [people filteredArrayUsingPredicate:finalPredicate];
    for (Person *p in output) {
        XCTAssertTrue([p.firstName hasPrefix:@"A"] || [p.lastName hasPrefix:@"A"]);
    }
}

- (void)test_Basic_Comparisons {
    NSPredicate *predicate;
    BOOL trueOrFalse;
    
    predicate = [NSPredicate predicateWithFormat:@"1 == 1"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"1 = 1"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"1 == 1"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"2 >= 1"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"2 => 1"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"1 <= 2"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"1 =< 2"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"2 > 1"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"1 < 2"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"2 != 1"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"1 <> 2"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    // bitwise operator
    // <<
    predicate = [NSPredicate predicateWithFormat:@"1 << 3 > 1"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"1 << 3 == 8"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    // >>
    predicate = [NSPredicate predicateWithFormat:@"8 >> 2 == 2"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"8 >> 1 == 4"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    // &
    predicate = [NSPredicate predicateWithFormat:@"1 & 0 == 0"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"2 & 1 == 0"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    // |
    predicate = [NSPredicate predicateWithFormat:@"1 | 0 == 1"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"2 | 1 == 3"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    // ^
    predicate = [NSPredicate predicateWithFormat:@"1 ^ 0 == 1"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"1 ^ 1 == 0"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"2 ^ 1 == 3"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    // not support ~
    predicate = [NSPredicate predicateWithFormat:@"~(1) == 0"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"~(0) == 1"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
}

- (void)test_Compound_Predicates {
    NSPredicate *predicate;
    BOOL trueOrFalse;
    
    predicate = [NSPredicate predicateWithFormat:@"(1 < 0) || (1 > 0)"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"(1 < 0) OR (1 > 0)"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"(1 < 0) && (1 > 0)"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertFalse(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"(1 < 0) AND (1 > 0)"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertFalse(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"!(1 < 0)"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"NOT(1 < 0)"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
}

- (void)test_Boolean_Value_Predicates {
    NSPredicate *predicate;
    BOOL trueOrFalse;
    
    predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"FALSEPREDICATE"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertFalse(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"(1 < 0) || TRUEPREDICATE"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"(1 < 0) || FALSEPREDICATE"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertFalse(trueOrFalse);
}

- (void)test_String_Comparisons {
    NSPredicate *predicate;
    BOOL trueOrFalse;
    
    // BEGINSWITH
    predicate = [NSPredicate predicateWithFormat:@"'hello' BEGINSWITH 'he'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"'Hello' BEGINSWITH 'he'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertFalse(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"'Hello' BEGINSWITH[cd] 'he'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    // ENDSWITH
    predicate = [NSPredicate predicateWithFormat:@"'hello' ENDSWITH 'llo'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"'HELLO' ENDSWITH 'llo'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertFalse(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"'HELLO' ENDSWITH[cd] 'llo'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    // CONTAINS
    predicate = [NSPredicate predicateWithFormat:@"'hello' CONTAINS 'll'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"'hello' CONTAINS 'LL'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertFalse(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"'HELLO' CONTAINS[cd] 'll'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    // LIKE (? *)
    predicate = [NSPredicate predicateWithFormat:@"'hello' LIKE 'hello'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"'HELLO' LIKE 'hello'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertFalse(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"'HELLO' LIKE[cd] 'hello'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"'hello' LIKE 'hel*o'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);

    predicate = [NSPredicate predicateWithFormat:@"'heo' LIKE 'hel*o'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertFalse(trueOrFalse);

    predicate = [NSPredicate predicateWithFormat:@"'helllo' LIKE 'hel*o'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"'helo' LIKE 'hel?o'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertFalse(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"'hello' LIKE 'hel?o'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"'helllo' LIKE 'hel?o'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertFalse(trueOrFalse);
    
    // MATCHES
    predicate = [NSPredicate predicateWithFormat:@"'hello' MATCHES 'hel{2}o'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"'heo' MATCHES 'he[l]*o'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    // == (not support ? *)
    predicate = [NSPredicate predicateWithFormat:@"'hello' == 'hello'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"'helllo' == 'hello'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertFalse(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"'helllo' == 'hel*o'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertFalse(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"'helo' == 'hel?o'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertFalse(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"'hello' == 'hel?o'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertFalse(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"'helllo' == 'hel?o'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertFalse(trueOrFalse);
    
    // != (not support ? *)
    predicate = [NSPredicate predicateWithFormat:@"'helllo' != 'hello'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"'helllo' != 'hel*o'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    // =
    predicate = [NSPredicate predicateWithFormat:@"'hello' = 'hello'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"'helllo' = 'hello'"];
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertFalse(trueOrFalse);
}

- (void)test {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"$a == 1"];
    BOOL trueOrFalse = [predicate evaluateWithObject:nil substitutionVariables:@{ @"a": @2 }];
    NSLog(@"%@", STR_OF_BOOL(trueOrFalse));
}

- (void)test_exception {
    NSPredicate *predicate;
    BOOL trueOrFalse;
    
    // Case 1
    predicate = [NSPredicate predicateWithFormat:@"1"]; // Exception
    trueOrFalse = [predicate evaluateWithObject:nil substitutionVariables:@{ @"a": @2 }];
    NSLog(@"%@", STR_OF_BOOL(trueOrFalse));
    
    // Case 2
    predicate = [NSPredicate predicateWithFormat:@"0 || 1"]; // Exception
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    NSLog(@"%@", STR_OF_BOOL(trueOrFalse));
    
    predicate = [NSPredicate predicateWithFormat:@"TRUE"]; // Exception
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertTrue(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"FALSE"]; // Exception
    trueOrFalse = [predicate evaluateWithObject:nil];
    XCTAssertFalse(trueOrFalse);
    
    predicate = [NSPredicate predicateWithFormat:@"$a.$b > 1"];
    trueOrFalse = [predicate evaluateWithObject:nil substitutionVariables:@{ @"a": @[ @2 ], @"b": @0 }]; // Exception
    XCTAssertTrue(trueOrFalse);
    NSLog(@"%@", STR_OF_BOOL(trueOrFalse));
    
    predicate = [NSPredicate predicateWithFormat:@"$a.$b > 1"];
    trueOrFalse = [predicate evaluateWithObject:nil substitutionVariables:@{ @"a": @[ @2 ], @"b": @"0" }]; // Exception
    XCTAssertTrue(trueOrFalse);
    NSLog(@"%@", STR_OF_BOOL(trueOrFalse));
}

#pragma mark -

- (void)test_evaluateWithObject_substitutionVariables {
    NSPredicate *predicate;
    BOOL trueOrFalse;
    
    predicate = [NSPredicate predicateWithFormat:@"$a > 1"];
    trueOrFalse = [predicate evaluateWithObject:nil substitutionVariables:@{ @"a": @1 }];
    XCTAssertFalse(trueOrFalse);
    NSLog(@"%@", STR_OF_BOOL(trueOrFalse));
    
    predicate = [NSPredicate predicateWithFormat:@"$a > 1"];
    trueOrFalse = [predicate evaluateWithObject:nil substitutionVariables:@{ @"a": @2 }];
    XCTAssertTrue(trueOrFalse);
    NSLog(@"%@", STR_OF_BOOL(trueOrFalse));
    
    predicate = [NSPredicate predicateWithFormat:@"$a[0] > 1"];
    trueOrFalse = [predicate evaluateWithObject:nil substitutionVariables:@{ @"a": @[ @1 ] }];
    XCTAssertFalse(trueOrFalse);
    NSLog(@"%@", STR_OF_BOOL(trueOrFalse));
    
    predicate = [NSPredicate predicateWithFormat:@"$a[0] > 1"];
    trueOrFalse = [predicate evaluateWithObject:nil substitutionVariables:@{ @"a": @[ @2 ] }];
    XCTAssertTrue(trueOrFalse);
    NSLog(@"%@", STR_OF_BOOL(trueOrFalse));
    
    predicate = [NSPredicate predicateWithFormat:@"$a[$b] > 1"];
    trueOrFalse = [predicate evaluateWithObject:nil substitutionVariables:@{ @"a": @[ @2 ], @"b": @0 }];
    XCTAssertTrue(trueOrFalse);
    NSLog(@"%@", STR_OF_BOOL(trueOrFalse));
    
    predicate = [NSPredicate predicateWithFormat:@"$a[$b] == 'ABC'"];
    trueOrFalse = [predicate evaluateWithObject:nil substitutionVariables:@{ @"a": @{ @"a": @"ABC" }, @"b": @"a" }];
    XCTAssertTrue(trueOrFalse);
    NSLog(@"%@", STR_OF_BOOL(trueOrFalse));
    
    predicate = [NSPredicate predicateWithFormat:@"$a.$b == 'ABC'"];
    trueOrFalse = [predicate evaluateWithObject:nil substitutionVariables:@{ @"a": @{ @"a": @"ABC" }, @"b": @"a" }];
    XCTAssertTrue(trueOrFalse);
    NSLog(@"%@", STR_OF_BOOL(trueOrFalse));
    
    predicate = [NSPredicate predicateWithFormat:@"$a + 1  > 1"];
    trueOrFalse = [predicate evaluateWithObject:nil substitutionVariables:@{ @"a": @1 }];
    XCTAssertTrue(trueOrFalse);
    NSLog(@"%@", STR_OF_BOOL(trueOrFalse));
    
    predicate = [NSPredicate predicateWithFormat:@"$a - 1  < 1"];
    trueOrFalse = [predicate evaluateWithObject:nil substitutionVariables:@{ @"a": @1 }];
    XCTAssertTrue(trueOrFalse);
    NSLog(@"%@", STR_OF_BOOL(trueOrFalse));
    
    predicate = [NSPredicate predicateWithFormat:@"$a / 2.5 > 1"];
    trueOrFalse = [predicate evaluateWithObject:nil substitutionVariables:@{ @"a": @5 }];
    XCTAssertTrue(trueOrFalse);
    NSLog(@"%@", STR_OF_BOOL(trueOrFalse));
    
    predicate = [NSPredicate predicateWithFormat:@"$a / 2.5 == 2"];
    trueOrFalse = [predicate evaluateWithObject:nil substitutionVariables:@{ @"a": @5 }];
    XCTAssertTrue(trueOrFalse);
    NSLog(@"%@", STR_OF_BOOL(trueOrFalse));

    predicate = [NSPredicate predicateWithFormat:@"$a / 2.5 == 2.0"];
    trueOrFalse = [predicate evaluateWithObject:nil substitutionVariables:@{ @"a": @5 }];
    XCTAssertTrue(trueOrFalse);
    NSLog(@"%@", STR_OF_BOOL(trueOrFalse));
    
    predicate = [NSPredicate predicateWithFormat:@"$a * 3 == 6.0"];
    trueOrFalse = [predicate evaluateWithObject:nil substitutionVariables:@{ @"a": @2 }];
    XCTAssertTrue(trueOrFalse);
    NSLog(@"%@", STR_OF_BOOL(trueOrFalse));
    
    predicate = [NSPredicate predicateWithFormat:@"$a ** 3 == 8.0"];
    trueOrFalse = [predicate evaluateWithObject:nil substitutionVariables:@{ @"a": @2 }];
    XCTAssertTrue(trueOrFalse);
    NSLog(@"%@", STR_OF_BOOL(trueOrFalse));
    
    predicate = [NSPredicate predicateWithFormat:@"($a + 1) ** 3 == 8.0"];
    trueOrFalse = [predicate evaluateWithObject:nil substitutionVariables:@{ @"a": @1 }];
    XCTAssertTrue(trueOrFalse);
    NSLog(@"%@", STR_OF_BOOL(trueOrFalse));

    Person *p = [Person new];
    p.firstName = @"Lily";
    predicate = [NSPredicate predicateWithFormat:@"$a[$b].firstName == 'Lily'"];
    trueOrFalse = [predicate evaluateWithObject:nil substitutionVariables:@{ @"a": @{ @"a": p }, @"b": @"a" }];
    XCTAssertTrue(trueOrFalse);
    NSLog(@"%@", STR_OF_BOOL(trueOrFalse));
}

@end
