//
//  DeallocateNonallocatedMemoryViewController.m
//  HelloXcode_AddressSanitizer
//
//  Created by wesley_chen on 2018/11/16.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "DeallocateNonallocatedMemoryViewController.h"

@interface DeallocateNonallocatedMemoryViewController ()

@end

@implementation DeallocateNonallocatedMemoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
}

// Case: Deallocation of a Stack Variable in C
- (void)test {
    int value = 42;
    free(&value); // Error: free called on stack allocated variable
}

@end
