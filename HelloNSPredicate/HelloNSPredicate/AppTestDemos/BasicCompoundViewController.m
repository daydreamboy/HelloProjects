//
//  BasicCompoundViewController.m
//  HelloNSPredicate
//
//  Created by wesley_chen on 09/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "BasicCompoundViewController.h"
#import "Person.h"

@interface BasicCompoundViewController ()

@end

@implementation BasicCompoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *people = [Person people];
    
    // Note:
    // AND, &&
    // OR, ||
    // NOT, !
    
    // case 1: AND, &&
    NSPredicate *predicateAND1 = [NSPredicate predicateWithFormat:@"(%K == %@) AND (%K == %@)", @"lastName", @"Smith", @"age", @24];
    NSLog(@"last name is Smith AND age is 24: %@", [people filteredArrayUsingPredicate:predicateAND1]);
    
    NSPredicate *predicateAND2 = [NSPredicate predicateWithFormat:@"(%K == %@) && (%K == %@)", @"lastName", @"Smith", @"age", @24];
    NSLog(@"last name is Smith AND age is 24: %@", [people filteredArrayUsingPredicate:predicateAND2]);
    
    NSLog(@"------------------------------------------\n");
    
    // case 2: OR, ||
    NSPredicate *predicateOR1 = [NSPredicate predicateWithFormat:@"(%K == %@) OR (%K == %@)", @"firstName", @"Bob", @"age", @31];
    NSLog(@"firstName name is Bob OR age is 31: %@", [people filteredArrayUsingPredicate:predicateOR1]);
    
    NSPredicate *predicateOR2 = [NSPredicate predicateWithFormat:@"(%K == %@) || (%K == %@)", @"firstName", @"Bob", @"age", @31];
    NSLog(@"firstName name is Bob OR age is 31: %@", [people filteredArrayUsingPredicate:predicateOR2]);
    
    NSLog(@"------------------------------------------\n");
    
    // case 3: NOT, !
    NSPredicate *predicateNOT1 = [NSPredicate predicateWithFormat:@"NOT (%K == %@)", @"lastName", @"Smith"];
    NSLog(@"lastName name is NOT Smith: %@", [people filteredArrayUsingPredicate:predicateNOT1]);
    
    NSPredicate *predicateNOT2 = [NSPredicate predicateWithFormat:@"! (%K == %@)", @"lastName", @"Smith"];
    NSLog(@"lastName name is NOT Smith: %@", [people filteredArrayUsingPredicate:predicateNOT2]);
    
    NSLog(@"------------------------------------------\n");
}

@end
