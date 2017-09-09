//
//  SubstitutionViewController.m
//  HelloNSPredicate
//
//  Created by wesley_chen on 09/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "SubstitutionViewController.h"
#import "AppDelegate.h"

@interface SubstitutionViewController ()

@end

@implementation SubstitutionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *people = [AppDelegate people];
    
    NSString *variable = @"age";
    
    // Note: @see http://nshipster.com/nspredicate/
    // %K is a substitution for a key path (like attribute name)
    // %@ is a substitution for a object value, e.g. NSString, NSNumber (like attribute value)
    // $VARIABLE_NAME is another substitution for predicateWithSubstitutionVariables: method
    
    // case 1: %K and %@
    NSPredicate *predicateAgeIs33 = [NSPredicate predicateWithFormat:@"%K == %@", variable, @33];
    NSLog(@"Age 33: %@", [people filteredArrayUsingPredicate:predicateAgeIs33]);

    // case 2: %K and %@
    variable = @"lastName";
    NSPredicate *predicateLastNameIsSmith = [NSPredicate predicateWithFormat:@"%K == %@", variable, @"Smith"];
    NSLog(@"last name is Smith: %@", [people filteredArrayUsingPredicate:predicateLastNameIsSmith]);
    
    // case 3: use literal attribute name instead of %K
    NSPredicate *predicateFirstNameIsSmith = [NSPredicate predicateWithFormat:@"firstName == %@", @"Smith"];
    NSLog(@"first name is Smith: %@", [people filteredArrayUsingPredicate:predicateFirstNameIsSmith]);
    
    // case 4: use $VARIABLE_NAME
    // Note: BEGINSWITH is case and diacritic sensitive by default
    //       BEGINSWITH[cd] - c for case insensitive
    //       BEGINSWITH[cd] - d for diacritic insensitive
    NSString *format = @"(firstName BEGINSWITH[cd] $letter) OR (lastName BEGINSWITH[cd] $letter)";
    NSPredicate *predicateNamesBeginningWithLetter = [NSPredicate predicateWithFormat:format];
    // replace $letter with A
    NSPredicate *finalPredicate = [predicateNamesBeginningWithLetter predicateWithSubstitutionVariables:@{@"letter": @"A"}];
    NSLog(@"Begin with 'A' names: %@", [people filteredArrayUsingPredicate:finalPredicate]);
}

@end
