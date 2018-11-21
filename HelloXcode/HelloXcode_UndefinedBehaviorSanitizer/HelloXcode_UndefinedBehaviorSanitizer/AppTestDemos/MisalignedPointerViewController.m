//
//  MisalignedPointerViewController.m
//  HelloXcode_UndefinedBehaviorSanitizer
//
//  Created by wesley_chen on 2018/11/21.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "MisalignedPointerViewController.h"

@interface MisalignedPointerViewController ()

@end

@implementation MisalignedPointerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test_Misaligned_Integer_Pointer_Assignment_in_C];
}

#pragma mark - Test Methods

- (void)test_Misaligned_Integer_Pointer_Assignment_in_C {
    int8_t *buffer = malloc(64);
    int32_t *pointer = (int32_t *)(buffer + 1);
    *pointer = 42; // Error: misaligned integer pointer assignment
    printf("%d", *pointer);
}

@end
