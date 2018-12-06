//
//  BasicComparisonViewController.m
//  HelloNSPredicate
//
//  Created by wesley_chen on 09/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "BasicComparisonViewController.h"
#import "Person.h"

@interface BasicComparisonViewController ()

@end

@implementation BasicComparisonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *people = [Person people];
    
    // Note: basic comparisons
    // =, ==
    // >=, =>
    // <=, =<
    // >
    // <
    // !=, <>
    // BETWEEN keyword
    
    // case 1: =, ==
    NSPredicate *predicateEqual1 = [NSPredicate predicateWithFormat:@"%K = %@", @"firstName", @"Alice"];
    NSLog(@"firstName is Alice: %@", [people filteredArrayUsingPredicate:predicateEqual1]);
    
    NSPredicate *predicateEqual2 = [NSPredicate predicateWithFormat:@"%K == %@", @"firstName", @"Alice"];
    NSLog(@"firstName is Alice: %@", [people filteredArrayUsingPredicate:predicateEqual2]);
    
    NSLog(@"------------------------------------------\n");
    
    // case 2: !=, <>
    NSPredicate *predicateNotEqual1 = [NSPredicate predicateWithFormat:@"%K != %@", @"lastName", @"Smith"];
    NSLog(@"lastName is NOT Smith: %@", [people filteredArrayUsingPredicate:predicateNotEqual1]);
    
    NSPredicate *predicateNotEqual2 = [NSPredicate predicateWithFormat:@"%K <> %@", @"lastName", @"Smith"];
    NSLog(@"lastName is NOT Smith: %@", [people filteredArrayUsingPredicate:predicateNotEqual2]);
    
    NSLog(@"------------------------------------------\n");
    
    // case 3: >=, =>
    NSPredicate *predicateAgeGE31_1 = [NSPredicate predicateWithFormat:@"%K >= %@", @"age", @31];
    NSLog(@"ages >= 31: %@", [people filteredArrayUsingPredicate:predicateAgeGE31_1]);
    
    NSPredicate *predicateAgeGE31_2 = [NSPredicate predicateWithFormat:@"%K => %@", @"age", @31];
    NSLog(@"ages >= 31: %@", [people filteredArrayUsingPredicate:predicateAgeGE31_2]);
    
    NSLog(@"------------------------------------------\n");
    
    // case 4: BETWEEN
    NSDictionary *dict1 = @{
                            @"attributeName": @5,
                            };
    
    NSDictionary *dict2 = @{
                            @"attributeName": @1,
                            };
    
    NSDictionary *dict3 = @{
                            @"attributeName": @11,
                            };
    
    // Note: syntax `variable BETWEEN @[lower, upper]` (from Predicate Programming Guide)
    NSPredicate *betweenPredicate = [NSPredicate predicateWithFormat:@"attributeName BETWEEN %@", @[@1, @10]];
    
    NSString *between1 = [betweenPredicate evaluateWithObject:dict1] ? @"is" : @"is not";
    NSLog(@"%@ %@ between [1, 10]", dict1[@"attributeName"], between1);
    
    NSString *between2 = [betweenPredicate evaluateWithObject:dict2] ? @"is" : @"is not";
    NSLog(@"%@ %@ between [1, 10]", dict2[@"attributeName"], between2);
    
    NSString *between3 = [betweenPredicate evaluateWithObject:dict3] ? @"is" : @"is not";
    NSLog(@"%@ %@ between [1, 10]", dict3[@"attributeName"], between3);
}

@end
