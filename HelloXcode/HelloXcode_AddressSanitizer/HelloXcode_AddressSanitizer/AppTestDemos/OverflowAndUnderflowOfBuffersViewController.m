//
//  OverflowAndUnderflowOfBuffersViewController.m
//  HelloXcode_AddressSanitizer
//
//  Created by wesley_chen on 2018/11/16.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "OverflowAndUnderflowOfBuffersViewController.h"

@interface OverflowAndUnderflowOfBuffersViewController ()

@end

@implementation OverflowAndUnderflowOfBuffersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test_case1_out_of_bounds_access_of_global_variable];
    [self test_case2_out_of_bounds_access_of_heap_allocated_variable];
    [self test_case3_out_of_bounds_access_of_stack_allocated_variable];
}

#pragma mark - Test Methods

int global_array[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};

// Case: Global, Heap, and Stack Overflows in C
- (void)test_case1_out_of_bounds_access_of_global_variable {
    int idx = 10;
    global_array[idx] = 42; // Error: out of bounds access of global variable
}

- (void)test_case2_out_of_bounds_access_of_heap_allocated_variable {
    int idx = 10;
    char *heap_buffer = malloc(10);
    heap_buffer[idx] = 'x'; // Error: out of bounds access of heap allocated variable
}

- (void)test_case3_out_of_bounds_access_of_stack_allocated_variable {
    int idx = 10;
    char stack_buffer[10];
    stack_buffer[idx] = 'x'; // Error: out of bounds access of stack allocated variable
}

@end
