//
//  UseOfOutOfScopeStackMemoryViewController.m
//  HelloXcode_AddressSanitizer
//
//  Created by wesley_chen on 2018/11/16.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseOfOutOfScopeStackMemoryViewController.h"

@interface UseOfOutOfScopeStackMemoryViewController ()

@end

@implementation UseOfOutOfScopeStackMemoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test];
}

#pragma mark - Test Methods

// Case: Use of Out-of-Scope Stack Memory in C
- (void)test {
    int *pointer = NULL;
    if (bool_returning_function()) {
        int value = integer_returning_function();
        pointer = &value;
    }
    *pointer = 42; // Error: invalid access of stack memory out of declaration scope
}

int integer_returning_function() {
    int value = 41;
    return value;
}

bool bool_returning_function() {
    return true;
}

@end
