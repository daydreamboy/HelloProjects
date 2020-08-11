//
//  Tests_NSPredicate.m
//  Tests_NSPredicate
//
//  Created by wesley_chen on 2018/12/4.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Person.h"
#import "Name.h"
#import "NSNumber+NSPredicate.h"
#import "NSString+NSPredicate.h"

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

- (void)test_sytnax_attributes {
    NSPredicate *predicate;
    BOOL trueOrFalse;
    
    Person *person = [Person new];
    person.lastName = @"Smith";
    predicate = [NSPredicate predicateWithFormat:@"lastName like 'Smith'"];
    trueOrFalse = [predicate evaluateWithObject:person];
    XCTAssertTrue(trueOrFalse);
    
    person.lastName = @"Smmith";
    predicate = [NSPredicate predicateWithFormat:@"lastName like 'Smith'"];
    trueOrFalse = [predicate evaluateWithObject:person];
    XCTAssertFalse(trueOrFalse);
}

- (void)test_syntax_SELF {
    NSPredicate *predicate;
    BOOL trueOrFalse;
    NSArray *array;
    NSArray *output;
    
    // Case 1
    predicate = [NSPredicate predicateWithFormat:@"SELF like 'a'"];
    trueOrFalse = [predicate evaluateWithObject:@"a"];
    XCTAssertTrue(trueOrFalse);
    
    // Case 2
    // @see https://stackoverflow.com/a/18378811
    array = @[ @"123", @456, [NSArray array] ];
    predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@", [NSNumber class]];
    output = [array filteredArrayUsingPredicate:predicate];
    XCTAssertEqualObjects(output, @[ @456 ]);
    
    // Case 3
    // @see https://stackoverflow.com/a/8065935 (Deprecated. use isKindOfClass: instead)
    array = @[ @"123", @456, [NSArray array] ];
    predicate = [NSPredicate predicateWithFormat: @"class == %@", [@0 class]]; // Don't use [NSNumber class]
    output = [array filteredArrayUsingPredicate:predicate];
    XCTAssertEqualObjects(output, @[ @456 ]);
}

