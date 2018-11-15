//
//  DeallocateAlreadyDeallocatedMemoryViewController.m
//  HelloXcode_AddressSanitizer
//
//  Created by wesley_chen on 2018/11/16.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "DeallocateAlreadyDeallocatedMemoryViewController.h"

@interface DeallocateAlreadyDeallocatedMemoryViewController ()

@end

@implementation DeallocateAlreadyDeallocatedMemoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test];
}

#pragma mark - Test Methods

// Case: Deallocation of Freed Memory in C
- (void)test {
    int *pointer = malloc(sizeof(int));
    free(pointer);
    free(pointer); // Error: free called twice with the same memory address
}

@end
