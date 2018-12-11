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

- (void)test {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"$a == 1"];
    BOOL trueOrFalse = [predicate evaluateWithObject:nil substitutionVariables:@{ @"a": @2 }];
    NSLog(@"%@", STR_OF_BOOL(trueOrFalse));
}

- (void)test2 {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"1"]; // Exception
    BOOL trueOrFalse = [predicate evaluateWithObject:nil substitutionVariables:@{ @"a": @2 }];
    NSLog(@"%@", STR_OF_BOOL(trueOrFalse));
}

- (void)test3 {
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
    
    Person *p = [Person new];
    p.firstName = @"Lily";
    predicate = [NSPredicate predicateWithFormat:@"$a[$b].firstName == 'Lily'"];
    trueOrFalse = [predicate evaluateWithObject:nil substitutionVariables:@{ @"a": @{ @"a": p }, @"b": @"a" }];
    XCTAssertTrue(trueOrFalse);
    NSLog(@"%@", STR_OF_BOOL(trueOrFalse));
}

@end