- (void)test_sytnax_string_contants {
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

- (void)test_syntax_dynamic_property_name {
    NSPredicate *predicate;
    
    NSString *attributeName = @"firstName";
    NSString *attributeValue = @"Adam";
    
    // Case 1
    predicate = [NSPredicate predicateWithFormat:@"%@ like %@", attributeName, attributeValue];
    XCTAssertEqualObjects(predicate.predicateFormat, @"\"firstName\" LIKE \"Adam\"");
    
    // Case 2
    predicate = [NSPredicate predicateWithFormat:@"%K like %@", attributeName, attributeValue];
    XCTAssertEqualObjects(predicate.predicateFormat, @"firstName LIKE \"Adam\"");
    
    // Case 3
    predicate = [NSPredicate predicateWithFormat:@"'%K' like '%@'", attributeName, attributeValue];
    XCTAssertNotEqualObjects(predicate.predicateFormat, @"'%K' like '%@'");
    XCTAssertEqualObjects(predicate.predicateFormat, @"\"%K\" LIKE \"%@\"");
    
    // Case 4
    predicate = [NSPredicate predicateWithFormat:@"\"%K\" like \"%@\"", attributeName, attributeValue];
    XCTAssertNotEqualObjects(predicate.predicateFormat, @"'%K' like '%@'");
    XCTAssertEqualObjects(predicate.predicateFormat, @"\"%K\" LIKE \"%@\"");
    
    // Case 5
    @try {
        // Error: %k will make an exception
        predicate = [NSPredicate predicateWithFormat:@"%k like %@", attributeName, attributeValue];
    }
    @catch (NSException *e) {
        NSLog(@"an exception occurred: %@", e);
        XCTAssertTrue(YES);
    }
}

- (void)test_syntax_wildcard_star {
    BOOL trueOrFalse;
    NSPredicate *predicate;
    NSString *formatString;
    NSString *evaluatedString;
    
    NSString *prefix = @"prefix";
    NSString *suffix = @"suffix";
    evaluatedString = @"prefixxxxxxsuffix";
    
    // Case 1
    predicate = [NSPredicate predicateWithFormat:@"SELF like[c] 'prefix*suffix'"];
    trueOrFalse = [predicate evaluateWithObject:evaluatedString];
    XCTAssertEqualObjects(predicate.predicateFormat, @"SELF LIKE[c] \"prefix*suffix\"");
    XCTAssertTrue(trueOrFalse);
    
    // Case 2
    predicate = [NSPredicate predicateWithFormat:@"SELF like[c] \"prefix*suffix\""];
    trueOrFalse = [predicate evaluateWithObject:evaluatedString];
    XCTAssertEqualObjects(predicate.predicateFormat, @"SELF LIKE[c] \"prefix*suffix\"");
    XCTAssertTrue(trueOrFalse);
    
    // Case 3
    predicate = [NSPredicate predicateWithFormat:@"SELF like[c] %@*%@", prefix, suffix];
    XCTAssertEqualObjects(predicate.predicateFormat, @"SELF LIKE[c] \"prefix\" * \"suffix\"");
    @try {
        trueOrFalse = [predicate evaluateWithObject:evaluatedString];
    }
    @catch (NSException *e) {
        NSLog(@"an exception occurred: %@", e);
    }
    
    // Case 4
    formatString = [[prefix stringByAppendingString:@"*"] stringByAppendingString:suffix];
    predicate = [NSPredicate predicateWithFormat:@"SELF like[c] %@", formatString];
    trueOrFalse = [predicate evaluateWithObject:evaluatedString];
    XCTAssertEqualObjects(predicate.predicateFormat, @"SELF LIKE[c] \"prefix*suffix\"");
    XCTAssertTrue(trueOrFalse);
}

- (void)test_syntax_wildcard_question_mark {
    BOOL trueOrFalse;
    NSPredicate *predicate;
    NSString *formatString;
    NSString *evaluatedString1;
    NSString *evaluatedString2;
    
    NSString *prefix = @"prefix";
    NSString *suffix = @"suffix";
    evaluatedString1 = @"prefixxsuffix";
    evaluatedString2 = @"prefixsuffix";
    
    // Case 1
    predicate = [NSPredicate predicateWithFormat:@"SELF like[c] 'prefix?suffix'"];
    XCTAssertEqualObjects(predicate.predicateFormat, @"SELF LIKE[c] \"prefix?suffix\"");
    
    trueOrFalse = [predicate evaluateWithObject:evaluatedString1];
    XCTAssertTrue(trueOrFalse);
    
    trueOrFalse = [predicate evaluateWithObject:evaluatedString2];
    XCTAssertFalse(trueOrFalse);
    
    // Case 2
    predicate = [NSPredicate predicateWithFormat:@"SELF like[c] \"prefix?suffix\""];
    trueOrFalse = [predicate evaluateWithObject:evaluatedString1];
    XCTAssertEqualObjects(predicate.predicateFormat, @"SELF LIKE[c] \"prefix?suffix\"");
    XCTAssertTrue(trueOrFalse);
    
    // Case 3
    @try {
        predicate = [NSPredicate predicateWithFormat:@"SELF like[c] %@?%@", prefix, suffix];
    }
    @catch (NSException *e) {
        NSLog(@"an exception occurred: %@", e);
    }
    
    // Case 4
    formatString = [[prefix stringByAppendingString:@"?"] stringByAppendingString:suffix];
    predicate = [NSPredicate predicateWithFormat:@"SELF like[c] %@", formatString];
    XCTAssertEqualObjects(predicate.predicateFormat, @"SELF LIKE[c] \"prefix?suffix\"");
    
    trueOrFalse = [predicate evaluateWithObject:evaluatedString1];
    XCTAssertTrue(trueOrFalse);
    
    trueOrFalse = [predicate evaluateWithObject:evaluatedString2];
    XCTAssertFalse(trueOrFalse);
}

- (void)test_syntax_boolean_values_YES_NO {
    BOOL boolValue;
    NSPredicate *predicate;
    BOOL trueOrFalse;
    
    Person *person = [Person new];
    
    // Case 1
    boolValue = YES;
    person.isMale = YES;
    predicate = [NSPredicate predicateWithFormat:@"isMale == %@", @(boolValue)];
    XCTAssertEqualObjects(predicate.predicateFormat, @"isMale == 1");
    trueOrFalse = [predicate evaluateWithObject:person];
    XCTAssertTrue(trueOrFalse);
    
    // Case 2
    boolValue = NO;
    person.isMale = YES;
    predicate = [NSPredicate predicateWithFormat:@"isMale == %@", @(boolValue)];
    XCTAssertEqualObjects(predicate.predicateFormat, @"isMale == 0");
    trueOrFalse = [predicate evaluateWithObject:person];
    XCTAssertFalse(trueOrFalse);
    
    // Case 3
    person.isMale = YES;
    predicate = [NSPredicate predicateWithFormat:@"isMale == YES"];
    XCTAssertEqualObjects(predicate.predicateFormat, @"isMale == 1");
    trueOrFalse = [predicate evaluateWithObject:person];
    XCTAssertTrue(trueOrFalse);
    
    // Case 4
    person.isMale = NO;
    predicate = [NSPredicate predicateWithFormat:@"isMale == NO"];
    XCTAssertEqualObjects(predicate.predicateFormat, @"isMale == 0");
    trueOrFalse = [predicate evaluateWithObject:person];
    XCTAssertTrue(trueOrFalse);
    
    // Case 5
    person.isMale = YES;
    predicate = [NSPredicate predicateWithFormat:@"isMale == yes"];
    XCTAssertEqualObjects(predicate.predicateFormat, @"isMale == 1");
    trueOrFalse = [predicate evaluateWithObject:person];
    XCTAssertTrue(trueOrFalse);
    
    // Case 6
    person.isMale = NO;
    predicate = [NSPredicate predicateWithFormat:@"isMale == no"];
    XCTAssertEqualObjects(predicate.predicateFormat, @"isMale == 0");
    trueOrFalse = [predicate evaluateWithObject:person];
    XCTAssertTrue(trueOrFalse);
}

- (void)test_syntax_boolean_values_true_false {
    NSPredicate *predicate;
    BOOL trueOrFalse;
    
    Person *person;
    person = [Person new];
    
    // Case 1
    person.isMale = NO;
    predicate = [NSPredicate predicateWithFormat:@"isMale == false"];
    XCTAssertEqualObjects(predicate.predicateFormat, @"isMale == 0");
    trueOrFalse = [predicate evaluateWithObject:person];
    XCTAssertTrue(trueOrFalse);
    
    // Case 2
    person.isMale = YES;
    predicate = [NSPredicate predicateWithFormat:@"isMale == true"];
    XCTAssertEqualObjects(predicate.predicateFormat, @"isMale == 1");
    trueOrFalse = [predicate evaluateWithObject:person];
    XCTAssertTrue(trueOrFalse);
    
    // Case 3
    person.isMale = NO;
    predicate = [NSPredicate predicateWithFormat:@"isMale == FALSE"];
    XCTAssertEqualObjects(predicate.predicateFormat, @"isMale == 0");
    trueOrFalse = [predicate evaluateWithObject:person];
    XCTAssertTrue(trueOrFalse);
    
    // Case 4
    person.isMale = YES;
    predicate = [NSPredicate predicateWithFormat:@"isMale == TRUE"];
    XCTAssertEqualObjects(predicate.predicateFormat, @"isMale == 1");
    trueOrFalse = [predicate evaluateWithObject:person];
    XCTAssertTrue(trueOrFalse);
}

- (void)test_syntax_KVC {
    NSPredicate *predicate;
    BOOL trueOrFalse;
    id binding;
    
    // Case 1
    binding = @{
                @"a": @[ @1, @2, @3 ]
                };
    predicate = [NSPredicate predicateWithFormat:@"a.@count == 3"];
    XCTAssertEqualObjects(predicate.predicateFormat, @"a.@count == 3");
    trueOrFalse = [predicate evaluateWithObject:binding];
    XCTAssertTrue(trueOrFalse);
    
    // Case 2
    Person *person = [Person new];
    person.isMale = YES;
    person.firstName = @"Lee";
    
    binding = @{
                @"a": person
                };
    predicate = [NSPredicate predicateWithFormat:@"a.isMale == YES"];
    XCTAssertEqualObjects(predicate.predicateFormat, @"a.isMale == 1");
    trueOrFalse = [predicate evaluateWithObject:binding];
    XCTAssertTrue(trueOrFalse);
    
    // Case 3
    predicate = [NSPredicate predicateWithFormat:@"a.firstName == 'Lee'"];
    XCTAssertEqualObjects(predicate.predicateFormat, @"a.firstName == \"Lee\"");
    trueOrFalse = [predicate evaluateWithObject:binding];
    XCTAssertTrue(trueOrFalse);

    // Case 4
    predicate = [NSPredicate predicateWithFormat:@"a.firstName.length == 3"];
    XCTAssertEqualObjects(predicate.predicateFormat, @"a.firstName.length == 3");
    trueOrFalse = [predicate evaluateWithObject:binding];
    XCTAssertTrue(trueOrFalse);
}

- (void)test_syntax_FUNCTION {
    NSPredicate *predicate;
    BOOL trueOrFalse;
    id binding;
    
    binding = @{
                @"a": @2
                };
    
    // Case 1
    predicate = [NSPredicate predicateWithFormat:@"FUNCTION(a, \"pow:\", 3) == 8"];
    XCTAssertEqualObjects(predicate.predicateFormat, @"FUNCTION(a, \"pow:\" , 3) == 8");
    trueOrFalse = [predicate evaluateWithObject:binding];
    XCTAssertTrue(trueOrFalse);
    
    // Case 2
    predicate = [NSPredicate predicateWithFormat:@"FUNCTION('a', 'uppercase') == 'A'"];
    XCTAssertEqualObjects(predicate.predicateFormat, @"FUNCTION(\"a\", \"uppercase\") == \"A\"");
    trueOrFalse = [predicate evaluateWithObject:binding];
    XCTAssertTrue(trueOrFalse);
}

- (void)test_syntax_aggregate_operations_array {
    NSPredicate *predicate;
    BOOL trueOrFalse;
    id binding;
    
    binding = @{
                @"a": @[ @1, @2, @3 ]
                };
    
    // Case 1
    predicate = [NSPredicate predicateWithFormat:@"a[SIZE] == 3"];
    XCTAssertEqualObjects(predicate.predicateFormat, @"a[SIZE] == 3");
    trueOrFalse = [predicate evaluateWithObject:binding];
    XCTAssertTrue(trueOrFalse);
    
    // Case 2
    predicate = [NSPredicate predicateWithFormat:@"a[FIRST] == 1"];
    XCTAssertEqualObjects(predicate.predicateFormat, @"a[FIRST] == 1");
    trueOrFalse = [predicate evaluateWithObject:binding];
    XCTAssertTrue(trueOrFalse);
    
    // Case 3
    predicate = [NSPredicate predicateWithFormat:@"a[LAST] == 3"];
    XCTAssertEqualObjects(predicate.predicateFormat, @"a[LAST] == 3");
    trueOrFalse = [predicate evaluateWithObject:binding];
    XCTAssertTrue(trueOrFalse);
    
    // Case 4
    predicate = [NSPredicate predicateWithFormat:@"a[1] == 2"];
    XCTAssertEqualObjects(predicate.predicateFormat, @"a[1] == 2");
    trueOrFalse = [predicate evaluateWithObject:binding];
    XCTAssertTrue(trueOrFalse);
}

- (void)test_syntax_aggregate_operations_array_IN {
    Name *name1 = [Name nameWithPatterns:@[ @"abc", @"c" ]];
    Name *name2 = [Name nameWithPatterns:@[ @"bc", @"d" ]];
    NSString *searchText;
    NSArray *output;
    NSPredicate *predicate;
    
    NSArray<Name *> *names = @[ name1, name2 ];
    
    // Case 1
    searchText = @"bc";
    predicate = [NSPredicate predicateWithFormat:@"%@ IN self.patterns", searchText];
    output = [names filteredArrayUsingPredicate:predicate];
    XCTAssertTrue(output.count == 1);
    NSLog(@"%@", output);
    
    // Case 2
    searchText = @"c";
    predicate = [NSPredicate predicateWithFormat:@"%@ IN self.patterns", searchText];
    output = [names filteredArrayUsingPredicate:predicate];
    XCTAssertTrue(output.count == 1);
    NSLog(@"%@", output);
    
    // Case 3
    searchText = @"e";
    predicate = [NSPredicate predicateWithFormat:@"%@ IN self.patterns", searchText];
    output = [names filteredArrayUsingPredicate:predicate];
    XCTAssertTrue(output.count == 0);
    NSLog(@"%@", output);
    
    // Case 4
    searchText = @"e";
    predicate = [NSPredicate predicateWithFormat:@"%@ IN self.patterns2", searchText];
    output = [names filteredArrayUsingPredicate:predicate];
    XCTAssertTrue(output.count == 0);
    NSLog(@"%@", output);
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

- (void)test_substitutionVariables {
    NSPredicate *predicate;
    BOOL trueOrFalse;
    id binding;
    
    // Case 1
    predicate = [NSPredicate predicateWithFormat:@"$a == 1"];
    XCTAssertEqualObjects(predicate.predicateFormat, @"$a == 1");
    trueOrFalse = [predicate evaluateWithObject:nil substitutionVariables:@{ @"a": @2 }];
    XCTAssertFalse(trueOrFalse);
    
    // Case 2
    predicate = [NSPredicate predicateWithFormat:@"$a == 1"];
    XCTAssertEqualObjects(predicate.predicateFormat, @"$a == 1");
    trueOrFalse = [predicate evaluateWithObject:nil substitutionVariables:@{ @"a": @1 }];
    XCTAssertTrue(trueOrFalse);
    
    // Case 3
    binding = @{
                @"a": @1
                };
    predicate = [NSPredicate predicateWithFormat:@"$a == 1"];
    predicate = [predicate predicateWithSubstitutionVariables:@{ @"a": @"a" }];
    XCTAssertEqualObjects(predicate.predicateFormat, @"\"a\" == 1");
    trueOrFalse = [predicate evaluateWithObject:binding substitutionVariables:@{ @"a": @"a" }];
    XCTAssertFalse(trueOrFalse);
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

- (void)test_predicateWithBlock {
    NSArray *array;
    NSArray *output;
    NSArray *expected;
    
    // Case 1
    // @see https://stackoverflow.com/a/18377992
    array = @[
              @1,
              @"a",
              [NSDate date],
              @{},
              @"b",
              ];
    output = [array filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject isKindOfClass:[NSString class]];
    }]];
    expected = @[ @"a", @"b" ];
    XCTAssertEqualObjects(output, expected);
}

@end
