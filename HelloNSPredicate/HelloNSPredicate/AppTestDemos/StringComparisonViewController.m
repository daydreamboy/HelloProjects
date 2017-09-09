//
//  StringComparisonViewController.m
//  HelloNSPredicate
//
//  Created by wesley_chen on 09/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "StringComparisonViewController.h"
#import "AppDelegate.h"

#ifndef NSPREDICATE
#define NSPREDICATE(expression) ([NSPredicate predicateWithFormat:@"SELF MATCHES %@", expression])
#endif

@interface StringComparisonViewController ()

@end

@implementation StringComparisonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    NSArray *people = [AppDelegate people];

    // Note:
    // BEGINSWITH
    // CONTAINS
    // ENDSWITH
    // LIKE
    // MATCHES

    // case 1: BEGINSWITH
    NSPredicate *predicateBEGINSWITH = [NSPredicate predicateWithFormat:@"(firstName BEGINSWITH %@) OR (lastName BEGINSWITH %@)", @"A", @"A"];
    NSLog(@"names begin with 'A': %@", [people filteredArrayUsingPredicate:predicateBEGINSWITH]);
    
    NSLog(@"------------------------------------------\n");
    
    // case 2: CONTAINS
    NSPredicate *predicateCONTAINS1 = [NSPredicate predicateWithFormat:@"(firstName CONTAINS %@) OR (lastName CONTAINS %@)", @"S", @"S"];
    NSLog(@"names contain 'S': %@", [people filteredArrayUsingPredicate:predicateCONTAINS1]);
    
    NSPredicate *predicateCONTAINS2 = [NSPredicate predicateWithFormat:@"(firstName CONTAINS[cd] %@) OR (lastName CONTAINS[cd] %@)", @"S", @"S"];
    NSLog(@"names contain 'S' or 's': %@", [people filteredArrayUsingPredicate:predicateCONTAINS2]);
    
    NSLog(@"------------------------------------------\n");

    // case 3: ENDSWITH
    NSPredicate *predicateENDSWITH = [NSPredicate predicateWithFormat:@"(firstName ENDSWITH[cd] %@) OR (lastName ENDSWITH[cd] %@)", @"E", @"E"];
    NSLog(@"names end with 'E' or 'e': %@", [people filteredArrayUsingPredicate:predicateENDSWITH]);
    
    NSLog(@"------------------------------------------\n");
    
    // case 4: LIKE
    // Note: * and ? must be quoted in literal
    NSPredicate *predicateLIKE1 = [NSPredicate predicateWithFormat:@"(firstName LIKE 'Al*') OR (lastName LIKE 'Al*')"];
    NSLog(@"names begin with 'Al': %@", [people filteredArrayUsingPredicate:predicateLIKE1]);
    
    NSPredicate *predicateLIKE2 = [NSPredicate predicateWithFormat:@"(firstName LIKE '?o*') OR (lastName LIKE '?o*')"];
    NSLog(@"names 2nd char is o: %@", [people filteredArrayUsingPredicate:predicateLIKE2]);
    
    NSPredicate *predicateLIKE3 = [NSPredicate predicateWithFormat:@"(firstName LIKE '*l*e*') OR (lastName LIKE '*l*e*')"];
    NSLog(@"names match *l*e*: %@", [people filteredArrayUsingPredicate:predicateLIKE3]);
    
    // Note: when substituted, no need to quote '%@'
    NSString *wildcard = @"*l?e*";
    NSPredicate *predicateLIKE4 = [NSPredicate predicateWithFormat:@"(firstName LIKE %@) OR (lastName LIKE %@)", wildcard, wildcard];
    NSLog(@"names match *l?e*: %@", [people filteredArrayUsingPredicate:predicateLIKE4]);
    
    NSLog(@"------------------------------------------\n");
    
    // case 5
    NSString *regExp = @"^J[A-Za-z]*s$";
    NSPredicate *predicateMATCHES1 = [NSPredicate predicateWithFormat:@"lastName MATCHES %@", regExp];
    NSLog(@"names match '^J[A-Za-z]*s$': %@", [people filteredArrayUsingPredicate:predicateMATCHES1]);
    
    regExp = @"^[A-Za-z]{5}$";
    NSPredicate *predicateMATCHES2 = [NSPredicate predicateWithFormat:@"(firstName MATCHES %@) OR (lastName MATCHES %@)", regExp, regExp];
    NSLog(@"names length is 5: %@", [people filteredArrayUsingPredicate:predicateMATCHES2]);
    
    //  - 以1开头的11位数字
    //  - 不能重复1的11位数字
    NSString *text = @"12345678901";
    if (![NSPREDICATE(@"^1\\d{10}$") evaluateWithObject:text]
        || [NSPREDICATE(@"^(1)\\1{10}$") evaluateWithObject:text]) {
        NSLog(@"invalid phone number");
    }
    else {
        NSLog(@"correct phone number");
    }
    
    text = @"123@123.cn";
    if (![NSPREDICATE(@"^[\\w-]+(\\.[\\w-]+)*@[\\w-]+(\\.[\\w-]+)+$") evaluateWithObject:text]) {
        NSLog(@"invalid email");
    }
    else {
        NSLog(@"correct email");
    }
    
    text = @"abcABC";
    if ([NSPREDICATE(@"^[A-Za-z]*$") evaluateWithObject:text]) {
        NSLog(@"alphabet");
    }
    else {
        NSLog(@"not alphabet");
    }
    
    text = @"0123456789";
    if ([NSPREDICATE(@"^[0-9]*$") evaluateWithObject:text]) {
        NSLog(@"numeric");
    }
    else {
        NSLog(@"not numeric");
    }
    
    text = @"中文";
    if ([NSPREDICATE(@"^[\u4e00-\u9fa5]*$") evaluateWithObject:text]) {
        NSLog(@"contains chinese characters");
    }
    else {
        NSLog(@"not contains chinese characters");
    }
}

@end
