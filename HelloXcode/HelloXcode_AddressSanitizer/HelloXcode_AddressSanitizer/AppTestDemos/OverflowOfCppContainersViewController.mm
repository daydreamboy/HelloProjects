//
//  OverflowOfCppContainersViewController.m
//  HelloXcode_AddressSanitizer
//
//  Created by wesley_chen on 2018/11/16.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "OverflowOfCppContainersViewController.h"
#include <vector>

@interface OverflowOfCppContainersViewController ()

@end

@implementation OverflowOfCppContainersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
}

#pragma mark - Test Methods

// Case: Vector Overflow in C++
- (int)test {
    // Note: To enable this check, set the Enable C++ Container Overflow Checks for Address Sanitizer build setting to YES.
    std::vector<int> vector;
    
    vector.push_back(0);
    vector.push_back(1);
    vector.push_back(2);
    
    auto *pointer = &vector[0];
    return pointer[3]; // Error: out of bounds access for vector
}

@end
