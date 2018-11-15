//
//  UseofStackMemoryAfterFunctionReturnViewController.m
//  HelloXcode_AddressSanitizer
//
//  Created by wesley_chen on 2018/11/16.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseofStackMemoryAfterFunctionReturnViewController.h"

@interface UseofStackMemoryAfterFunctionReturnViewController ()
@end

@implementation UseofStackMemoryAfterFunctionReturnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test];
}

#pragma mark - Test Methods

// Case: Use of Stack Memory After Return in C
- (void)test {
    int *integer_pointer = integer_pointer_returning_function();
    // Note: Turn on Diagnostics -> Address Sanitizer -> Detect use of stack after return
    *integer_pointer = 43;
    // Error: invalid access of returned stack memory
}

int *integer_pointer_returning_function() {
    int value = 42;
    return &value;
}

@end
