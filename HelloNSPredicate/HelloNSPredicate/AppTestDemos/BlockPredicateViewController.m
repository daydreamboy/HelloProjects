//
//  BlockPredicateViewController.m
//  HelloNSPredicate
//
//  Created by wesley_chen on 10/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "BlockPredicateViewController.h"
#import "AppDelegate.h"

@interface BlockPredicateViewController ()

@end

@implementation BlockPredicateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *people = [AppDelegate people];
    
    // Note: NSPredicates created with predicateWithBlock: cannot be used for Core Data fetch requests backed by a SQLite store.
    // @see http://nshipster.com/nspredicate/
    
    NSPredicate *shortNamePredicate1 = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [[evaluatedObject firstName] length] <= 5;
    }];
    // ["Alice Smith", "Bob Jones"]
    NSLog(@"Short Names: %@", [people filteredArrayUsingPredicate:shortNamePredicate1]);
    
    NSPredicate *shortNamePredicate2 = [NSPredicate predicateWithFormat:@"firstName.length <= 5"];
    NSLog(@"Short Names: %@", [people filteredArrayUsingPredicate:shortNamePredicate2]);
}

@end
