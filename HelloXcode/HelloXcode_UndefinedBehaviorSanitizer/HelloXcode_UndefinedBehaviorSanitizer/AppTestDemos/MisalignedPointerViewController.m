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
    [self solution_Misaligned_Integer_Pointer_Assignment_in_C];
    [self test_Misaligned_Structure_Pointer_Assignment_in_C];
    [self solution_Misaligned_Structure_Pointer_Assignment_in_C];
}

#pragma mark - Test Methods

- (void)test_Misaligned_Integer_Pointer_Assignment_in_C {
    int8_t *buffer = malloc(64);
    printf("%s: %p\n", [NSStringFromSelector(_cmd) UTF8String], buffer);
    int32_t *pointer = (int32_t *)(buffer + 1);
    *pointer = 42; // Error: misaligned integer pointer assignment
    printf("%d\n", *pointer); // Error: misaligned integer pointer access
}

- (void)solution_Misaligned_Integer_Pointer_Assignment_in_C {
    int8_t *buffer = malloc(64);
    printf("%s: %p\n", [NSStringFromSelector(_cmd) UTF8String], buffer);
    int32_t value = 42;
    memcpy(buffer + 1, &value, sizeof(int32_t)); // Correct
}

- (void)test_Misaligned_Structure_Pointer_Assignment_in_C {
    struct A {
        int32_t i32;
        int64_t i64;
    };
    
    int8_t *buffer = malloc(32);
    printf("%s: %p\n", [NSStringFromSelector(_cmd) UTF8String], buffer);
    struct A *pointer = (struct A *)(buffer + 1);
    pointer->i32 = 7; // Error: pointer is misaligned
    pointer->i64 = 8; // Error: pointer is misaligned
}

- (void)solution_Misaligned_Structure_Pointer_Assignment_in_C {
    struct A {
        int32_t i32;
        int64_t i64;
    } __attribute__((packed));
    
    int8_t *buffer = malloc(32);
    printf("%s: %p\n", [NSStringFromSelector(_cmd) UTF8String], buffer);
    struct A *pointer = (struct A *)(buffer + 1);
    pointer->i32 = 7;
    pointer->i64 = 8;
}

@end
