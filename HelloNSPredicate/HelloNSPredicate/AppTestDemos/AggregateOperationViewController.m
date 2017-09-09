//
//  AggregateOperationViewController.m
//  HelloNSPredicate
//
//  Created by wesley_chen on 09/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "AggregateOperationViewController.h"
#import "AppDelegate.h"

#define STR_BOOL(yesOrNo) ((yesOrNo) ? @"YES" : @"NO")

@interface AggregateOperationViewController ()

@end

@implementation AggregateOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *people = [AppDelegate people];
    
    // @see http://nshipster.com/nspredicate/
    // Note:
    // ANY, SOME
    // ALL
    // NONE
    // IN
    // array[FIRST]
    // array[LAST]
    // array[index]
    // array[SIZE]
    // TRUEPREDICATE, FALSEPREDICATE
    
    // case 1: ANY, SOME (only for boolean evaluation)
    NSPredicate *predicateANY = [NSPredicate predicateWithFormat:@"ANY age < 30"];
    NSLog(@"ANY person's age is under 30: %@", STR_BOOL([predicateANY evaluateWithObject:people]));

    NSPredicate *predicateSOME = [NSPredicate predicateWithFormat:@"SOME age < 30"];
    NSLog(@"SOME person's age is under 30: %@", STR_BOOL([predicateSOME evaluateWithObject:people]));

    NSLog(@"------------------------------------------\n");
    
    // case 2: ALL (only for boolean evaluation)
    NSPredicate *predicateALL = [NSPredicate predicateWithFormat:@"ALL age < 30"];
    NSLog(@"ALL person's age is under 30: %@", STR_BOOL([predicateALL evaluateWithObject:people]));
    
    NSLog(@"------------------------------------------\n");
    
    // case 3: NONE (only for boolean evaluation)
    NSPredicate *predicateNONE = [NSPredicate predicateWithFormat:@"NONE age < 30"];
    NSLog(@"NONE person's age is under 30: %@", STR_BOOL([predicateNONE evaluateWithObject:people]));
    
    NSLog(@"------------------------------------------\n");
    
    // case 4: IN
    NSArray *arr = @[@27, @31, @35];
    NSPredicate *predicateIN1 = [NSPredicate predicateWithFormat:@"age IN %@", arr];
    NSLog(@"person's age in (27, 31, 35): %@", [people filteredArrayUsingPredicate:predicateIN1]);
    
    NSSet *set = [NSSet setWithArray:arr];
    NSPredicate *predicateIN2 = [NSPredicate predicateWithFormat:@"age IN %@", set];
    NSLog(@"person's age in (27, 31, 35): %@", [people filteredArrayUsingPredicate:predicateIN2]);
    
    // Note: consider only values for NSDictionary
    NSDictionary *dict = @{
                           @"key": @27,
                           @31: @"value",
                           @"key2": @33,
                           };
    NSPredicate *predicateIN3 = [NSPredicate predicateWithFormat:@"age IN %@", dict];
    NSLog(@"person's age in (27, 31, 35): %@", [people filteredArrayUsingPredicate:predicateIN3]);
    
    NSLog(@"------------------------------------------\n");
    
    // @see https://stackoverflow.com/questions/42520354/using-nspredicates-arrayfirst-operator
    
    // case 5: array[FIRST]
    NSArray *numbers = @[@1, @2, @3];
    
    NSPredicate *predicateFIRST1 = [NSPredicate predicateWithFormat:@"SELF[FIRST] == %@", @1];
    NSLog(@"SELF[FIRST] == %%@: %@", STR_BOOL([predicateFIRST1 evaluateWithObject:numbers]));
    
    NSPredicate *predicateFIRST2 = [NSPredicate predicateWithFormat:@"SELF[FIRST] == %@", @2];
    NSLog(@"SELF[FIRST] == %%@: %@", STR_BOOL([predicateFIRST2 evaluateWithObject:numbers]));
    
    NSPredicate *predicateFIRST3 = [NSPredicate predicateWithFormat:@"%@[FIRST] == SELF", numbers];
    NSLog(@"%%@[FIRST] == SELF: %@", STR_BOOL([predicateFIRST3 evaluateWithObject:@1]));
    
    NSPredicate *predicateFIRST4 = [NSPredicate predicateWithFormat:@"%@[FIRST] == SELF", numbers];
    NSLog(@"%%@[FIRST] == SELF: %@", STR_BOOL([predicateFIRST4 evaluateWithObject:@2]));
    
    NSLog(@"------------------------------------------\n");
    
    // case 6: array[LAST]
    NSPredicate *predicateLAST1 = [NSPredicate predicateWithFormat:@"SELF[LAST] == %@", @3];
    NSLog(@"SELF[LAST] == %%@: %@", STR_BOOL([predicateLAST1 evaluateWithObject:numbers]));
    
    NSPredicate *predicateLAST2 = [NSPredicate predicateWithFormat:@"SELF[LAST] == %@", @2];
    NSLog(@"SELF[LAST] == %%@: %@", STR_BOOL([predicateLAST2 evaluateWithObject:numbers]));
    
    NSLog(@"------------------------------------------\n");
    
    // case 7: array[index]
    NSPredicate *predicateINDEX1 = [NSPredicate predicateWithFormat:@"SELF[1] == %@", @3];
    NSLog(@"SELF[1] == %%@: %@", STR_BOOL([predicateINDEX1 evaluateWithObject:numbers]));
    
    NSPredicate *predicateINDEX2 = [NSPredicate predicateWithFormat:@"SELF[1] == %@", @2];
    NSLog(@"SELF[1] == %%@: %@", STR_BOOL([predicateINDEX2 evaluateWithObject:numbers]));
    
    NSLog(@"------------------------------------------\n");
    
    // case 8: array[SIZE]
    NSPredicate *predicateSIZE1 = [NSPredicate predicateWithFormat:@"SELF[SIZE] == %@", @3];
    NSLog(@"SELF[SIZE] == %%@: %@", STR_BOOL([predicateSIZE1 evaluateWithObject:numbers]));
    
    NSPredicate *predicateSIZE2 = [NSPredicate predicateWithFormat:@"SELF[SIZE] == %@", @2];
    NSLog(@"SELF[SIZE] == %%@: %@", STR_BOOL([predicateSIZE2 evaluateWithObject:numbers]));
    
    NSLog(@"------------------------------------------\n");
    
    // case 9: TRUEPREDICATE, FALSEPREDICATE
    NSPredicate *predicateTRUEPREDICATE = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
    NSLog(@"persons (always TRUE): %@", [people filteredArrayUsingPredicate:predicateTRUEPREDICATE]);
    
    NSPredicate *predicateFALSEPREDICATE = [NSPredicate predicateWithFormat:@"FALSEPREDICATE"];
    NSLog(@"persons (always FALSE): %@", [people filteredArrayUsingPredicate:predicateFALSEPREDICATE]);
    
    NSLog(@"always TRUE: %@", STR_BOOL([predicateTRUEPREDICATE evaluateWithObject:nil]));
    NSLog(@"always FALSE: %@", STR_BOOL([predicateFALSEPREDICATE evaluateWithObject:nil]));
}

@end
