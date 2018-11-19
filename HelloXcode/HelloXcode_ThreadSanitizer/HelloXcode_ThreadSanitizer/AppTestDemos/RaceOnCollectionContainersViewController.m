//
//  RaceOnCollectionContainersViewController.m
//  HelloXcode_ThreadSanitizer
//
//  Created by wesley_chen on 2018/11/19.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "RaceOnCollectionContainersViewController.h"

@interface RaceOnCollectionContainersViewController ()

@end

@implementation RaceOnCollectionContainersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test_Collection_Race_with_a_Mutable_Array];
    [self test_Collection_Race_with_a_Mutable_Dictionary];
}

#pragma mark - Test Methods

- (void)test_Collection_Race_with_a_Mutable_Array {
    NSMutableArray *array = [NSMutableArray new];
    __block NSInteger sum = 0;
    // Executed on Thread #1
    [NSThread detachNewThreadWithBlock:^{
        for (id value in array) {
            sum += [value integerValue];
        }
    }];
    
    // Executed on Thread #2
    [NSThread detachNewThreadWithBlock:^{
        [array addObject:@42]; // WARNING: Data race here!
    }];
}

- (void)test_Collection_Race_with_a_Mutable_Dictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    __block NSInteger sum = 0;
    // Executed on Thread #1
    [NSThread detachNewThreadWithBlock:^{
        for (id key in dictionary) {
            sum += [dictionary[key] integerValue];
        }
    }];
    
    // Executed on Thread #2
    [NSThread detachNewThreadWithBlock:^{
        dictionary[@"forty-two"] = @42; // WARNING: Data race here!
    }];
}

@end
