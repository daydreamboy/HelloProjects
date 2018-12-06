//
//  NSComparisonPredicateViewController.m
//  HelloNSPredicate
//
//  Created by wesley_chen on 09/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "NSComparisonPredicateViewController.h"
#import "Person.h"

@interface NSComparisonPredicateViewController ()

@end

@implementation NSComparisonPredicateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *people = [Person people];

/*
 // Flags(s) that can be passed to the factory to indicate that a operator operating on strings should do so in a case insensitive fashion.
 typedef NS_OPTIONS(NSUInteger, NSComparisonPredicateOptions) {
 NSCaseInsensitivePredicateOption = 0x01,
 NSDiacriticInsensitivePredicateOption = 0x02,
 NSNormalizedPredicateOption NS_ENUM_AVAILABLE(10_6, 4_0) = 0x04, // Indicate that the strings to be compared have been preprocessed; this supersedes other options and is intended as a performance optimization option
};

// Describes how the operator is modified: can be direct, ALL, or ANY
typedef NS_ENUM(NSUInteger, NSComparisonPredicateModifier) {
    NSDirectPredicateModifier = 0, // Do a direct comparison
    NSAllPredicateModifier, // ALL toMany.x = y
    NSAnyPredicateModifier // ANY toMany.x = y
};


// Type basic set of operators defined. Most are obvious; NSCustomSelectorPredicateOperatorType allows a developer to create an operator which uses the custom selector specified in the constructor to do the evaluation.
typedef NS_ENUM(NSUInteger, NSPredicateOperatorType) {
    NSLessThanPredicateOperatorType = 0, // compare: returns NSOrderedAscending
    NSLessThanOrEqualToPredicateOperatorType, // compare: returns NSOrderedAscending || NSOrderedSame
    NSGreaterThanPredicateOperatorType, // compare: returns NSOrderedDescending
    NSGreaterThanOrEqualToPredicateOperatorType, // compare: returns NSOrderedDescending || NSOrderedSame
    NSEqualToPredicateOperatorType, // isEqual: returns true
    NSNotEqualToPredicateOperatorType, // isEqual: returns false
    NSMatchesPredicateOperatorType,
    NSLikePredicateOperatorType,
    NSBeginsWithPredicateOperatorType,
    NSEndsWithPredicateOperatorType,
    NSInPredicateOperatorType, // rhs contains lhs returns true
    NSCustomSelectorPredicateOperatorType,
    NSContainsPredicateOperatorType NS_ENUM_AVAILABLE(10_5, 3_0) = 99, // lhs contains rhs returns true
    NSBetweenPredicateOperatorType NS_ENUM_AVAILABLE(10_5, 3_0)
};
 */
    
    
    // @see http://nshipster.com/nspredicate/
    // @see http://nshipster.com/nsexpression/
    // Note:
    // NSLessThanPredicateOperatorType
    // NSLikePredicateOperatorType
    
    // @see https://stackoverflow.com/a/10860972
    // @see https://stackoverflow.com/questions/5430649/dynamically-creating-a-predicate-with-a-varying-number-of-attributes-and-values
    NSExpression *left;
    NSExpression *right;
    NSComparisonPredicate *predicate;

    // case 1: age <= 30
    left = [NSExpression expressionForKeyPath:@"age"];
    right = [NSExpression expressionForConstantValue:@30];
    predicate = [NSComparisonPredicate predicateWithLeftExpression:left rightExpression:right modifier:NSDirectPredicateModifier type:NSLessThanPredicateOperatorType options:kNilOptions];
    NSLog(@"person's age <= 30: %@", [people filteredArrayUsingPredicate:predicate]);

    NSLog(@"------------------------------------------\n");
    
    // case 2: LIKE
    NSPredicate *predicateLIKE1 = [NSPredicate predicateWithFormat:@"firstName LIKE 'Al*'"];
    NSLog(@"names begin with 'Al': %@", [people filteredArrayUsingPredicate:predicateLIKE1]);
    
    left = [NSExpression expressionForKeyPath:@"firstName"];
    right = [NSExpression expressionForConstantValue:@"Al*"];
    predicate = [NSComparisonPredicate predicateWithLeftExpression:left rightExpression:right modifier:NSDirectPredicateModifier type:NSLikePredicateOperatorType options:kNilOptions];
    NSLog(@"names begin with 'Al': %@", [people filteredArrayUsingPredicate:predicate]);
}

@end
